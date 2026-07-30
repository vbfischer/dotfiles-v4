---
name: git-conventions
description: Use when creating branches, writing commit messages, opening PRs, creating worktree, or reviewing git conventions in any RS microservice repo.
metadata:
  version: "1.0"
---

## When creating a branch

Format `<type>/<ticket-id>-<short-description>`

Types: `feature/`, `fix/`, `chore/`, `release`

```bash
git checkout -b feature/VPWU-1234-add-pagination
git checkout -b fix/VPWU-2312-null-patient
```

If there is no Jira ticket, see the NO-JIRA rules before creating the branch.

---

## When writing a commit message

Format: `<type>: <ticket-id> <short description>

Types: `feat:`, `fix:`, `refactor:`, `test:`, `chore:`

```
feat: VPWU-1234 Add popover
fix: VPWU-3423 fix z-index
```

Rules:
- Include the ticket ID - no exceptions unless the work qualifies as NO-JIRA
- All commits will be squashed before merge — individual commit messages on the branch don't need to be perfect, but the final squash message must follow the format


---

## When opening a PR

**Choose the right template** from `.github/PULL_REQUEST_TEMPLETE`. NOTE: Some projects might be mono-repos so ensure you check in the root of the project/mono-repo.

| Template | When to use |
|----------|-------------|
| `jira.md` | Feature work, behavior changes, security changes, data model changes, user-visible changes |
| `no-jira.md` | Low-risk operational work only (tests, docs, linting, patch dependency bumps) |

**For NO-JIRA PRs**, additionally:
- Add the `NO-JIRA` label
- Set Risk = Low in the template
---

## When reviewing a PR for convention compliance

Flag these as violations:
- Branch name doesn't match `<type>/<ticket-id>-<short-description>` format
- Commit message (or PR title, which becomes the squash message) missing the ticket ID
- Wrong PR template selected for the type of change (e.g. `no-jira.md` used for a feature)
- NO-JIRA template used for a feature, behavior change, API contract change, or data model change
- `NO-JIRA` label missing on a no-jira PR
- Risk level not set in the template

**Squash on merge** — always use **Squash and merge** in the GitHub UI, never a regular merge commit.

---

## NO-JIRA rules

Allowed for: tests, docs, linting, patch dependency bumps, build/tooling changes, README updates.

**Not allowed for:** new features, behavior changes, API contract changes, security changes, data model changes.

When unsure whether work qualifies, default to creating a Jira ticket and using `jira.md`.

## When creating a new worktree

This project uses a **bare repository** with worktrees for parallel development. Each branch gets its own directory.

**Directory structure:**
```
vcp-report-generator/
├── vcp-report-generator.git_bare/                # bare repo
├── main/                                          # main branch worktree
├── feature/VPWU-3610-add-pagination/              # feature worktree
└── chore/VPWU-3598-Dependabot/                     # chore worktree
```

**Creating a worktree:**
See instructions on creating new branches

The worktree directory must exactly mirror the full branch name (`<type>/<ticket-id>-<short-description>`), using subfolders for the `/` segment. Use snake_case for spaces or other awkward path segments within the description:

```bash
# From any existing worktree in the project
git worktree add -b <branch-name> ../<branch-name> main

# Examples:
git worktree add -b feature/VPWU-1234-add-pagination ../feature/VPWU-1234-add-pagination main
git worktree add -b chore/VPWU-9999-deps ../chore/VPWU-9999-deps main
```

**Rules:**
- Always branch from `main` (the last argument)
- Worktree directory path must be identical to the branch name — never shorten it to just the ticket ID
- Run `pnpm install` in the new worktree before starting work
- Branch name must still follow the `<type>/<ticket-id>-<short-description>` convention
- Commit messages should start with the ticket ID (e.g., `VPWU-1234`)

**Cleanup:**
```bash
git worktree remove <worktree-dir>
```

**Useful aliases** (defined in the bare repo config):
- `git wt-status` — show status across all worktrees
- `git clean-worktree` — interactive FZF picker to delete worktrees
- `git clean-gone` — delete branches whose upstream was deleted
