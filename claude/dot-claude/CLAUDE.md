# Claude Code — Global Configuration

## Memory Management

Claude Code uses a two-tier memory system:

1. **Global Memory** (`~/.claude/memory/`) — Cross-project knowledge, conventions, and preferences
2. **Repo Memory** (`<project>/memory/MEMORY.md`) — Project-specific context loaded automatically per session

### Global Memory Reference Rule
When working in any project, check `~/.claude/memory/` for relevant cross-project knowledge before starting work. Global memory supplements (never overrides) repo-level MEMORY.md.

### Repo Memory Auto-Init
When opening a project that lacks `memory/MEMORY.md`, create one with:
- Project name and brief description
- A pointer to Global Memory (`~/.claude/memory/`)
- Empty sections for Architecture, Conventions, and Key Files

### Domain Knowledge Lifecycle
- New domain insights go into the relevant topic file under `~/.claude/memory/domain/`
- Review and prune stale entries when they conflict with observed project state
- Link from repo MEMORY.md to global topic files when relevant
