---
name: waybar-widgets
description: "Waybar custom modules, CSS theming, scripts, and alternative widget frameworks"
---

# Waybar Widgets & Customization Reference

Comprehensive guide for Waybar module development, CSS theming with Catppuccin Macchiato, and alternative widget frameworks for Hyprland.

---

## Module Types

### Built-in Modules

| Module | Description |
|--------|-------------|
| `hyprland/workspaces` | Workspace buttons |
| `hyprland/window` | Active window title |
| `hyprland/submap` | Active submap name |
| `hyprland/language` | Keyboard layout |
| `clock` | Date and time |
| `cpu` | CPU usage |
| `memory` | Memory usage |
| `temperature` | Thermal readings |
| `network` | Network status |
| `pulseaudio` | Volume control |
| `wireplumber` | PipeWire volume |
| `tray` | System tray |
| `battery` | Battery status |
| `backlight` | Screen brightness |
| `idle_inhibitor` | Prevent idle |
| `disk` | Disk usage |
| `mpris` | Media player |

### Custom Module Format
```json
"custom/NAME": {
    "exec": "command or script path",
    "exec-if": "condition command",
    "interval": 60,
    "return-type": "json",
    "format": "PREFIX {}",
    "format-alt": "ALTERNATIVE {}",
    "tooltip": true,
    "tooltip-format": "Detailed: {}",
    "on-click": "command",
    "on-click-right": "command",
    "on-scroll-up": "command",
    "on-scroll-down": "command",
    "signal": 8,
    "max-length": 50,
    "min-length": 0
}
```

### JSON Output Format
Scripts with `return-type: "json"` must output:
```json
{"text": "display text", "tooltip": "hover text", "class": "css-class", "percentage": 50}
```

---

## Custom Module Patterns

### Weather (wttr.in)

**Simple:**
```json
"custom/weather": {
    "exec": "curl -s 'wttr.in/?format=%c+%t'",
    "interval": 3600,
    "format": "{}",
    "tooltip": false
}
```

**Rich (using wttrbar from bjesus/wttrbar):**
```json
"custom/weather": {
    "exec": "wttrbar --location 'YourCity' --fahrenheit",
    "return-type": "json",
    "interval": 3600,
    "format": "{}",
    "tooltip": true
}
```
Install: `yay -S wttrbar`

### Package Updates

**Using waybar-module-pacman-updates:**
```json
"custom/updates": {
    "exec": "waybar-module-pacman-updates",
    "return-type": "json",
    "interval": 600,
    "format": "󰏔 {}",
    "tooltip": true,
    "on-click": "kitty -e yay -Syu"
}
```
Install: `yay -S waybar-module-pacman-updates`

**Simple script alternative:**
```json
"custom/updates": {
    "exec": "checkupdates 2>/dev/null | wc -l",
    "interval": 600,
    "format": "󰏔 {}"
}
```

### Media Player

**Basic playerctl:**
```json
"custom/media": {
    "exec": "playerctl metadata --format '{{artist}} - {{title}}'",
    "exec-if": "playerctl status 2>/dev/null",
    "interval": 5,
    "format": "♪ {}",
    "max-length": 40,
    "on-click": "playerctl play-pause",
    "on-click-right": "playerctl next",
    "on-scroll-up": "playerctl volume 0.05+",
    "on-scroll-down": "playerctl volume 0.05-"
}
```

**Built-in mpris module (preferred):**
```json
"mpris": {
    "format": "{player_icon} {title} - {artist}",
    "format-paused": "{player_icon} {status_icon} {title} - {artist}",
    "player-icons": {
        "default": "▶",
        "firefox": "󰈹",
        "spotify": ""
    },
    "status-icons": {
        "paused": "⏸"
    },
    "max-length": 40
}
```

### Hardware Monitoring

**CPU (built-in):**
```json
"cpu": {
    "format": " {usage}%",
    "interval": 5,
    "tooltip-format": "{avg_frequency} GHz\n{load} load",
    "on-click": "kitty -e btop"
}
```

**Memory (built-in):**
```json
"memory": {
    "format": "󰍛 {percentage}%",
    "format-alt": "󰍛 {used:.1f}G / {total:.1f}G",
    "interval": 10,
    "tooltip-format": "RAM: {used:.1f}G / {total:.1f}G\nSwap: {swapUsed:.1f}G / {swapTotal:.1f}G"
}
```

**Temperature (built-in, AMD CPU):**
```json
"temperature": {
    "thermal-zone": 0,
    "format": " {temperatureC}°C",
    "critical-threshold": 85,
    "format-critical": " {temperatureC}°C",
    "interval": 10
}
```

**GPU Temperature (AMD RX 6800 — custom script):**
```json
"custom/gpu-temp": {
    "exec": "cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input 2>/dev/null | awk '{printf \"%.0f\", $1/1000}'",
    "interval": 10,
    "format": "󰢮 {}°C",
    "tooltip-format": "AMD RX 6800 Edge Temperature"
}
```

**GPU Usage (AMD — custom):**
```json
"custom/gpu-usage": {
    "exec": "cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null",
    "interval": 5,
    "format": "󰢮 {}%"
}
```

### Docker Status
```json
"custom/docker": {
    "exec": "docker ps -q 2>/dev/null | wc -l",
    "exec-if": "systemctl is-active docker",
    "interval": 30,
    "format": "🐳 {}",
    "on-click": "kitty -e lazydocker"
}
```

### Disk Usage
```json
"disk": {
    "path": "/",
    "format": "󰋊 {percentage_used}%",
    "tooltip-format": "{path}: {used} / {total} ({percentage_used}%)",
    "interval": 60
}
```

### Network Speed
```json
"network": {
    "interface": "enp*",
    "format-ethernet": "󰈀 {bandwidthUpBits}↑ {bandwidthDownBits}↓",
    "format-disconnected": "󰈂 Disconnected",
    "tooltip-format": "{ifname}: {ipaddr}/{cidr}\n↑ {bandwidthUpBits} ↓ {bandwidthDownBits}",
    "interval": 5
}
```

### Homelab / Proxmox Status

**Simple ping check:**
```json
"custom/proxmox": {
    "exec": "ping -c1 -W1 proxmox.local >/dev/null 2>&1 && echo '󰒋 UP' || echo '󰒋 DOWN'",
    "interval": 60,
    "format": "{}",
    "tooltip-format": "Proxmox cluster status"
}
```

**API-based (script):**
Create a script that queries the Proxmox API for node health, VM count, etc. Return JSON for rich waybar output.

### System Power Menu
```json
"custom/power": {
    "format": "⏻",
    "tooltip": false,
    "on-click": "wlogout",
    "on-click-right": "hyprlock"
}
```

---

## CSS Theming Guide

### Structure
```css
/* Global */
* {
    font-family: "Maple Mono NF", "Font Awesome 6 Free", sans-serif;
    font-size: 14px;
    min-height: 0;
}

/* Bar background */
window#waybar {
    background: rgba(36, 39, 58, 0.85);
    color: #cad3f5;
}

/* Module groups */
.modules-left { }
.modules-center { }
.modules-right { }
```

### Workspace Buttons
```css
#workspaces button {
    padding: 0 8px;
    color: #a5adcb;
    background: transparent;
    border-bottom: 2px solid transparent;
    border-radius: 0;
    transition: all 0.2s ease;
}

#workspaces button.active {
    color: #c6a0f6;
    border-bottom: 2px solid #c6a0f6;
}

#workspaces button.urgent {
    color: #ed8796;
    border-bottom: 2px solid #ed8796;
}

#workspaces button:hover {
    background: rgba(54, 58, 79, 0.5);
    color: #cad3f5;
}

/* Empty workspace (no windows) */
#workspaces button.empty {
    color: #494d64;
}
```

### Module Styling Patterns

**Individual module colors:**
```css
#clock { color: #8aadf4; }
#cpu { color: #a6da95; }
#memory { color: #f5a97f; }
#temperature { color: #ed8796; }
#temperature.critical { color: #ed8796; animation: blink 0.5s alternate infinite; }
#network { color: #8bd5ca; }
#pulseaudio { color: #f5bde6; }
#tray { color: #cad3f5; }
```

**Pill/capsule module style:**
```css
#clock,
#cpu,
#memory {
    padding: 2px 10px;
    margin: 4px 2px;
    border-radius: 16px;
    background: #363a4f;
}
```

**Glass effect (requires compositor blur):**
```css
window#waybar {
    background: rgba(36, 39, 58, 0.7);
}
```

**Separator between modules:**
```css
#clock,
#cpu,
#memory {
    border-left: 1px solid #494d64;
    padding-left: 8px;
    margin-left: 4px;
}
```

### Animation
```css
@keyframes blink {
    to { color: #cad3f5; }
}

/* Pulsing for critical states */
@keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
}
```

### Tooltip Styling
```css
tooltip {
    background: #1e2030;
    border: 1px solid #494d64;
    border-radius: 8px;
}

tooltip label {
    color: #cad3f5;
    padding: 4px;
}
```

---

## On-Demand Refresh with Signals

Instead of polling, trigger module updates on events:
```json
"custom/updates": {
    "exec": "check-updates-script",
    "signal": 8,
    "interval": "once"
}
```

Trigger from any script:
```bash
pkill -RTMIN+8 waybar
```

Useful for: package updates after `yay`, volume changes, network toggles.

---

## Module Development Tips

1. Use `return-type: "json"` for rich output with tooltip and CSS class support
2. Use `signal` for event-driven updates instead of short polling intervals
3. Use `on-click`, `on-click-right`, `on-scroll-up/down` for interactivity
4. Keep intervals reasonable: weather 3600s, updates 600s, media 5s, hardware 5-10s
5. Use `exec-if` to hide modules when irrelevant (e.g., no docker running)
6. Use `format-alt` for toggling between compact and detailed views on click
7. Use `max-length` to prevent long text from breaking layout
8. Test scripts independently before adding to waybar config

---

## Alternative Widget Frameworks

### eww (ElKowars Wacky Widgets)
- **Language:** Rust
- **Config:** Yuck (lisp-like) + SCSS
- **Strengths:** Flexible layout, any shape widget, good for custom bars and overlays
- **Install:** `yay -S eww-git`
- **Docs:** `github.com/elkowar/eww`

### AGS (Aylur's GTK Shell)
- **Language:** TypeScript/JavaScript
- **Config:** TypeScript with GTK widgets
- **Strengths:** Very powerful, excellent Hyprland integration, reactive
- **Install:** `yay -S ags`
- **Docs:** `github.com/Aylur/ags`

### HyprPanel
- **Language:** TypeScript
- **Config:** TypeScript, built on AGS
- **Strengths:** Purpose-built for Hyprland, feature-rich, notifications, media, theming
- **Install:** `yay -S hyprpanel-git`
- **Docs:** `github.com/Jas-SinghFSU/HyprPanel`

### ironbar
- **Language:** Rust
- **Config:** JSON/YAML/TOML/Corn
- **Strengths:** Fast, well-documented, good module system
- **Install:** `yay -S ironbar-git`
- **Docs:** `github.com/JakeStanger/ironbar`

### fabric
- **Language:** Python
- **Config:** Python GTK widgets
- **Strengths:** Easy to prototype, Python ecosystem
- **Install:** pip or AUR
- **Docs:** `github.com/Fabric-Development/fabric`

### When to Consider Switching
- **Stick with Waybar** if: simple bar, standard modules, JSON config is fine
- **Consider HyprPanel** if: want all-in-one (notifications, OSD, bar) with Hyprland focus
- **Consider AGS** if: want maximum customization with TypeScript
- **Consider eww** if: want creative non-bar widgets (dashboards, popups, sidebars)
- **Consider ironbar** if: want Rust performance with good module system
