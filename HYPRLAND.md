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
│   └── hyprland.conf
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

scripts/hyprland/   → ~/.local/bin/
└── wallpaper.sh
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
sudo pacman -S hyprland waybar wofi dunst swww grim slurp \
    wl-clipboard cliphist swayidle xdg-desktop-portal-hyprland \
    polkit-kde-agent thunar network-manager-applet blueman \
    pavucontrol qt5ct qt6ct kvantum papirus-icon-theme \
    brightnessctl playerctl

yay -S swaylock-effects

# 2. Deploy configs with stow
cd ~/.dotfiles/config
stow -v -t ~/.config hypr waybar wofi dunst swaylock

# 3. Install scripts
mkdir -p ~/.local/bin
cp ~/.dotfiles/scripts/hyprland/*.sh ~/.local/bin/
chmod +x ~/.local/bin/*.sh

# 4. Create required directories
mkdir -p ~/Pictures/Wallpapers ~/Pictures/Screenshots
```

## ⌨️ Key Bindings

### Core

| Key | Action |
|-----|--------|
| `SUPER + Q` | Kill active window |
| `SUPER + M` | Exit Hyprland |
| `SUPER + V` | Toggle floating |
| `SUPER + P` | Toggle pseudo-tiling |
| `SUPER + J` | Toggle split direction |
| `SUPER + F` | Toggle fullscreen |

### Applications

| Key | Action |
|-----|--------|
| `SUPER + RETURN` | Launch Kitty terminal |
| `SUPER + E` | Launch Thunar file manager |
| `SUPER + D` | Launch Wofi launcher |
| `SUPER + L` | Lock screen (swaylock) |

### Window Navigation (Vim-style)

| Key | Action |
|-----|--------|
| `SUPER + H/J/K/L` | Move focus |
| `SUPER + SHIFT + H/J/K/L` | Move window |
| `SUPER + CTRL + H/J/K/L` | Resize window |

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
| `SUPER + SHIFT + S` | Screenshot area |
| `PRINT` | Screenshot full screen |

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

Place wallpapers in `~/Pictures/Wallpapers/`:

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

```conf
windowrule = float, ^(pavucontrol)$
windowrule = float, ^(nm-connection-editor)$
windowrulev2 = opacity 0.9, class:^(kitty)$
```

### Startup Applications

```conf
exec-once = waybar
exec-once = dunst
exec-once = /usr/lib/polkit-kde-authentication-agent-1
exec-once = nm-applet
exec-once = blueman-applet
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
