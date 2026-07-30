# Dotfiles v4

Personal dotfiles for macOS, deployed with GNU Stow (`.stowrc` enables `--dotfiles` mode: `dot-X` files symlink as `.X` in `$HOME`).

## Directory Structure

Each top-level directory is a stowable package:

| Package | Target | Description |
| ------- | ------ | ----------- |
| `btop/` | `~/.config/btop/` | System monitor config |
| `claude/` | `~/.claude/` | Claude Code global config (CLAUDE.md, rules/, commands/, skills/, hooks/, settings.json) — secrets in settings.json are placeholders, run `scripts/setup-claude-secrets.zsh` after stowing |
| `ghostty/` | `~/.config/ghostty/` | Ghostty terminal (primary terminal) |
| `gitconfig/` | `~/.gitconfig` | Git config, aliases, SSH signing via 1Password |
| `herdr/` | `~/.config/herdr/` | herdr multiplexer config (currently just runtime state/logs — no real config file yet, package is a placeholder) |
| `kitty/` | `~/.config/kitty/` | Kitty terminal config + themes |
| `lazygit/` | `~/.config/lazygit/` | Lazygit TUI config |
| `navi/` | `~/.config/navi/` | Navi cheatsheet tool + custom git worktree cheats |
| `nvim/` | `~/.config/nvim/` | Primary Neovim config (LazyVim distro + custom plugins) |
| `nvim-new/` | `~/.config/nvim-new/` | Experimental Neovim rebuild (access via `nnvim`) |
| `scripts/` | — | Utility scripts (1Password secrets injection) |
| `sesh/` | `~/.config/sesh/` | Tmux session manager |
| `ssh/` | `~/.ssh/` | SSH config: 1Password `IdentityAgent` + `github-personal`/`github.com` host aliases for split personal/work GitHub auth. Trimmed of machine-specific `Include` lines (colima, CodeSandbox) |
| `thefuck/` | `~/.config/thefuck/` | Command correction tool |
| `tmux/` | `~/.config/tmux/` | Tmux config (prefix: `C-a`, TPM plugins) |
| `tmuxp/` | `~/.config/tmuxp/` | Tmux session layouts |
| `treekanga/` | `~/.config/treekanga/` | Git worktree manager (aliased as `wt`) |
| `warp/` | `~/.warp/` | Warp terminal themes (uses `dot-warp/` not `dot-config/`) |
| `zshrc/` | `~/.zshrc` | Zsh config (Zinit + Powerlevel10k) |

## Key Commands

- Deploy: `stow <package>`
- Remove: `stow -D <package>`
- Verify symlinks: `ls -la ~/.<config-file>`

## New Machine Setup

Run `./install.sh` — it installs Homebrew + everything in `Brewfile` (CLI tools, casks, VS Code extensions, npm globals), stows every package, and injects Claude Code secrets via `scripts/setup-claude-secrets.zsh` (requires 1Password CLI signed in).

Manual steps not covered by the script:
- Sign into the 1Password app/CLI (SSH keys are 1Password-agent-backed, not stored on disk — nothing to copy)
- `gh auth login`
- tmux plugins: open tmux, `prefix + I` (TPM)
- Neovim plugin sync happens automatically on first launch (lazy.nvim)

## Conventions

### Theme: Catppuccin Frappe everywhere

Ghostty, Neovim, and tmux all use Catppuccin Frappe. Nord and Dark-Purple are secondary alternatives in Kitty/Warp.

### Font: JetBrainsMono Nerd Font (size 16)

### Worktree-centric workflow

This is a core workflow pattern. Treekanga (`wt`), custom git aliases (`wt-setup`, `wt-menu`, `wt-status`, `wt-prune`), navi cheats, zsh functions (`git-worktree-add`, `setup_claude_config`), and sesh sessions all revolve around git worktrees. Repos live in `~/code/` using bare repo + worktree layout.

### Tmux + Neovim navigation

`C-h/j/k/l` moves seamlessly across tmux panes and nvim splits via `nvim-tmux-navigation`.

### 1Password integration

- SSH commit signing via `op-ssh-sign`
- Shell plugin integration (`~/.config/op/plugins.sh`)
- `op read` in setup scripts for secrets injection

### Secrets management

- `~/.zshrc.local` for shell secrets (not committed)
- `op read` for project env files (1Password vaults)

## Shell (zshrc)

- **Framework:** Zinit (zdharma-continuum)
- **Prompt:** Powerlevel10k (instant prompt)
- **Plugins:** zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions, fzf-tab
- **OMZ snippets:** git, jsontools, gitignore
- **Key tools:** fzf, zoxide (overrides `cd`), eza (overrides `ls`), thefuck, volta (Node), pnpm, sdkman (JVM)
- **Notable aliases:** `cbr` (fzf branch checkout), `nnvim` (experimental nvim), `wt` (treekanga), `seshl` (gum session picker)

## Neovim (nvim)

- **Base:** LazyVim distro on lazy.nvim (stable)
- **Colorscheme:** catppuccin-frappe
- **LazyVim extras:** typescript, python, go, tailwind, json, markdown, toml, harpoon2, aerial, mini-files, mini-surround, mini-move, dap.core, edgy, snacks_explorer, snacks_picker, octo, claudecode
- **Custom plugins:** vim-fugitive, gitsigns (line blame), virt-column (80-char), incline (floating filenames), bufferline (tabs), ufo (folding), zen-mode, twilight, package-info, telescope + live-grep-args, copilot, conform (prettier), nvim-tmux-navigation
- **Custom keymaps:** `jk` = ESC, arrow keys disabled in normal mode, `<leader>gg` = lazygit float
- **Options:** shiftwidth=4, tabstop=4, fold level 99

## Tmux

- **Prefix:** `C-a`
- **Splits:** `|` (horizontal 25%), `-` (vertical 25%)
- **Theme:** catppuccin/tmux (status bar at top, directory + session display)
- **Sesh integration:** `T` opens fzf-tmux session picker
- **History limit:** 1,000,000 lines

## When Modifying Configs

- Test shell changes: `source ~/.zshrc`
- Test Neovim: `nvim` (primary) or `nnvim` (experimental)
- Verify symlinks after stow: `ls -la ~/.<target>`
- The `warp/` package uses `dot-warp/` (not `dot-config/warp/`) because Warp reads from `~/.warp/`
- The `scripts/` directory is not a standard stow package — scripts are referenced by treekanga post-hooks
