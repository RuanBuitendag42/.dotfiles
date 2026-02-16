#
---
description: 'Catppuccin Macchiato color reference and theming for .dotfiles'
applyTo: '**'
---
# 🎨 Catppuccin Macchiato Theme

> **IMPORTANT**: This is THE theme for this entire setup. Catppuccin Macchiato EVERYWHERE!

Catppuccin Macchiato is a warm, soothing pastel theme that provides excellent contrast while being easy on the eyes. It's the perfect balance between aesthetics and functionality.

---

## 🌈 Color Palette

Catppuccin Macchiato uses these base colors:

```
Base Colors:
- Rosewater: #f4dbd6
- Flamingo:  #f0c6c6
- Pink:      #f5bde6
- Mauve:     #c6a0f6
- Red:       #ed8796
- Maroon:    #ee99a0
- Peach:     #f5a97f
- Yellow:    #eed49f
- Green:     #a6da95
- Teal:      #8bd5ca
- Sky:       #91d7e3
- Sapphire:  #7dc4e4
- Blue:      #8aadf4
- Lavender:  #b7bdf8

Background Shades:
- Base:      #24273a
- Mantle:    #1e2030
- Crust:     #181926

Text Colors:
- Text:      #cad3f5
- Subtext1:  #b8c0e0
- Subtext0:  #a5adcb
- Overlay2:  #939ab7
- Overlay1:  #8087a2
- Overlay0:  #6e738d
- Surface2:  #5b6078
- Surface1:  #494d64
- Surface0:  #363a4f
```

---

## 🎯 Theme Application Status

### ✅ Configured

- **Kitty** - Full Macchiato theme applied
- **Neovim** - LazyVim with Catppuccin Macchiato
- **Tmux** - Catppuccin Macchiato statusline
- **btop** - Macchiato theme available
- **Hyprland** - Full Macchiato colors (borders, shadows)
- **Waybar** - Macchiato status bar with styled modules
- **Wofi** - Macchiato application launcher
- **Dunst** - Macchiato notification styling
- **Swaylock** - Macchiato lock screen
- **Hyprlock** - Macchiato lock screen (alternative)
- **GTK Theme** - Catppuccin Macchiato GTK + cursors (AUR)

---

## 📦 Application-Specific Configurations

### Kitty Terminal

**Config**: `config/kitty/kitty.conf`

```bash
# Catppuccin Macchiato theme
include themes/catppuccin-macchiato.conf
```

**Colors**:
```conf
# Background colors
background #24273a
foreground #cad3f5

# Cursor colors
cursor #f4dbd6
cursor_text_color #24273a

# Selection colors
selection_background #5b6078
selection_foreground #cad3f5

# Normal colors
color0 #494d64
color1 #ed8796
color2 #a6da95
color3 #eed49f
color4 #8aadf4
color5 #f5bde6
color6 #8bd5ca
color7 #b8c0e0

# Bright colors
color8  #5b6078
color9  #ed8796
color10 #a6da95
color11 #eed49f
color12 #8aadf4
color13 #f5bde6
color14 #8bd5ca
color15 #a5adcb
```

### Neovim

**Config**: `config/nvim/lua/plugins/colorscheme.lua`

```lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato", -- IMPORTANT: Always Macchiato!
      transparent_background = false,
      term_colors = true,
      integrations = {
        cmp = true,
        dashboard = true,
        flash = true,
        gitsigns = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = true,
        native_lsp = { enabled = true },
        navic = { enabled = true, custom_bg = "lualine" },
        noice = true,
        notify = true,
        nvimtree = true,
        semantic_tokens = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
```

### Tmux

**Config**: `config/tmux/tmux.conf`

```bash
# Catppuccin Macchiato theme
set -g @plugin 'catppuccin/tmux'
set -g @catppuccin_flavour 'macchiato'

# Theme customization
set -g @catppuccin_window_left_separator ""
set -g @catppuccin_window_right_separator " "
set -g @catppuccin_window_middle_separator " █"
set -g @catppuccin_window_number_position "right"

set -g @catppuccin_window_default_fill "number"
set -g @catppuccin_window_default_text "#W"

set -g @catppuccin_window_current_fill "number"
set -g @catppuccin_window_current_text "#W"

set -g @catppuccin_status_modules_right "directory user host session"
set -g @catppuccin_status_left_separator  " "
set -g @catppuccin_status_right_separator ""
set -g @catppuccin_status_fill "icon"
set -g @catppuccin_status_connect_separator "no"

set -g @catppuccin_directory_text "#{pane_current_path}"
```

### btop

**Location**: `config/btop/themes/`

Catppuccin Macchiato theme included! Select it in btop settings:
1. Press `ESC` or `M` for menu
2. Select `Options`
3. Choose `Color theme`
4. Select `catppuccin_macchiato`

### Hyprland

**Config**: `hyprland/hyprland.conf` (to be created)

```conf
# Catppuccin Macchiato colors
$rosewater = rgb(f4dbd6)
$flamingo = rgb(f0c6c6)
$pink = rgb(f5bde6)
$mauve = rgb(c6a0f6)
$red = rgb(ed8796)
$maroon = rgb(ee99a0)
$peach = rgb(f5a97f)
$yellow = rgb(eed49f)
$green = rgb(a6da95)
$teal = rgb(8bd5ca)
$sky = rgb(91d7e3)
$sapphire = rgb(7dc4e4)
$blue = rgb(8aadf4)
$lavender = rgb(b7bdf8)

$text = rgb(cad3f5)
$subtext1 = rgb(b8c0e0)
$subtext0 = rgb(a5adcb)

$overlay2 = rgb(939ab7)
$overlay1 = rgb(8087a2)
$overlay0 = rgb(6e738d)

$surface2 = rgb(5b6078)
$surface1 = rgb(494d64)
$surface0 = rgb(363a4f)

$base = rgb(24273a)
$mantle = rgb(1e2030)
$crust = rgb(181926)

# Apply to borders and UI
general {
    col.active_border = $mauve $pink 45deg
    col.inactive_border = $surface0
}

decoration {
    col.shadow = $crust
}
```

### Waybar

**Config**: `hyprland/waybar/style.css`

```css
/* Catppuccin Macchiato for Waybar */
@define-color base   #24273a;
@define-color mantle #1e2030;
@define-color crust  #181926;

@define-color text     #cad3f5;
@define-color subtext0 #a5adcb;
@define-color subtext1 #b8c0e0;

@define-color surface0 #363a4f;
@define-color surface1 #494d64;
@define-color surface2 #5b6078;

@define-color overlay0 #6e738d;
@define-color overlay1 #8087a2;
@define-color overlay2 #939ab7;

@define-color blue      #8aadf4;
@define-color lavender  #b7bdf8;
@define-color sapphire  #7dc4e4;
@define-color sky       #91d7e3;
@define-color teal      #8bd5ca;
@define-color green     #a6da95;
@define-color yellow    #eed49f;
@define-color peach     #f5a97f;
@define-color maroon    #ee99a0;
@define-color red       #ed8796;
@define-color mauve     #c6a0f6;
@define-color pink      #f5bde6;
@define-color flamingo  #f0c6c6;
@define-color rosewater #f4dbd6;

* {
    font-family: "JetBrainsMono Nerd Font";
    font-size: 14px;
}

window#waybar {
    background-color: @base;
    color: @text;
    border-bottom: 2px solid @mauve;
}

#workspaces button {
    padding: 0 10px;
    color: @text;
    background-color: transparent;
}

#workspaces button.active {
    background-color: @surface0;
    color: @mauve;
}

#workspaces button:hover {
    background-color: @surface1;
}

#clock,
#battery,
#network,
#pulseaudio,
#custom-power {
    padding: 0 10px;
    color: @text;
}

#battery.charging {
    color: @green;
}

#battery.warning:not(.charging) {
    color: @yellow;
}

#battery.critical:not(.charging) {
    color: @red;
}

#network.disconnected {
    color: @red;
}

#pulseaudio.muted {
    color: @overlay0;
}
```

---

## 🔧 Installation Steps

### 1. Kitty Theme

```bash
# Kitty already configured with themes
# Update kitty.conf to use Catppuccin Macchiato
vim ~/.config/kitty/kitty.conf
# Look for theme include line
```

### 2. Neovim Theme

```bash
# Already configured in LazyVim
# Ensure colorscheme.lua sets flavour = "macchiato"
nvim ~/.config/nvim/lua/plugins/colorscheme.lua
```

### 3. Tmux Theme

```bash
# Install TPM (Tmux Plugin Manager) if not installed
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Update tmux.conf with Catppuccin settings (already done)
# Reload tmux
tmux source-file ~/.config/tmux/tmux.conf

# Install plugins: Ctrl+B then I (capital i)
```

### 4. btop Theme

```bash
# Theme already included in config/btop/themes/
# Select it in btop: ESC > Options > Color theme > catppuccin_macchiato
```

### 5. GTK Theme (Optional)

```bash
# Install Catppuccin GTK theme
yay -S catppuccin-gtk-theme-macchiato

# Apply with your GTK theme manager
```

---

## 📚 Resources

- **Official Catppuccin**: https://github.com/catppuccin/catppuccin
- **Catppuccin Ports**: https://github.com/catppuccin
- **Kitty Theme**: https://github.com/catppuccin/kitty
- **Neovim Plugin**: https://github.com/catppuccin/nvim
- **Tmux Theme**: https://github.com/catppuccin/tmux
- **Hyprland Theme**: https://github.com/catppuccin/hyprland

---

## 💡 Why Macchiato?

**Macchiato** is the perfect middle ground in the Catppuccin family:

- **Latte**: Too bright for long sessions
- **Frappé**: Good, but not warm enough
- **Macchiato**: ✅ **Perfect balance** - warm, cozy, professional
- **Mocha**: Too dark, can be straining

Macchiato provides:
- Excellent contrast for readability
- Warm colors that reduce eye strain
- Professional appearance
- Consistent across all applications
- Beautiful syntax highlighting

---

## 🎨 Theme Consistency Checklist

When configuring new applications, always ensure:

- [ ] Background uses `#24273a` (base)
- [ ] Foreground uses `#cad3f5` (text)
- [ ] Accents use Mauve `#c6a0f6` or Pink `#f5bde6`
- [ ] Syntax highlighting follows Catppuccin guidelines
- [ ] No other color schemes mixed in

---

**Remember: Catppuccin Macchiato EVERYWHERE! 🎨✨**
