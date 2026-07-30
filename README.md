# My Dotfiles

## New machine setup

Run the bootstrap script — it installs Homebrew + everything in `Brewfile`
(CLI tools, casks, VS Code extensions, npm globals), installs Claude Code via
its native installer, stows every package below, and injects Claude Code
secrets from 1Password:

```
git clone git@github-personal:vbfischer/dotfiles-v4.git ~/dotfiles-v4
cd ~/dotfiles-v4
./install.sh
```

Requires the 1Password app/CLI to be signed in first (`op signin`) — SSH keys
are 1Password-agent-backed, so there are no key files to copy over manually.

Manual steps not covered by the script:
- `gh auth login`
- tmux plugins: open tmux, `prefix + I` (TPM)
- Neovim plugin sync happens automatically on first launch (lazy.nvim)
- Set JetBrainsMono Nerd Font in terminal preferences (Ghostty/Kitty)

## Install a single package

Directory structure is such that it allows easy deploy using [GNU Stow](https://www.gnu.org/software/stow/)

```
stow zshrc
stow kitty
stow tmux
stow nvim
```

## nvim-new

This is an experimental rebuild of my `nvim` configuration.
Currently, if added via `stow nvim-new` then can be run by
calling `nnvim`
