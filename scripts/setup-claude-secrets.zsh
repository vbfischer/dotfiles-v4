#!/usr/bin/env zsh
# Registers the Obsidian MCP server for Claude Code, reading its key from 1Password.
# The server is stored at user scope in ~/.claude.json (not settings.json), so the
# key never lives in the stowed dotfiles. Re-run after rotating the key.
#
# 1Password item (vault "Private"): Obsidian API Key / credential
#
# Uses the Local REST API plugin's non-encrypted HTTP port (27123) because the
# HTTPS port uses a self-signed cert that Claude Code rejects.
#
# The github MCP server is intentionally not managed here: user scope applies to
# every project, and replacing its token could break work repo access.
set -euo pipefail

OBSIDIAN_URL="http://127.0.0.1:27123/mcp/"

OBSIDIAN_KEY=$(op read "op://Private/Obsidian API Key/credential")

claude mcp remove obsidian --scope user >/dev/null 2>&1 || true
claude mcp add --scope user --transport http obsidian "$OBSIDIAN_URL" \
    --header "Authorization: Bearer $OBSIDIAN_KEY" >/dev/null

echo "Registered obsidian MCP server"
