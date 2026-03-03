---
description: 'Audit all configuration files for Catppuccin Macchiato consistency and report violations'
agent: 'theme-enforcer'
---

# Theme Audit

Perform a full Catppuccin Macchiato theme audit across all configuration files in this repository.

## Audit Scope

Scan every config file in `config/` for:

1. **Color hex values** — Extract all hex color codes and compare against the Macchiato palette
2. **Wrong Catppuccin variant** — Look for Mocha (#1e1e2e base), Latte (#eff1f5 base), or Frappé (#303446 base) colors
3. **Non-palette colors** — Any hardcoded hex color that isn't in the Macchiato palette (note: transparent, inherit, and ANSI mappings are acceptable)
4. **Missing theme setup** — Apps without proper Catppuccin include/plugin configuration

## Per-Application Checks

| App | Check For |
|-----|-----------|
| Kitty | `include themes/catppuccin-macchiato.conf` present |
| Neovim | `flavour = "macchiato"` in colorscheme.lua |
| Tmux | `@catppuccin_flavour 'macchiato'` in tmux.conf |
| btop | `catppuccin_macchiato.theme` exists in themes/ |
| Hyprland | Macchiato `rgb()` variables defined |
| Waybar | `@define-color` with Macchiato hex values in style.css |
| Wofi | Macchiato colors in style.css |
| Dunst | Macchiato colors in dunstrc |
| Swaylock | Macchiato colors in config |
| Hyprlock | Macchiato colors in hyprlock.conf |
| Starship | Macchiato palette colors in starship.toml |

## Report Format

Present all findings as a table:

| File | Line | Issue | Suggested Fix |
|------|------|-------|---------------|
| path/to/file | N | Description of violation | How to fix it |

## Summary

After the table, provide:
- Total files scanned
- Total violations found
- Severity breakdown (critical / warning / info)
- Overall compliance percentage
