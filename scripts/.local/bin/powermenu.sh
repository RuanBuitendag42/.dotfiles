#!/usr/bin/env bash
# Power menu using wofi - Catppuccin Macchiato themed
# Used by Hyprland keybind SUPER+M

set -e

options="  Lock\n  Logout\n  Suspend\n  Reboot\n  Shutdown"

chosen=$(echo -e "$options" | wofi --dmenu --prompt "Power" --width 250 --height 300 --cache-file /dev/null)

case "$chosen" in
    *Lock)
        hyprlock
        ;;
    *Logout)
        hyprctl dispatch exit
        ;;
    *Suspend)
        systemctl suspend
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Shutdown)
        systemctl poweroff
        ;;
esac
