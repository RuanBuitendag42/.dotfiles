#!/usr/bin/env bash
# Script: reload-waybar.sh
# Purpose: Kill and restart waybar with fresh config
# Usage: reload-waybar.sh

set -e

echo "Reloading waybar..."
killall waybar 2>/dev/null || true
sleep 0.3
waybar &
disown
echo "Waybar reloaded!"
