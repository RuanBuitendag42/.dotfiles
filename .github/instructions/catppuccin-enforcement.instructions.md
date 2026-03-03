---
description: 'Catppuccin Macchiato color palette reference and enforcement rules for all configuration files'
applyTo: 'config/**'
---

# Catppuccin Macchiato — Enforcement Rules

**Macchiato is the ONLY approved flavor.** Every application config in this repo MUST use Catppuccin Macchiato colors exclusively.

## Complete Hex Palette (26 Colors)

### Accent Colors

| Name       | Hex       | RGB                  |
|------------|-----------|----------------------|
| Rosewater  | `#f4dbd6` | `rgb(244, 219, 214)` |
| Flamingo   | `#f0c6c6` | `rgb(240, 198, 198)` |
| Pink       | `#f5bde6` | `rgb(245, 189, 230)` |
| Mauve      | `#c6a0f6` | `rgb(198, 160, 246)` |
| Red        | `#ed8796` | `rgb(237, 135, 150)` |
| Maroon     | `#ee99a0` | `rgb(238, 153, 160)` |
| Peach      | `#f5a97f` | `rgb(245, 169, 127)` |
| Yellow     | `#eed49f` | `rgb(238, 212, 159)` |
| Green      | `#a6da95` | `rgb(166, 218, 149)` |
| Teal       | `#8bd5ca` | `rgb(139, 213, 202)` |
| Sky        | `#91d7e3` | `rgb(145, 215, 227)` |
| Sapphire   | `#7dc4e4` | `rgb(125, 196, 228)` |
| Blue       | `#8aadf4` | `rgb(138, 173, 244)` |
| Lavender   | `#b7bdf8` | `rgb(183, 189, 248)` |

### Text & Overlay Colors

| Name     | Hex       | RGB                  |
|----------|-----------|----------------------|
| Text     | `#cad3f5` | `rgb(202, 211, 245)` |
| Subtext1 | `#b8c0e0` | `rgb(184, 192, 224)` |
| Subtext0 | `#a5adcb` | `rgb(165, 173, 203)` |
| Overlay2 | `#939ab7` | `rgb(147, 154, 183)` |
| Overlay1 | `#8087a2` | `rgb(128, 135, 162)` |
| Overlay0 | `#6e738d` | `rgb(110, 115, 141)` |

### Surface & Background Colors

| Name     | Hex       | RGB                  |
|----------|-----------|----------------------|
| Surface2 | `#5b6078` | `rgb(91, 96, 120)`  |
| Surface1 | `#494d64` | `rgb(73, 77, 100)`  |
| Surface0 | `#363a4f` | `rgb(54, 58, 79)`   |
| Base     | `#24273a` | `rgb(36, 39, 58)`   |
| Mantle   | `#1e2030` | `rgb(30, 32, 48)`   |
| Crust    | `#181926` | `rgb(24, 25, 38)`   |

## Hyprland RGB Format

Hyprland uses `rgb(hex-without-hash)` — no `#`, no `rgba()` unless alpha is specifically needed:

```
$mauve = rgb(c6a0f6)
$base  = rgb(24273a)
$text  = rgb(cad3f5)
```

## Default Accent Color

**Mauve (`#c6a0f6`)** is the default accent color for all applications. Use it for:
- Active borders, highlights, selections
- Primary UI accents, focus indicators
- Status bar highlights, active workspace indicators

## Per-Application Theme Settings

| Application | How to Apply Macchiato |
|-------------|----------------------|
| **Kitty** | `include themes/catppuccin-macchiato.conf` in kitty.conf |
| **Neovim** | `flavour = "macchiato"` in `lua/plugins/colorscheme.lua` via catppuccin/nvim |
| **Tmux** | `set -g @catppuccin_flavour 'macchiato'` via TPM catppuccin plugin |
| **btop** | `catppuccin_macchiato.theme` in `config/btop/themes/` |
| **Waybar** | `@define-color` CSS variables with Macchiato hex values |
| **Wofi** | Inline Macchiato hex colors in `style.css` |
| **Dunst** | Macchiato hex colors for urgency levels in `dunstrc` |
| **Swaylock** | Macchiato hex colors (without `#`) in `config` |
| **Hyprland** | `rgb()` format variables (e.g., `rgb(c6a0f6)`) in `hyprland.conf` |
| **SDDM** | `catppuccin-macchiato-mauve` theme from AUR |
| **Starship** | Inline Macchiato palette hex colors in `starship.toml` |
| **Git delta** | Catppuccin Macchiato syntax theme |

## FORBIDDEN

- **Mocha** — too dark, not approved
- **Latte** — light theme, absolutely not
- **Frappé** — close but not warm enough
- Any non-Catppuccin color scheme
- Mixing colors from different Catppuccin flavors
- Hardcoded colors that don't match the Macchiato palette

## Aesthetic Mandate

**未来侍 (Futuristic Samurai)** — Japanese ukiyo-e meets futuristic warrior.

- This is NOT cyberpunk. No neon, no gritty urban.
- Think: elegant samurai blades, sakura blossoms, torii gates, traditional ink art — given a modern, refined edge.
- Wallpapers must use the Catppuccin Macchiato palette with Japanese samurai / sakura / torii / ukiyo-e motifs.

## Color Audit Checklist

When reviewing or adding any config file, verify:

- [ ] Background color is Base (`#24273a`), Mantle (`#1e2030`), or Crust (`#181926`)
- [ ] Primary text color is Text (`#cad3f5`)
- [ ] Accent/highlight color is Mauve (`#c6a0f6`) unless semantically another color (e.g., Red for errors)
- [ ] No hardcoded colors outside the 26-color Macchiato palette
- [ ] No other Catppuccin flavor referenced (Mocha, Latte, Frappé)
- [ ] RGB format matches the app's requirements (hex, rgb(), or `rgb(hex-no-hash)`)
- [ ] Semantic colors are correct: Green for success, Yellow for warning, Red for error
- [ ] Inactive/dimmed elements use Surface or Overlay colors, not Subtext
