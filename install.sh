#!/usr/bin/env zsh
# Bootstrap a new macOS machine from this dotfiles repo.
# Usage: ./install.sh
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Checking for Homebrew"
if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Installing packages from Brewfile"
brew bundle install --file=Brewfile

echo "==> Installing Claude Code (native installer)"
if ! command -v claude >/dev/null 2>&1; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

echo "==> Signing in to 1Password CLI (needed for secret injection below)"
if ! op whoami >/dev/null 2>&1; then
    echo "    Run 'op signin' in another terminal, then re-run this script, or press enter to continue without it."
    read -r
fi

STOW_PACKAGES=(
    btop claude ghostty gitconfig herdr kitty lazygit navi
    nvim nvim-new sesh ssh thefuck tmux tmuxp treekanga warp worktrunk zshrc
)

echo "==> Stowing packages: ${STOW_PACKAGES[*]}"
for pkg in "${STOW_PACKAGES[@]}"; do
    stow -v "$pkg"
done

echo "==> Injecting Claude Code secrets"
if command -v op >/dev/null 2>&1 && op whoami >/dev/null 2>&1; then
    ./scripts/setup-claude-secrets.zsh
else
    echo "    Skipped — sign in to 1Password CLI and run scripts/setup-claude-secrets.zsh manually."
fi

echo "==> Done."
echo "Remaining manual steps:"
echo "  - Sign into the 1Password app/CLI (SSH keys are agent-backed, nothing to copy)"
echo "  - Sign in to GitHub CLI: gh auth login"
echo "  - Open tmux and install plugins: prefix + I (TPM)"
echo "  - Open Neovim and let lazy.nvim sync plugins"
echo "  - Set JetBrainsMono Nerd Font in terminal preferences (Ghostty/Kitty)"
