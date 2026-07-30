# My Dotfiles

## New machine setup

Recommended order:

1. **Install the 1Password app**, sign in, and enable the SSH agent + CLI
   integration. Everything below depends on it being unlocked (SSH auth,
   secret injection, commit signing).
2. **Install Xcode Command Line Tools**: `xcode-select --install`. Homebrew
   needs this and it's often missing on a fresh Mac.
3. **Clone this repo** (over HTTPS is fine before SSH is set up):
   ```
   git clone https://github.com/vbfischer/dotfiles-v4.git ~/dotfiles-v4
   cd ~/dotfiles-v4
   ```
4. **Run the bootstrap script**:
   ```
   ./install.sh
   ```
   It installs Homebrew (if missing) + everything in `Brewfile` (CLI tools,
   casks, fonts, VS Code extensions, npm globals), installs Claude Code via
   its native installer, stows every package (including `ssh`, so GitHub SSH
   auth works immediately after), and injects Claude Code secrets from
   1Password via `scripts/setup-claude-secrets.zsh`.
5. **Finish the manual steps** not covered by the script:
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
