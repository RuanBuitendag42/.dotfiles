#!/usr/bin/env bash
# Script: resolution.sh
# Purpose: Quick resolution switching for Hyprland (TV/monitor)
# Usage: resolution.sh [1080|4k|list|current]

set -e

MONITOR="HDMI-A-1"
RATE="60"

case "${1:-}" in
    1080|1080p|fhd)
        hyprctl keyword monitor "$MONITOR, 1920x1080@${RATE}, auto, 1"
        echo "Switched to 1080p"
        ;;
    1200)
        hyprctl keyword monitor "$MONITOR, 1920x1200@${RATE}, auto, 1"
        echo "Switched to 1920x1200"
        ;;
    1440|2k|qhd)
        hyprctl keyword monitor "$MONITOR, 2560x1440@${RATE}, auto, 1"
        echo "Switched to 1440p"
        ;;
    4k|2160|uhd)
        hyprctl keyword monitor "$MONITOR, 3840x2160@${RATE}, auto, 1"
        echo "Switched to 4K"
        ;;
    4k-scaled|4ks)
        hyprctl keyword monitor "$MONITOR, 3840x2160@${RATE}, auto, 2"
        echo "Switched to 4K scaled (2x = effective 1080p, sharper text)"
        ;;
    list)
        echo "Available modes:"
        hyprctl monitors -j | python3 -c "
import json, sys
data = json.load(sys.stdin)
for m in data:
    print(f\"  Monitor: {m['name']}\")
    print(f\"  Current: {m['width']}x{m['height']}@{m['refreshRate']:.0f}Hz (scale {m['scale']:.1f})\")
    print(f\"  Modes:\")
    seen = set()
    for mode in m.get('availableModes', []):
        key = mode.split('@')[0]
        if key not in seen:
            seen.add(key)
            print(f'    {mode}')
"
        ;;
    current)
        hyprctl monitors -j | python3 -c "
import json, sys
data = json.load(sys.stdin)
for m in data:
    print(f\"{m['name']}: {m['width']}x{m['height']}@{m['refreshRate']:.0f}Hz (scale {m['scale']:.1f})\")
"
        ;;
    *)
        echo "Usage: resolution.sh <mode>"
        echo ""
        echo "  1080, 1080p, fhd    1920x1080 (recommended for TV)"
        echo "  1200                 1920x1200"
        echo "  1440, 2k, qhd       2560x1440"
        echo "  4k, 2160, uhd        3840x2160 (native)"
        echo "  4k-scaled, 4ks       3840x2160 at 2x scale (sharp 1080p)"
        echo "  list                 Show available modes"
        echo "  current              Show current resolution"
        ;;
esac
