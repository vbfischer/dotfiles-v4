# Warp Terminal Configuration

This directory contains Warp terminal configurations managed with GNU Stow.

## Installation

From your dotfiles directory:

```bash
stow warp
```

This will create symlinks:
- `~/.warp/themes/` → `dotfiles-v4/warp/dot-warp/themes/`

## Themes Included

### Nord.yaml
- **Colors**: Nord color palette matching Kitty configuration
- **Background**: `#2E3440` (dark blue-gray)
- **Foreground**: `#D8DEE9` (light gray)
- **Accent**: `#81A1C1` (blue)

### Dark-Purple.yaml
- **Colors**: Custom dark purple theme
- **Background**: `#1f1626` (dark purple)
- **Foreground**: `#d9faff` (light cyan)
- **Accent**: `#dd00ff` (bright magenta)

## Usage

1. Install with `stow warp`
2. Open Warp Settings (Cmd + ,)
3. Go to Appearance → Theme
4. Select "Nord" or "Dark-Purple" from the theme list
5. For fonts, set:
   - **Font Family**: `JetBrainsMono Nerd Font Mono`
   - **Font Size**: `16`

## Adding New Themes

Add new `.yaml` theme files to `dot-warp/themes/` directory.
They will automatically appear in Warp's theme selector after restart.

## Theme Format

```yaml
name: "Theme Name"
author: "Author Name"
details: "Theme description"
accent: "#hex_color"
background: "#hex_color"
foreground: "#hex_color"
terminal_colors:
  normal:
    black: "#hex_color"
    red: "#hex_color"
    # ... etc
  bright:
    black: "#hex_color"
    red: "#hex_color"
    # ... etc
```