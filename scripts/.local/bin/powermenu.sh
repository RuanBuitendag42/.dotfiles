#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  侍  POWER MENU  ·  電源メニュー  ·  CYBERPUNK SAMURAI
#  Catppuccin Macchiato  ·  ネオン浪人
# ═══════════════════════════════════════════════════════════════
# Used by Hyprland keybind SUPER+M

set -e

options="  鍵 ─ Lock\n  退 ─ Logout\n  眠 ─ Suspend\n  再 ─ Reboot\n  終 ─ Shutdown"

chosen=$(echo -e "$options" | wofi --dmenu \
    --prompt "電源 Power" \
    --width 280 \
    --height 350 \
    --cache-file /dev/null \
    --define=key_expand=Tab)

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
