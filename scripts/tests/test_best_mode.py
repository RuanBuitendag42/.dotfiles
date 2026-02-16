#!/usr/bin/env python3
"""
Simple test harness that mimics the resolution.sh _get_best_monitor_info logic
and prints the chosen mode for each fixture.
"""
import json
import pathlib

FIXTURES = {
    'sample_hyprctl_available_strings.json': '2560 1440 144 1',
    'sample_hyprctl_preferred_dict.json': '2560 1440 144 1',
    'sample_hyprctl_available_dicts.json': '2560 1440 144 1',
    'sample_hyprctl_no_available.json': '1920 1080 60 1',
}

ROOT = pathlib.Path(__file__).parent


def choose_best_mode(jdata, monitor_name=None):
    for m in jdata:
        if monitor_name and m.get('name') != monitor_name:
            continue
        # preferredMode
        pref = m.get('preferredMode')
        if pref:
            if isinstance(pref, dict):
                w = int(pref.get('width') or pref.get('w'))
                h = int(pref.get('height') or pref.get('h'))
                rr = int(round(float(pref.get('refresh') or pref.get('refreshRate') or 60)))
            else:
                res, rr_s = str(pref).split('@')
                w, h = map(int, res.split('x'))
                rr = int(round(float(rr_s)))
            scale = int(round(m.get('scale', 1)))
            return f"{w} {h} {rr} {scale}"
        # availableModes / modes
        modes = m.get('availableModes') or m.get('modes') or []
        best = None
        for mode in modes:
            try:
                if isinstance(mode, dict):
                    w = int(mode.get('width') or mode.get('w'))
                    h = int(mode.get('height') or mode.get('h'))
                    rr = int(round(float(mode.get('refresh') or mode.get('refreshRate') or 60)))
                else:
                    parts = str(mode).split('@')
                    res = parts[0]
                    rr = int(round(float(parts[1]))) if len(parts) > 1 else 60
                    w, h = map(int, res.split('x'))
                area = w * h
                # prefer higher refresh first, then larger area
                if best is None or rr > best[0] or (rr == best[0] and area > best[1]):
                    best = (rr, area, w, h)
            except Exception:
                continue
        if best:
            scale = int(round(m.get('scale', 1)))
            return f"{best[2]} {best[3]} {best[0]} {scale}"
        # fallback to current
        if 'width' in m and 'height' in m:
            width = m.get('width')
            height = m.get('height')
            rr = int(round(m.get('refreshRate', 60)))
            scale = int(round(m.get('scale', 1)))
            return f"{width} {height} {rr} {scale}"
    return None


if __name__ == '__main__':
    all_ok = True
    for fname, expect in FIXTURES.items():
        path = ROOT / fname
        data = json.loads(path.read_text())
        out = choose_best_mode(data, 'HDMI-A-1')
        ok = out == expect
        print(f"{fname}: -> {out}  {'OK' if ok else 'FAIL (expected '+expect+')'}")
        all_ok = all_ok and ok
    raise SystemExit(0 if all_ok else 2)
