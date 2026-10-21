#!/usr/bin/env bash
# Copies Claude agents and skills from the dotfiles into the Obsidian vault as
# read-only notes so they can be embedded (![[...]]) in docs. Files in the dotfiles
# are the source of truth; re-run this after editing them.
set -euo pipefail

SRC="$HOME/dotfiles-v4/claude/dot-claude"
VAULT="$HOME/Obsidian/Programming"
DEST="$VAULT/📚 Tech Library/Claude Agents"

mkdir -p "$DEST"

write_note() {
    local src="$1" name="$2" rel="$3"
    {
        printf '> Generated from `%s` by `scripts/sync-claude-agents-to-obsidian.sh`. Edit the source file, not this note.\n\n' "$rel"
        printf '````markdown\n'
        cat "$src"
        printf '\n````\n'
    } > "$DEST/$name.md"
}

for f in "$SRC"/agents/*.md; do
    name="$(basename "$f" .md)"
    write_note "$f" "agent-$name" "claude/dot-claude/agents/$name.md"
done

for f in "$SRC"/skills/port-angular-feature/SKILL.md; do
    write_note "$f" "skill-port-angular-feature" "claude/dot-claude/skills/port-angular-feature/SKILL.md"
done

echo "Synced to $DEST"
