#!/usr/bin/env bash
# Random wallpaper selector for Hyprland
# Uses swww to set wallpapers from ~/Pictures/Wallpapers

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Get random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Set wallpaper with swww
swww img "$WALLPAPER" --transition-fps 60 --transition-type fade --transition-duration 2

echo "Set wallpaper: $(basename "$WALLPAPER")"
