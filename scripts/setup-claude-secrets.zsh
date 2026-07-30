#!/usr/bin/env zsh
# Injects real secrets into ~/.claude/settings.json after `stow claude`.
# Adjust the op:// item paths below to match your actual 1Password items.
set -euo pipefail

SETTINGS="$HOME/.claude/settings.json"
GITHUB_PAT=$(op read "op://Private/GitHub PAT/token")
OBSIDIAN_KEY=$(op read "op://Private/Obsidian API Key/credential")

tmp=$(mktemp)
jq --arg gh "$GITHUB_PAT" --arg ob "$OBSIDIAN_KEY" \
  '.mcpServers.github.env.GITHUB_PERSONAL_ACCESS_TOKEN = $gh
   | .mcpServers.obsidian.env.OBSIDIAN_API_KEY = $ob' \
  "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"

echo "Injected secrets into $SETTINGS"
