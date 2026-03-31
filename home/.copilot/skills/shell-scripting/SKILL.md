---
name: shell-scripting
description: "Bash/ZSH scripting for wallpaper, display profiles, system automation, and Hyprland"
---

# Shell Scripting for Dotfiles & Hyprland

Patterns and conventions for scripts that manage wallpapers, display profiles, system maintenance, and Hyprland integration.

---

## Script Location & Conventions

### Where Scripts Live

- **Source:** `scripts/.local/bin/` in the dotfiles repo
- **Deployed to:** `~/.local/bin/` via `make install-scripts`
- **On PATH:** `~/.local/bin` is added to `$PATH` in `.zshrc`

### Script Standards

```bash
#!/usr/bin/env bash       # Shebang — use env for portability
set -euo pipefail         # Strict mode: exit on error, undefined vars, pipe failures

# Script description and usage
# Usage: scriptname.sh [options]
```

- Make executable: `chmod +x script.sh`
- Use `#!/usr/bin/env bash` for general scripts
- Use `#!/bin/zsh` only for ZSH-specific features
- Name convention: `descriptive-name.sh`

---

## Existing Scripts Reference

| Script | Purpose |
|--------|---------|
| `wallpaper.sh` | Wallpaper selection and rotation |
| `resolution.sh` | Monitor resolution switching |
| `powermenu.sh` | Logout/shutdown/reboot menu via wofi |
| `reload-waybar.sh` | Restart Waybar cleanly |
| `fetch-wallpapers.sh` | Download wallpaper collections |

---

## Wallpaper Management Patterns

### Random Wallpaper

```bash
#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Pick random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \) | shuf -n 1)

if [[ -z "$WALLPAPER" ]]; then
    notify-send "Wallpaper" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

swww img "$WALLPAPER" \
    --transition-type grow \
    --transition-fps 60 \
    --transition-duration 2
```

### swww Transitions

| Transition | Effect |
|-----------|--------|
| `grow` | Grow from center point |
| `fade` | Simple cross-fade |
| `wipe` | Directional wipe |
| `wave` | Wave effect |
| `outer` | Grow from edges inward |
| `random` | Random transition type |
| `none` | Instant switch |

**Transition options:**
```bash
swww img "$WALLPAPER" \
    --transition-type grow \
    --transition-fps 60 \          # Smooth animation
    --transition-duration 2 \      # Seconds
    --transition-pos 0.5,0.5 \     # Origin point (center)
    --transition-bezier .43,1.19,1,.4  # Custom easing
```

### Wallpaper Selector with Wofi

```bash
#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" \) | \
    sort | \
    wofi --dmenu --prompt "Wallpaper")

[[ -n "$WALLPAPER" ]] && swww img "$WALLPAPER" --transition-type fade --transition-duration 1
```

---

## Display Profile Switching

### Resolution Profiles

```bash
#!/usr/bin/env bash
set -euo pipefail

# Resolution profiles for HDMI-A-1 (2560x1440 native)
case "${1:-}" in
    "1080")  hyprctl keyword monitor "HDMI-A-1,1920x1080@60,auto,1" ;;
    "1440")  hyprctl keyword monitor "HDMI-A-1,2560x1440@60,auto,1" ;;
    "4k")    hyprctl keyword monitor "HDMI-A-1,3840x2160@60,auto,1" ;;
    "4k-s")  hyprctl keyword monitor "HDMI-A-1,3840x2160@60,auto,1.5" ;;
    *)
        echo "Usage: $0 {1080|1440|4k|4k-s}"
        echo "  1080  — 1920x1080 (gaming)"
        echo "  1440  — 2560x1440 (native)"
        echo "  4k    — 3840x2160 (1:1 scale)"
        echo "  4k-s  — 3840x2160 (1.5x scale)"
        exit 1
        ;;
esac

notify-send "Display" "Resolution changed to $1"
```

---

## System Maintenance Scripts

### Health Check

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "=== Failed Services ==="
systemctl --failed --no-pager || true

echo ""
echo "=== Orphan Packages ==="
pacman -Qdtq 2>/dev/null || echo "No orphans"

echo ""
echo "=== Pacnew Files ==="
find /etc -name "*.pacnew" 2>/dev/null || echo "No pacnew files"

echo ""
echo "=== Disk Usage ==="
duf 2>/dev/null || df -h
```

### Package List Sync

```bash
#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/Developer/github/.dotfiles"

# Save current package lists
pacman -Qeq | sort > "$DOTFILES/packages/pacman.txt"
pacman -Qmq | sort > "$DOTFILES/packages/aur.txt"

echo "Package lists saved to $DOTFILES/packages/"
```

---

## Hyprland Integration

### Hyprctl Commands

| Command | Purpose |
|---------|---------|
| `hyprctl dispatch exec [cmd]` | Launch application |
| `hyprctl dispatch workspace N` | Switch to workspace N |
| `hyprctl dispatch movetoworkspace N` | Move window to workspace |
| `hyprctl dispatch fullscreen 1` | Toggle fullscreen |
| `hyprctl dispatch togglefloating` | Toggle floating |
| `hyprctl keyword monitor ...` | Set monitor config at runtime |
| `hyprctl keyword general:gaps_out N` | Adjust gaps at runtime |
| `hyprctl notify 1 5000 "rgb(a6da95)" "Message"` | Send notification |
| `hyprctl reload` | Reload config |

### JSON Queries

```bash
# Get focused monitor name
hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'

# Get active window class
hyprctl activewindow -j | jq -r '.class'

# Count windows on current workspace
hyprctl clients -j | jq '[.[] | select(.workspace.id == 1)] | length'

# List all window classes
hyprctl clients -j | jq -r '.[].class' | sort -u
```

### Notification Pattern

```bash
# Desktop notification with notify-send
notify-send "Title" "Body text" --urgency=normal --expire-time=3000

# Hyprland native notification (colored)
hyprctl notify 1 5000 "rgb(a6da95)" "fontsize:14 Success!"
# Severity: 0=info, 1=warning, 2=error, 3=confusion
```

---

## Script Best Practices

### Error Handling

```bash
#!/usr/bin/env bash
set -euo pipefail  # ALWAYS use this

# Trap for cleanup
cleanup() {
    rm -f "$TMPFILE" 2>/dev/null
}
trap cleanup EXIT

TMPFILE=$(mktemp)
```

### Variable Quoting

```bash
# ALWAYS quote variables
echo "$variable"        # Correct
some_command "$path"    # Correct

# NEVER unquoted
echo $variable          # WRONG — word splitting and globbing
some_command $path      # WRONG
```

### Dependency Checking Pattern

```bash
check_deps() {
    local missing=()
    for cmd in "$@"; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    if (( ${#missing[@]} )); then
        echo "Error: Missing commands: ${missing[*]}" >&2
        echo "Install with: pacman -S ${missing[*]}" >&2
        exit 1
    fi
}

# Check all needed commands upfront
check_deps swww hyprctl jq notify-send
```

### Conditional Patterns

```bash
# Use [[ ]] for conditionals (bash/zsh)
[[ -f "$file" ]] && echo "File exists"
[[ -d "$dir" ]] || mkdir -p "$dir"
[[ -z "$var" ]] && echo "Variable is empty"
[[ "$str" == "value" ]] && echo "Match"

# Command existence check
if command -v swww &>/dev/null; then
    swww img "$WALLPAPER"
else
    echo "swww not installed" >&2
fi
```

### Logging Pattern

```bash
#!/usr/bin/env bash
LOG="/tmp/$(basename "$0" .sh).log"

log() {
    echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOG"
}

log "Script started"
log "Processing..."
```

### User Input with Wofi

```bash
# Selection from list
choice=$(echo -e "Option 1\nOption 2\nOption 3" | wofi --dmenu --prompt "Choose")

# Confirmation
confirm=$(echo -e "Yes\nNo" | wofi --dmenu --prompt "Are you sure?")
[[ "$confirm" == "Yes" ]] || exit 0
```

---

## Script Templates

### Simple Script

```bash
#!/usr/bin/env bash
set -euo pipefail

# Description: What this script does
# Usage: script.sh [args]

main() {
    # Script logic here
    echo "Done"
}

main "$@"
```

### Script with Options

```bash
#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help     Show this help
  -v, --verbose  Verbose output
  -d, --dry-run  Show what would happen
EOF
}

VERBOSE=false
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage; exit 0 ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -d|--dry-run) DRY_RUN=true; shift ;;
        *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
    esac
done

# Script logic using $VERBOSE and $DRY_RUN
```

### Hyprland Integration Script

```bash
#!/usr/bin/env bash
set -euo pipefail

check_deps() {
    local missing=()
    for cmd in "$@"; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    if (( ${#missing[@]} )); then
        notify-send "Script Error" "Missing: ${missing[*]}" --urgency=critical
        exit 1
    fi
}

check_deps hyprctl jq notify-send

# Your Hyprland automation here
MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
notify-send "Monitor" "Active: $MONITOR"
```
