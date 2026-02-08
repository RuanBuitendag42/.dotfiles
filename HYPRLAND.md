# Hyprland Configuration

Complete Hyprland setup with **Catppuccin Macchiato** theme throughout.

## 🎨 Components

All configured with Catppuccin Macchiato colors:

- **Hyprland** - Main compositor configuration
- **Waybar** - Status bar with custom Macchiato theme
- **Wofi** - Application launcher
- **Dunst** - Notification daemon
- **Swaylock** - Lock screen with blur effects
- **Scripts** - Wallpaper manager and utilities

## 📁 Structure

```
config/
├── hypr/           → ~/.config/hypr/
│   ├── hyprland.conf
│   ├── hypridle.conf
│   └── hyprlock.conf
├── waybar/         → ~/.config/waybar/
│   ├── config
│   └── style.css
├── wofi/           → ~/.config/wofi/
│   ├── config
│   └── style.css
├── dunst/          → ~/.config/dunst/
│   └── dunstrc
└── swaylock/       → ~/.config/swaylock/
    └── config

scripts/.local/bin/
├── powermenu.sh    # Wofi-based power menu
├── wallpaper.sh    # Wallpaper manager (swww)
└── resolution.sh   # Resolution switcher
```

## 🚀 Installation

### Automated (Recommended)

```bash
./setup.sh
```

When prompted, choose to install Hyprland.

### Manual Deployment

```bash
# 1. Install dependencies (if not already installed)
sudo pacman -S hyprland hypridle hyprlock waybar wofi dunst swww grim slurp satty \
    wl-clipboard cliphist xdg-desktop-portal-hyprland \
    polkit-gnome nemo network-manager-applet blueman \
    pavucontrol qt5ct qt6ct kvantum papirus-icon-theme \
    brightnessctl playerctl nwg-look

yay -S swaylock-effects pyprland

# 2. Deploy configs with stow
cd ~/.dotfiles/config
stow -v -t ~/.config .

# 3. Deploy scripts
cd ~/.dotfiles/scripts
stow -v -t ~ .

# 4. Create required directories
mkdir -p ~/pictures/wallpapers ~/pictures/screenshots
```

## ⌨️ Key Bindings

### Core

| Key | Action |
|-----|--------|
| `SUPER + Q` | Kill active window |
| `SUPER + V` | Toggle floating |
| `SUPER + F` | Fullscreen |
| `SUPER + SHIFT + F` | Maximize (keep bar) |
| `SUPER + P` | Pseudo-tiling |
| `SUPER + T` | Toggle split direction |
| `SUPER + G` | Toggle group |
| `ALT + TAB` | Focus last window |

### Applications

| Key | Action |
|-----|--------|
| `SUPER + RETURN` | Kitty terminal |
| `SUPER + E` | Nemo file manager |
| `SUPER + D` | Wofi launcher |
| `SUPER + B` | Zen Browser |
| `SUPER + C` | VS Code |
| `SUPER + Y` | Clipboard history (cliphist) |
| `SUPER + ESCAPE` | Lock screen (hyprlock) |
| `SUPER + M` | Power menu |
| `SUPER + CTRL + M` | Exit Hyprland (emergency) |
| `SUPER + SHIFT + R` | Reload Hyprland |

### Window Navigation (Vim-style)

| Key | Action |
|-----|--------|
| `SUPER + H/J/K/L` | Move focus |
| `SUPER + SHIFT + H/J/K/L` | Move window |
| `SUPER + R` | Enter resize mode (HJKL/arrows, ESC to exit) |

### Window Navigation (Arrows)

| Key | Action |
|-----|--------|
| `SUPER + Arrow Keys` | Move focus |
| `SUPER + SHIFT + Arrow Keys` | Move window |
| `SUPER + CTRL + Arrow Keys` | Resize window |

### Workspaces

| Key | Action |
|-----|--------|
| `SUPER + 1-9` | Switch to workspace |
| `SUPER + SHIFT + 1-9` | Move window to workspace |
| `SUPER + Mouse Wheel` | Cycle workspaces |
| `SUPER + Left Mouse` | Move window |
| `SUPER + Right Mouse` | Resize window |

### Screenshots

| Key | Action |
|-----|--------|
| `PRINT` | Screenshot area (edit in Satty) |
| `SHIFT + PRINT` | Screenshot full screen (edit in Satty) |
| `SUPER + PRINT` | Screenshot area to clipboard |
| `SUPER + SHIFT + PRINT` | Screenshot full screen to file |

### Media Controls

| Key | Action |
|-----|--------|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioPlay` | Play/pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |

## 🎨 Theme

All components use **Catppuccin Macchiato** palette:

- **Base**: `#24273a`
- **Mantle**: `#1e2030`
- **Surface0**: `#363a4f`
- **Overlay0**: `#6e738d`
- **Text**: `#cad3f5`
- **Mauve**: `#c6a0f6`
- **Pink**: `#f5bde6`
- **Blue**: `#8aadf4`
- **Sky**: `#91d7e3`
- **Green**: `#a6da95`
- **Red**: `#ed8796`

See [THEMES.md](THEMES.md) for complete color reference.

## 🖼️ Wallpapers

Place wallpapers in `~/pictures/wallpapers/`:

```bash
# Set random wallpaper
wallpaper.sh

# Add to startup in hyprland.conf:
exec-once = wallpaper.sh
```

## 🔧 Customization

### Animations

Edit `~/.config/hypr/hyprland.conf`:

```conf
animation = windows, 1, 7, myBezier
animation = windowsOut, 1, 7, default, popin 80%
animation = border, 1, 10, default
animation = fade, 1, 7, default
animation = workspaces, 1, 6, default
```

### Window Rules

Hyprland 0.53+ uses the new `windowrule` syntax with `match:` specifiers:

```conf
windowrule = float on, match:class pavucontrol
windowrule = float on, match:class nm-connection-editor
windowrule = opacity 0.92 0.88, match:class kitty
```

### Startup Applications

```conf
exec-once = waybar
exec-once = dunst
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = nm-applet
exec-once = blueman-applet
exec-once = hypridle
```

## 🐛 Troubleshooting

### Waybar not showing

```bash
# Check if running
pgrep waybar

# Restart
pkill waybar && waybar &
```

### Screen sharing not working

```bash
# Ensure portal is running
systemctl --user restart xdg-desktop-portal-hyprland
```

### Kitty not launching

```bash
# Check if installed
which kitty

# Test manually
kitty
```

## 📚 Resources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Catppuccin Palette](https://catppuccin.com/palette)
- [Waybar Documentation](https://github.com/Alexays/Waybar/wiki)
- [Wofi Documentation](https://hg.sr.ht/~scoopta/wofi)
