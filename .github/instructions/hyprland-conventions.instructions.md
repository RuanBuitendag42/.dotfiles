---
description: 'Hyprland DE configuration patterns, syntax rules, and ecosystem conventions for Hyprland 0.53+'
applyTo: 'config/hypr/**, config/waybar/**, config/wofi/**, config/dunst/**, config/swaylock/**'
---

# Hyprland DE Conventions

## Hyprland 0.53+ Syntax

Use the modern `windowrule` syntax with `match:` selectors. The old `windowrulev2` keyword is deprecated.

```conf
# CORRECT (0.53+)
windowrule = float, match:class:^(pavucontrol)$
windowrule = size 800 600, match:class:^(pavucontrol)$
windowrule = center, match:title:^(Open File)$

# WRONG (deprecated)
windowrulev2 = float, class:^(pavucontrol)$
```

## Monitor Configuration

```conf
monitor = name, resolution@rate, position, scale
# Example:
monitor = DP-1, 2560x1440@165, 0x0, 1
monitor = , preferred, auto, 1   # fallback for any monitor
```

## Catppuccin Macchiato Colors

Use `rgb(hex-without-hash)` format. Do NOT use `rgba()` unless alpha transparency is specifically needed.

```conf
$mauve    = rgb(c6a0f6)
$pink     = rgb(f5bde6)
$red      = rgb(ed8796)
$green    = rgb(a6da95)
$yellow   = rgb(eed49f)
$blue     = rgb(8aadf4)
$text     = rgb(cad3f5)
$surface0 = rgb(363a4f)
$base     = rgb(24273a)
$mantle   = rgb(1e2030)
$crust    = rgb(181926)

general {
    col.active_border = $mauve $pink 45deg
    col.inactive_border = $surface0
}
```

## Keybinding Conventions

- **SUPER** is the primary mod key
- Use consistent patterns: `SUPER + letter` for common actions, `SUPER + SHIFT + letter` for secondary actions
- Workspace switching: `SUPER + 1-0`
- Move to workspace: `SUPER + SHIFT + 1-0`
- Application launchers: `SUPER + D` (Wofi), `SUPER + Return` (terminal)

## Animations

Use named bezier curves for consistent animation feel:

```conf
bezier = smoothOut, 0.36, 0, 0.66, -0.56
bezier = smoothIn, 0.25, 1, 0.5, 1
bezier = overshot, 0.05, 0.9, 0.1, 1.05

animation = windows, 1, 5, overshot, slide
animation = fade, 1, 5, smoothIn
animation = workspaces, 1, 6, smoothIn, slide
```

## Waybar Patterns

### Config (JSON)
- Modules defined in `modules-left`, `modules-center`, `modules-right`
- Each module has its own config block
- Workspace icons use kanji: 壱 弐 参 肆 伍 陸 漆 捌 玖 拾
- Logo/branding uses samurai kanji: 侍

### Style (CSS)
- Use `@define-color` with Macchiato hex values
- Reference colors as `@colorname` in rules
- Font: `JetBrainsMono Nerd Font`
- Waybar background: `@base` (`#24273a`)
- Active workspace: `@mauve` text on `@surface0` background
- Border accent: `@mauve`

## Wofi Patterns

- Minimal `config` file — keep defaults where possible
- CSS uses Macchiato colors inline
- Background: Base (`#24273a`), text: Text (`#cad3f5`), accent: Mauve (`#c6a0f6`)
- Border radius for rounded look

## Dunst Notification Patterns

Urgency levels map to Macchiato semantic colors:

| Urgency  | Background  | Foreground  | Frame       |
|----------|-------------|-------------|-------------|
| Low      | `#24273a`   | `#cad3f5`   | `#8aadf4`   |
| Normal   | `#24273a`   | `#cad3f5`   | `#c6a0f6`   |
| Critical | `#24273a`   | `#cad3f5`   | `#ed8796`   |

## Related Scripts

These scripts in `scripts/.local/bin/` interact with the Hyprland ecosystem:

| Script | Purpose |
|--------|---------|
| `powermenu.sh` | Wofi-based power menu (lock, logout, suspend, reboot, shutdown) |
| `wallpaper.sh` | Wallpaper rotation with smooth transitions |
| `resolution.sh` | Monitor resolution switching |
| `reload-waybar.sh` | Kill and restart Waybar cleanly |

## Ecosystem Tools

| Tool | Purpose | Status |
|------|---------|--------|
| **pyprland** | Scratchpads, expose, other plugins | Installed |
| **hyprsunset** | Blue-light filter / night-light | Consider installing |
| **hyprdim** | Dim inactive windows | Consider installing |
| **kanshi** | Dynamic multi-monitor profiles | Consider installing |

## After Config Changes

- **Live reload**: `hyprctl reload` applies hyprland.conf changes immediately
- **Waybar**: Kill and restart — `killall waybar && waybar &`
- **Dunst**: `killall dunst && dunst &` or just send a test notification
- **Full redeploy**: `make install-configs` to re-stow everything, then reload
