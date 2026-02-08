#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  侍  WALLPAPER.SH  ·  壁紙  ·  CYBERPUNK WALL SWITCHER
#  Random wallpaper with neon swww transitions
# ═══════════════════════════════════════════════════════════════
# Usage: wallpaper.sh           # random wallpaper, random transition
#        wallpaper.sh <path>    # set specific wallpaper
#        wallpaper.sh --loop    # auto-rotate every 15 minutes

set -e

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
INTERVAL=900  # 15 minutes for --loop mode

# ─── Catppuccin Macchiato accent color for transitions ────────
BEZIER="0.4,0.0,0.2,1.0"
TRANSITION_FPS=60

# Cyberpunk-style transitions (randomly picked)
TRANSITIONS=("wipe" "wave" "grow" "outer" "any")
ANGLES=(0 30 45 90 135 180 225 270 315)

pick_transition() {
    local t="${TRANSITIONS[$((RANDOM % ${#TRANSITIONS[@]}))]}"
    local a="${ANGLES[$((RANDOM % ${#ANGLES[@]}))]}"
    echo "$t $a"
}

set_wallpaper() {
    local img="$1"
    read -r trans angle <<< "$(pick_transition)"

    swww img "$img" \
        --transition-fps "$TRANSITION_FPS" \
        --transition-type "$trans" \
        --transition-angle "$angle" \
        --transition-duration 2 \
        --transition-bezier "$BEZIER"

    echo "壁紙 Set: $(basename "$img") [transition: $trans ${angle}°]"
}

# ─── Validate wallpaper directory ─────────────────────────────
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "壁紙 Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# ─── Specific wallpaper mode ─────────────────────────────────
if [ -n "$1" ] && [ "$1" != "--loop" ]; then
    if [ -f "$1" ]; then
        set_wallpaper "$1"
        exit 0
    else
        echo "壁紙 File not found: $1"
        exit 1
    fi
fi

# ─── Pick random wallpaper ───────────────────────────────────
pick_random() {
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n 1
}

# ─── Loop mode (auto-rotate) ─────────────────────────────────
if [ "$1" = "--loop" ]; then
    echo "壁紙 Loop mode: rotating every ${INTERVAL}s"
    while true; do
        WALLPAPER=$(pick_random)
        [ -n "$WALLPAPER" ] && set_wallpaper "$WALLPAPER"
        sleep "$INTERVAL"
    done
    exit 0
fi

# ─── Single random wallpaper ─────────────────────────────────
WALLPAPER=$(pick_random)

if [ -z "$WALLPAPER" ]; then
    echo "壁紙 No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

set_wallpaper "$WALLPAPER"
