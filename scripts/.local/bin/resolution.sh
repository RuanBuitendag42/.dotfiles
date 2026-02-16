#!/usr/bin/env bash
# Script: resolution.sh
# Purpose: Quick resolution switching for Hyprland (TV/monitor)
# Usage: resolution.sh [1080|4k|list|current]
# Note: this script now persists the selected mode to your Hyprland config
#       (`$XDG_CONFIG_HOME/hypr/hyprland.conf`) and reloads Hyprland.

set -euo pipefail

# defaults (can be overridden by environment)
MONITOR="${MONITOR:-HDMI-A-1}"
RATE="${RATE:-60}"
DEBUG=${DEBUG:-0}

# allow a '--debug' or '-d' prefix to enable diagnostic output
if [ "${1:-}" = "--debug" ] || [ "${1:-}" = "-d" ]; then
    DEBUG=1
    shift || true
fi

# hyprland config path (respects XDG_CONFIG_HOME)
HYPRCONF="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.conf"

_debug() {
    [ "$DEBUG" -eq 1 ] && echo "[resolution.sh debug]" "$@" >&2 || true
}

_backup_hyprconf() {
    # backups disabled by request — no-op to keep call-sites safe
    return 0
}

_apply_now() {
    local mode_str="$1"
    if command -v hyprctl >/dev/null 2>&1; then
        hyprctl keyword monitor "$mode_str"
    else
        echo "hyprctl not found — applied persistence only (if possible)" >&2
    fi
}

_persist_to_conf() {
    local mode_str="$1" monitor_name="$2"
    local target_conf gitroot relpath commit_msg

    # resolve symlink if necessary so we edit the source file (keeps stow/git sane)
    target_conf="$HYPRCONF"
    if [ -L "$target_conf" ]; then
        target_conf=$(readlink -f "$target_conf")
    fi

    if [ ! -f "$target_conf" ]; then
        echo "Warning: $target_conf not found — skipping persistence." >&2
        return 1
    fi

    # (backups disabled) Replace the monitor line for this output if present; otherwise replace first monitor= line; otherwise insert near Monitor header or at top.
    if grep -qE "^\s*monitor\s*=.*${monitor_name}" "$target_conf"; then
        sed -i -E "s|(^\s*monitor\s*=).*|\1 ${mode_str}|" "$target_conf"
    elif grep -qE "^\s*monitor\s*=" "$target_conf"; then
        sed -i -E "0,/^\s*monitor\s*=/s|^\s*monitor\s*=.*|monitor = ${mode_str}|" "$target_conf"
    else
        if grep -q "─ Monitor" "$target_conf"; then
            awk -v new="monitor = ${mode_str}" 'BEGIN{inserted=0} {print; if(!inserted && /Monitor/){print new; inserted=1}}' "$target_conf" > "$target_conf.tmp" && mv "$target_conf.tmp" "$target_conf"
        else
            sed -i "1s|^|monitor = ${mode_str}\n|" "$target_conf"
        fi
    fi

    # reload hyprland so persisted config is applied (harmless if hyprctl missing)
    if command -v hyprctl >/dev/null 2>&1; then
        hyprctl reload
    fi

    # Auto-commit if the file lives inside a git repo (opt-out with RESOLUTION_NO_COMMIT=1)
    if [ "${RESOLUTION_NO_COMMIT:-0}" -ne 1 ]; then
        gitroot=$(git -C "$(dirname "$target_conf")" rev-parse --show-toplevel 2>/dev/null || true)
        if [ -n "$gitroot" ]; then
            relpath=$(realpath --relative-to="$gitroot" "$target_conf")
            git -C "$gitroot" add -- "$relpath" >/dev/null 2>&1 || true
            commit_msg="chore(hyprland): persist monitor ${mode_str} (resolution.sh)"
            if git -C "$gitroot" diff --staged --quiet -- "$relpath"; then
                # nothing to commit
                :
            else
                git -C "$gitroot" commit -m "$commit_msg" -- "$relpath" >/dev/null 2>&1 || echo "Note: git commit failed for $relpath" >&2
                echo "Committed $relpath in $gitroot"
                # optional push if requested
                if [ "${RESOLUTION_AUTO_PUSH:-0}" -eq 1 ]; then
                    git -C "$gitroot" push || echo "Note: git push failed" >&2
                fi
            fi
        fi
    fi
}

# convenience: detect primary monitor if MONITOR set to AUTO or empty
_detect_monitor_if_needed() {
    if [ -z "$MONITOR" ] || [ "$MONITOR" = "AUTO" ]; then
        if command -v hyprctl >/dev/null 2>&1; then
            MONITOR=$(hyprctl monitors -j | python3 -c "import json,sys; d=json.load(sys.stdin); print(d[0]['name'] if d else '')")
        fi
    fi
}

# return: width height refresh scale  (for given monitor name)
# This returns the CURRENT active mode (fallback) — used by `current` output.
_get_current_monitor_info() {
    local mname="${1:-}"
    if ! command -v hyprctl >/dev/null 2>&1; then
        return 1
    fi

    # call hyprctl from Python to avoid stdin/heredoc piping problems
    _debug "hyprctl monitors -j (live)"
    python3 - "$mname" <<'PY' || return 1
import sys, json, subprocess
mname = sys.argv[1] if len(sys.argv) > 1 else ""
try:
    s = subprocess.check_output(["hyprctl","monitors","-j"], stderr=subprocess.DEVNULL).decode()
except Exception:
    sys.exit(1)
try:
    data = json.loads(s)
except Exception:
    sys.exit(1)
for m in data:
    if not mname or m.get('name') == mname:
        width = m.get('width')
        height = m.get('height')
        rr = int(round(m.get('refreshRate', 60)))
        scale = int(round(m.get('scale', 1)))
        print(f"{width} {height} {rr} {scale}")
        sys.exit(0)
sys.exit(1)
PY
}


# return: width height refresh scale for the BEST / PREFERRED available mode
_get_best_monitor_info() {
    local mname="${1:-}"
    if ! command -v hyprctl >/dev/null 2>&1; then
        return 1
    fi

    _debug "hyprctl monitors -j (live)"
    python3 - "$mname" <<'PY' || return 1
import sys, json, subprocess, re
mname = sys.argv[1] if len(sys.argv) > 1 else ""
try:
    s = subprocess.check_output(["hyprctl","monitors","-j"], stderr=subprocess.DEVNULL).decode()
except Exception:
    sys.exit(1)
try:
    data = json.loads(s)
except Exception:
    sys.exit(1)
for m in data:
    if mname and m.get('name') != mname:
        continue
    # 1) prefer explicit preferredMode if present (string or dict)
    pref = m.get('preferredMode')
    if pref:
        try:
            if isinstance(pref, dict):
                w = int(pref.get('width') or pref.get('w'))
                h = int(pref.get('height') or pref.get('h'))
                rr = int(round(float(pref.get('refresh') or pref.get('refreshRate') or pref.get('refreshRateHz') or 60)))
            else:
                res, rr_s = str(pref).split('@')
                w, h = map(int, res.split('x'))
                rr_num = re.sub(r'[^0-9.]', '', rr_s)
                rr = int(round(float(rr_num))) if rr_num else 60
            scale = int(round(m.get('scale', 1)))
            print(f"{w} {h} {rr} {scale}")
            sys.exit(0)
        except Exception:
            pass
    # 2) otherwise pick the availableMode with largest area, then highest refresh
    modes = m.get('availableModes') or m.get('modes') or []
    best = None
    for mode in modes:
        try:
            if isinstance(mode, dict):
                w = int(mode.get('width') or mode.get('w'))
                h = int(mode.get('height') or mode.get('h'))
                rr = int(round(float(mode.get('refresh') or mode.get('refreshRate') or mode.get('refreshRateHz') or 60)))
            else:
                # string like "2560x1440@144.000"
                parts = str(mode).split('@')
                res = parts[0]
                rr_s = parts[1] if len(parts) > 1 else ''
                rr_num = re.sub(r'[^0-9.]', '', rr_s)
                rr = int(round(float(rr_num))) if rr_num else 60
                w, h = map(int, res.split('x'))
            area = w * h
            # prefer higher refresh first, then larger area
            if best is None or rr > best[0] or (rr == best[0] and area > best[1]):
                best = (rr, area, w, h)
        except Exception:
            continue
    if best:
        scale = int(round(m.get('scale', 1)))
        print(f"{best[2]} {best[3]} {best[0]} {scale}")
        sys.exit(0)
    # 3) fallback to current active mode
    if 'width' in m and 'height' in m:
        width = m.get('width')
        height = m.get('height')
        rr = int(round(m.get('refreshRate', 60)))
        scale = int(round(m.get('scale', 1)))
        print(f"{width} {height} {rr} {scale}")
        sys.exit(0)
sys.exit(1)
PY
}

_detect_monitor_if_needed

# No-args behaviour: detect the monitor's preferred / best available mode and persist it
if [ "$#" -eq 0 ]; then
    if command -v hyprctl >/dev/null 2>&1; then
        # prefer the monitor's preferred / max available mode (so we move from 1080->1440@144 where supported)
        read -r W H R S < <(_get_best_monitor_info "$MONITOR") || true
        if [ -z "${W:-}" ]; then
            echo "Could not detect preferred monitor mode for $MONITOR" >&2
            exit 1
        fi
        MODE_STR="$MONITOR, ${W}x${H}@${R}, auto, ${S}"
        _apply_now "$MODE_STR"
        _persist_to_conf "$MODE_STR" "$MONITOR" && echo "Persisted to $HYPRCONF"
        exit 0
    else
        echo "No arguments and hyprctl not available — nothing to do" >&2
        exit 1
    fi
fi

case "${1:-}" in
    1080|1080p|fhd)
        RES="1920x1080"
        SCALE=1
        MODE_STR="$MONITOR, ${RES}@${RATE}, auto, ${SCALE}"
        _apply_now "$MODE_STR"
        _persist_to_conf "$MODE_STR" "$MONITOR" && echo "Persisted to $HYPRCONF"
        echo "Switched to 1080p"
        ;;
    1200)
        RES="1920x1200"
        SCALE=1
        MODE_STR="$MONITOR, ${RES}@${RATE}, auto, ${SCALE}"
        _apply_now "$MODE_STR"
        _persist_to_conf "$MODE_STR" "$MONITOR" && echo "Persisted to $HYPRCONF"
        echo "Switched to 1920x1200"
        ;;
    1440|2k|qhd)
        RES="2560x1440"
        SCALE=1
        MODE_STR="$MONITOR, ${RES}@${RATE}, auto, ${SCALE}"
        _apply_now "$MODE_STR"
        _persist_to_conf "$MODE_STR" "$MONITOR" && echo "Persisted to $HYPRCONF"
        echo "Switched to 1440p"
        ;;
    4k|2160|uhd)
        RES="3840x2160"
        SCALE=1
        MODE_STR="$MONITOR, ${RES}@${RATE}, auto, ${SCALE}"
        _apply_now "$MODE_STR"
        _persist_to_conf "$MODE_STR" "$MONITOR" && echo "Persisted to $HYPRCONF"
        echo "Switched to 4K"
        ;;
    4k-scaled|4ks)
        RES="3840x2160"
        SCALE=2
        MODE_STR="$MONITOR, ${RES}@${RATE}, auto, ${SCALE}"
        _apply_now "$MODE_STR"
        _persist_to_conf "$MODE_STR" "$MONITOR" && echo "Persisted to $HYPRCONF"
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
        echo "  (no args)            Persist the current active mode for the detected monitor"
        echo "  1080, 1080p, fhd     1920x1080 (recommended for TV)"
        echo "  1200                 1920x1200"
        echo "  1440, 2k, qhd        2560x1440"
        echo "  4k, 2160, uhd        3840x2160 (native)"
        echo "  4k-scaled, 4ks       3840x2160 at 2x scale (sharp 1080p)"
        echo "  list                 Show available modes"
        echo "  current              Show current resolution"
        echo ""
        echo "Environment variables:"
        echo "  RESOLUTION_NO_COMMIT=1   skip auto-commit (default: commit if file is in a git repo)"
        echo "  RESOLUTION_AUTO_PUSH=1   push after commit (default: no push)"
        ;;
esac
