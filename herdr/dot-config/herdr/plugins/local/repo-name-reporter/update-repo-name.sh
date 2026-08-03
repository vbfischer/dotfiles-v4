#!/usr/bin/env bash
# Reports the focused/opened workspace's git repo name as a "$repo" sidebar token.
# Context JSON schema is undocumented, so log it once for troubleshooting and
# fall back to `herdr pane list` when the cwd isn't in the context.
set -euo pipefail

SOURCE="repo-name-reporter"

if [[ -n "${HERDR_PLUGIN_STATE_DIR:-}" ]]; then
    printf '%s' "${HERDR_PLUGIN_CONTEXT_JSON:-}" >"$HERDR_PLUGIN_STATE_DIR/last-context.json" 2>/dev/null || true
fi

ctx="${HERDR_PLUGIN_CONTEXT_JSON:-}"
[[ -z "$ctx" ]] && ctx='{}'

workspace_id=$(jq -r '.workspace_id // empty' <<<"$ctx")
cwd=$(jq -r '.workspace_cwd // .focused_pane_cwd // empty' <<<"$ctx")
pane_id=$(jq -r '.focused_pane_id // empty' <<<"$ctx")

# Fall back to the socket API when the context doesn't carry what we need.
if [[ -z "$workspace_id" || -z "$cwd" || -z "$pane_id" ]]; then
    current_pane=$(herdr pane current --current 2>/dev/null || true)
    workspace_id="${workspace_id:-$(jq -r '.result.pane.workspace_id // empty' <<<"$current_pane")}"
    cwd="${cwd:-$(jq -r '.result.pane.cwd // empty' <<<"$current_pane")}"
    pane_id="${pane_id:-$(jq -r '.result.pane.pane_id // empty' <<<"$current_pane")}"
fi

[[ -z "$workspace_id" || -z "$cwd" ]] && exit 0

# --git-common-dir resolves to the main repo's .git dir even from a linked
# worktree, so worktree checkouts (e.g. "main", "feat-x") report the actual
# repo name instead of the worktree folder name.
common_git_dir=$(git -C "$cwd" rev-parse --git-common-dir 2>/dev/null) || exit 0
repo_name=$(basename "$(cd "$cwd" && cd "$(dirname "$common_git_dir")" && pwd)")

herdr workspace report-metadata "$workspace_id" --source "$SOURCE" --token "repo=$repo_name"

# Also report on the pane, so [ui.sidebar.agents] rows (pane-scoped tokens)
# can show $repo alongside the agent row, not just the workspace/space row.
if [[ -n "$pane_id" ]]; then
    herdr pane report-metadata "$pane_id" --source "$SOURCE" --token "repo=$repo_name"
fi
