---
name: catppuccin-theming
description: "Catppuccin Macchiato color palette reference and per-application theming guide"
---

# Catppuccin Macchiato Theming Reference

Complete color palette and per-application theming guide for maintaining a consistent Catppuccin Macchiato aesthetic across the entire system.

---

## Official Macchiato Palette

| Color     | Hex       | RGB              | HSL              | Usage |
|-----------|-----------|------------------|------------------|-------|
| Rosewater | `#f4dbd6` | `rgb(244,219,214)` | `10, 58%, 90%` | Links, special accents |
| Flamingo  | `#f0c6c6` | `rgb(240,198,198)` | `0, 58%, 86%` | Secondary accents |
| Pink      | `#f5bde6` | `rgb(245,189,230)` | `316, 74%, 85%` | Feminine accents |
| Mauve     | `#c6a0f6` | `rgb(198,160,246)` | `267, 83%, 80%` | **Primary accent** |
| Red       | `#ed8796` | `rgb(237,135,150)` | `351, 74%, 73%` | Errors, destructive |
| Maroon    | `#ee99a0` | `rgb(238,153,160)` | `355, 71%, 77%` | Soft errors |
| Peach     | `#f5a97f` | `rgb(245,169,127)` | `21, 86%, 73%` | Warnings |
| Yellow    | `#eed49f` | `rgb(238,212,159)` | `40, 70%, 78%` | Caution, highlights |
| Green     | `#a6da95` | `rgb(166,218,149)` | `105, 48%, 72%` | Success, additions |
| Teal      | `#8bd5ca` | `rgb(139,213,202)` | `171, 47%, 69%` | Tertiary accent |
| Sky       | `#91d7e3` | `rgb(145,215,227)` | `189, 59%, 73%` | Info, links |
| Sapphire  | `#7dc4e4` | `rgb(125,196,228)` | `199, 66%, 69%` | Secondary info |
| Blue      | `#8aadf4` | `rgb(138,173,244)` | `220, 83%, 75%` | Info, primary links |
| Lavender  | `#b7bdf8` | `rgb(183,189,248)` | `234, 82%, 85%` | Cursor, highlights |
| Text      | `#cad3f5` | `rgb(202,211,245)` | `227, 68%, 88%` | **Primary text** |
| Subtext1  | `#b8c0e0` | `rgb(184,192,224)` | `228, 39%, 80%` | Secondary text |
| Subtext0  | `#a5adcb` | `rgb(165,173,203)` | `227, 27%, 72%` | Tertiary text |
| Overlay2  | `#939ab7` | `rgb(147,154,183)` | `228, 20%, 65%` | Muted elements |
| Overlay1  | `#8087a2` | `rgb(128,135,162)` | `228, 15%, 57%` | Subtle borders |
| Overlay0  | `#6e738d` | `rgb(110,115,141)` | `230, 12%, 49%` | **Comments** |
| Surface2  | `#5b6078` | `rgb(91,96,120)` | `230, 14%, 41%` | Active surfaces |
| Surface1  | `#494d64` | `rgb(73,77,100)` | `231, 16%, 34%` | **Borders** |
| Surface0  | `#363a4f` | `rgb(54,58,79)` | `230, 19%, 26%` | Subtle surfaces |
| Base      | `#24273a` | `rgb(36,39,58)` | `232, 23%, 18%` | **Background** |
| Mantle    | `#1e2030` | `rgb(30,32,48)` | `233, 23%, 15%` | **Darker background** |
| Crust     | `#181926` | `rgb(24,25,38)` | `234, 23%, 12%` | **Darkest background** |

---

## Per-Application Theming Guide

### Hyprland

Use `$colorname` variables with `rgb()` notation (no `#` prefix):
```
$mauve = rgb(c6a0f6)
$base = rgb(24273a)
$surface0 = rgb(363a4f)
$text = rgb(cad3f5)
$red = rgb(ed8796)

general {
    col.active_border = $mauve
    col.inactive_border = $surface0
}

group {
    col.border_active = $mauve
    col.border_inactive = $surface0
}
```

### Kitty

Include the catppuccin theme file and set border colors:
```conf
# In kitty.conf
include themes/catppuccin-macchiato.conf

active_border_color   #c6a0f6
inactive_border_color #494d64
bell_border_color     #ed8796
```

The theme file sets all foreground, background, cursor, selection, and ANSI colors.

### Waybar CSS

Apply to class and ID selectors:
```css
@define-color base #24273a;
@define-color mantle #1e2030;
@define-color crust #181926;
@define-color text #cad3f5;
@define-color subtext0 #a5adcb;
@define-color surface0 #363a4f;
@define-color surface1 #494d64;
@define-color mauve #c6a0f6;
@define-color red #ed8796;
@define-color green #a6da95;
@define-color peach #f5a97f;
@define-color blue #8aadf4;

* {
    font-family: "Maple Mono NF", sans-serif;
    color: @text;
}

window#waybar {
    background: alpha(@base, 0.85);
}

#workspaces button {
    color: @subtext0;
    background: transparent;
}

#workspaces button.active {
    color: @mauve;
    border-bottom: 2px solid @mauve;
}

#clock { color: @blue; }
#cpu { color: @green; }
#memory { color: @peach; }
#temperature { color: @red; }
```

### Dunst

```ini
[global]
frame_color = "#c6a0f6"

[urgency_low]
background = "#24273a"
foreground = "#cad3f5"
frame_color = "#8aadf4"

[urgency_normal]
background = "#24273a"
foreground = "#cad3f5"
frame_color = "#c6a0f6"

[urgency_critical]
background = "#24273a"
foreground = "#cad3f5"
frame_color = "#ed8796"
```

### Wofi

```css
window {
    background-color: #24273a;
    border: 2px solid #c6a0f6;
    border-radius: 8px;
}

#input {
    background-color: #363a4f;
    color: #cad3f5;
    border: 1px solid #494d64;
}

#entry:selected {
    background-color: #363a4f;
    color: #c6a0f6;
}

#entry {
    color: #cad3f5;
}
```

### Tmux (catppuccin/tmux Plugin)

```tmux
set -g @catppuccin_flavor 'macchiato'
set -g @catppuccin_window_status_style 'rounded'

# Window styling
set -g @catppuccin_window_default_fill "number"
set -g @catppuccin_window_current_fill "number"
set -g @catppuccin_window_current_color "#{@thm_mauve}"

# Pane borders
set -g @catppuccin_pane_border_style "fg=#{@thm_surface1}"
set -g @catppuccin_pane_active_border_style "fg=#{@thm_mauve}"
```

### Neovim (catppuccin/nvim Plugin)

```lua
-- In lua/plugins/colorscheme.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato",
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        telescope = { enabled = true },
        which_key = true,
        indent_blankline = { enabled = true },
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-macchiato" },
  },
}
```

### SDDM

Install: `yay -S catppuccin-sddm-theme-macchiato`

```conf
# /etc/sddm.conf.d/theme.conf
[Theme]
Current=catppuccin-macchiato
```

### GTK

Install: `yay -S catppuccin-gtk-theme-macchiato`

Apply with `nwg-look` (Wayland-compatible alternative to lxappearance).

### Qt / Kvantum

Install: `yay -S kvantum catppuccin-kvantum-theme-macchiato`

Set via Kvantum Manager, then:
```
env = QT_QPA_PLATFORMTHEME,qt5ct
env = QT_STYLE_OVERRIDE,kvantum
```

### Cursors

Install: `yay -S catppuccin-cursors-macchiato`

Set in Hyprland:
```
env = XCURSOR_THEME,catppuccin-macchiato-dark-cursors
env = XCURSOR_SIZE,24
```

### Starship

Use palette colors in prompt segments:
```toml
# In starship.toml
[character]
success_symbol = "[❯](mauve)"
error_symbol = "[❯](red)"

[directory]
style = "bold blue"

[git_branch]
style = "bold mauve"
```

### Btop

Theme file: `~/.config/btop/themes/catppuccin_macchiato.theme`

Set in btop config:
```
color_theme = "catppuccin_macchiato"
```

---

## Consistency Enforcement Rules

1. **Every new application MUST be themed with Catppuccin Macchiato** — no exceptions
2. **Check official ports first:** Browse `github.com/catppuccin/catppuccin` for official application ports before manual theming
3. **Manual theming fallback:** If no official port exists, apply colors from the palette table above
4. **Background hierarchy:** Base → Mantle → Crust (light to dark)
5. **Primary accent:** Mauve (`#c6a0f6`) — used for active borders, selections, focused elements
6. **Text hierarchy:** Text → Subtext1 → Subtext0 → Overlay2 (primary to muted)
7. **Semantic colors:** Red = error, Peach = warning, Green = success, Blue = info
8. **Border color:** Surface1 (`#494d64`) for inactive, Mauve for active
9. **Comment/muted text:** Overlay0 (`#6e738d`)
10. **Always verify contrast:** Text on Base, Subtext on Surface0 — ensure readability
