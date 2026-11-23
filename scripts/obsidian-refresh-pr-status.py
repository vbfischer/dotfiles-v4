#!/usr/bin/env python3
"""Refresh PR state fields on Obsidian ticket hubs from GitHub.

Scans <vault>/Projects/*/*/*.md for hubs (`type: ticket`) that have a `pr` URL and
a `pr_status` other than Merged, queries GitHub GraphQL via `gh`, and rewrites only
these frontmatter fields: pr_status, pr_approvals, pr_unresolved,
pr_unresolved_human, pr_unresolved_copilot, pr_conflict, pr_ci, pr_checked.

Never touches `status`, `pr_note`, or the note body.

Designed to be run unattended (cron/launchd), not by Claude. It sets its own PATH,
takes a lock so runs never overlap, writes files atomically, and exits non-zero on
any problem so the scheduler can flag it.

Usage:
    obsidian-refresh-pr-status.py --dry-run     # show what would change
    obsidian-refresh-pr-status.py               # apply
    obsidian-refresh-pr-status.py --quiet       # only print changes/warnings (cron)
    obsidian-refresh-pr-status.py --vault PATH  # non-default vault

Exit codes: 0 ok, 1 warnings (fetch failure, closed-unmerged PR), 2 setup error
(gh missing or not authenticated, vault missing, another run in progress).

Cron example (every 30 min on weekdays, 8-18):
    */30 8-18 * * 1-5 /Users/bfischer/dotfiles-v4/scripts/obsidian-refresh-pr-status.py --quiet >> ~/Library/Logs/obsidian-pr-status.log 2>&1
Note: on macOS, cron needs Full Disk Access (System Settings > Privacy) to read
~/Obsidian, and `gh` must be able to read its keychain token from a cron session;
if that fails, export GH_TOKEN in the crontab or use launchd (LaunchAgent) instead.
"""

import argparse
import fcntl
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from datetime import date, datetime
from pathlib import Path

# cron starts with a minimal PATH; make sure Homebrew's gh is findable.
os.environ['PATH'] = os.pathsep.join(['/opt/homebrew/bin', '/usr/local/bin', os.environ.get('PATH', '')])

DEFAULT_VAULT = Path.home() / 'Obsidian' / 'Programming'
LOCK_FILE = Path(tempfile.gettempdir()) / 'obsidian-refresh-pr-status.lock'
SETUP_ERROR = 2
APPROVALS_NEEDED = 2
PR_URL = re.compile(r'^https://github\.com/([^/]+)/([^/]+)/pull/(\d+)/?$')

QUERY = """
query($owner: String!, $name: String!, $number: Int!, $cursor: String) {
  repository(owner: $owner, name: $name) {
    pullRequest(number: $number) {
      state
      merged
      mergeable
      latestOpinionatedReviews(first: 50) { nodes { state } }
      reviewThreads(first: 100, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { isResolved comments(first: 1) { nodes { author { login } } } }
      }
      commits(last: 1) { nodes { commit { statusCheckRollup { state } } } }
    }
  }
}
"""

CI_MAP = {
    'SUCCESS': 'green',
    'FAILURE': 'red',
    'ERROR': 'red',
    'PENDING': 'pending',
    'EXPECTED': 'pending',
}


def write_atomic(path, text):
    """Write via temp file + rename so Obsidian/sync never sees a half-written note."""
    fd, tmp = tempfile.mkstemp(dir=path.parent, prefix='.pr-status-', suffix='.tmp')
    try:
        with os.fdopen(fd, 'w', encoding='utf-8') as handle:
            handle.write(text)
        shutil.copymode(path, tmp)
        os.replace(tmp, path)
    except BaseException:
        os.unlink(tmp)
        raise


def check_gh():
    """Return an error message if gh is missing or unauthenticated, else None."""
    if not shutil.which('gh'):
        return 'gh not found on PATH'
    result = subprocess.run(['gh', 'auth', 'status'], capture_output=True, text=True)
    if result.returncode != 0:
        return f'gh is not authenticated: {(result.stderr or result.stdout).strip()}'
    return None


def gh_query(owner, name, number, cursor=None):
    cmd = [
        'gh', 'api', 'graphql',
        '-f', f'query={QUERY}',
        '-f', f'owner={owner}',
        '-f', f'name={name}',
        '-F', f'number={number}',
    ]
    if cursor:
        cmd += ['-f', f'cursor={cursor}']
    out = subprocess.run(cmd, capture_output=True, text=True, check=True, timeout=60).stdout
    return json.loads(out)['data']['repository']['pullRequest']


def fetch_pr(owner, name, number):
    """Return the PR with all review threads collected (paginated)."""
    pr = gh_query(owner, name, number)
    threads = list(pr['reviewThreads']['nodes'])
    page = pr['reviewThreads']['pageInfo']
    while page['hasNextPage']:
        more = gh_query(owner, name, number, page['endCursor'])
        threads += more['reviewThreads']['nodes']
        page = more['reviewThreads']['pageInfo']
    pr['threads'] = threads
    return pr


def compute_fields(pr, today):
    """Map a GitHub PR to hub frontmatter values. None means 'leave unchanged'."""
    approvals = sum(1 for r in pr['latestOpinionatedReviews']['nodes'] if r['state'] == 'APPROVED')

    human = copilot = 0
    for thread in pr['threads']:
        if thread['isResolved']:
            continue
        comments = thread['comments']['nodes']
        login = (comments[0]['author'] or {}).get('login', '') if comments else ''
        if login.lower().startswith('copilot'):
            copilot += 1
        else:
            human += 1

    rollup = pr['commits']['nodes'][0]['commit']['statusCheckRollup'] if pr['commits']['nodes'] else None
    ci = CI_MAP.get(rollup['state']) if rollup else None

    if pr['merged']:
        pr_status = 'Merged'
    elif pr['state'] == 'CLOSED':
        pr_status = None  # closed without merge: needs a human decision
    elif approvals >= APPROVALS_NEEDED and human + copilot == 0:
        pr_status = 'Approved'
    else:
        pr_status = 'Open'

    conflict = {'CONFLICTING': 'true', 'MERGEABLE': 'false'}.get(pr['mergeable'])  # UNKNOWN: leave

    return {
        'pr_status': pr_status,
        'pr_approvals': str(approvals),
        'pr_unresolved': str(human + copilot),
        'pr_unresolved_human': str(human),
        'pr_unresolved_copilot': str(copilot),
        'pr_conflict': conflict,
        'pr_ci': ci,
        'pr_checked': today,
    }


def split_frontmatter(lines):
    """Return (start, end) line indexes of the frontmatter body, or None."""
    if not lines or lines[0].rstrip('\n') != '---':
        return None
    for i in range(1, len(lines)):
        if lines[i].rstrip('\n') == '---':
            return 1, i
    return None


def read_field(lines, start, end, key):
    for i in range(start, end):
        m = re.match(rf'^{re.escape(key)}:\s*(.*?)\s*$', lines[i])
        if m:
            return m.group(1)
    return None


def apply_fields(lines, start, end, fields):
    """Set fields in the frontmatter. Returns (new_lines, [(key, old, new)])."""
    changes = []
    lines = list(lines)
    for key, new in fields.items():
        if new is None:
            continue
        for i in range(start, end):
            if re.match(rf'^{re.escape(key)}:', lines[i]):
                old = lines[i].split(':', 1)[1].strip()
                if old != new:
                    lines[i] = f'{key}: {new}\n'
                    changes.append((key, old, new))
                break
        else:
            lines.insert(end, f'{key}: {new}\n')
            end += 1
            changes.append((key, '(missing)', new))
    return lines, changes


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--vault', type=Path, default=DEFAULT_VAULT)
    parser.add_argument('--dry-run', action='store_true', help='print changes without writing')
    parser.add_argument('--quiet', action='store_true', help='only print hubs with changes, warnings and errors')
    args = parser.parse_args()

    def log(message):
        print(message, flush=True)

    lock = open(LOCK_FILE, 'w')
    try:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except OSError:
        print('ERROR: another run is in progress', file=sys.stderr)
        return SETUP_ERROR

    if not (args.vault / 'Projects').is_dir():
        print(f'ERROR: vault not found at {args.vault}', file=sys.stderr)
        return SETUP_ERROR
    gh_error = check_gh()
    if gh_error:
        print(f'ERROR: {gh_error}', file=sys.stderr)
        return SETUP_ERROR

    if not args.quiet:
        log(f'[{datetime.now().isoformat(timespec="seconds")}] refreshing PR status in {args.vault}')

    today = date.today().isoformat()
    hubs = sorted((args.vault / 'Projects').glob('*/*/*.md'))
    checked = changed = 0
    warnings = []

    for path in hubs:
        lines = path.read_text(encoding='utf-8').splitlines(keepends=True)
        fm = split_frontmatter(lines)
        if not fm:
            continue
        start, end = fm
        if read_field(lines, start, end, 'type') != 'ticket':
            continue
        pr_url = (read_field(lines, start, end, 'pr') or '').strip('"\'')
        if not PR_URL.match(pr_url):
            continue
        if read_field(lines, start, end, 'pr_status') == 'Merged':
            continue

        owner, name, number = PR_URL.match(pr_url).groups()
        key = read_field(lines, start, end, 'jiraKey') or path.stem
        try:
            pr = fetch_pr(owner, name, int(number))
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired, KeyError, TypeError, json.JSONDecodeError) as exc:
            warnings.append(f'{key}: could not fetch {pr_url}: {exc}')
            continue

        fields = compute_fields(pr, today)
        if fields['pr_status'] is None:
            warnings.append(f'{key}: PR #{number} is closed without merging; pr_status left unchanged')

        new_lines, changes = apply_fields(lines, start, end, fields)
        # pr_checked changes every day; only count a hub as changed for real state changes.
        real = [c for c in changes if c[0] != 'pr_checked']
        checked += 1
        label = f'{key} (#{number})'
        if real:
            changed += 1
            log(f'{label}:')
            for field, old, new in changes:
                log(f'  {field}: {old} -> {new}')
        elif not args.quiet:
            log(f'{label}: no change')
        if changes and not args.dry_run:
            write_atomic(path, ''.join(new_lines))

    if not args.quiet or changed:
        log(f'{checked} open-PR hubs checked, {changed} with state changes' + (' (dry run, nothing written)' if args.dry_run else ''))
    for w in warnings:
        print(f'WARNING: {w}', file=sys.stderr)
    return 1 if warnings else 0


if __name__ == '__main__':
    sys.exit(main())
