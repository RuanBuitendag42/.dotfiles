---
name: gaming-linux
description: "AMD RX 6800 GPU optimization, Steam/Proton, Lutris, MangoHud, GameMode, and Hyprland gaming rules"
---

# Linux Gaming Reference

Complete reference for gaming on Arch Linux with AMD RX 6800, Hyprland, Steam/Proton, Lutris, and performance optimization.

---

## AMD RX 6800 GPU Setup

### Driver Stack

| Component | Package | Purpose |
|-----------|---------|---------|
| AMDGPU | Built into kernel | Kernel-level GPU driver (open source) |
| Mesa | `mesa` | OpenGL/Vulkan userspace driver |
| Mesa 32-bit | `lib32-mesa` | 32-bit support (required for Steam) |
| RADV | Part of Mesa | Vulkan driver for AMD (default, excellent) |
| ACO | Part of Mesa | AMD shader compiler (default, faster than LLVM) |
| Vulkan ICD | `vulkan-radeon` | Vulkan installable client driver |
| Vulkan 32-bit | `lib32-vulkan-radeon` | 32-bit Vulkan (for Proton/Wine) |

### Verify GPU Setup

```bash
# Check Vulkan driver
vulkaninfo | grep driverName
# Should show: RADV (radv)

# Check OpenGL
glxinfo | grep "OpenGL renderer"
# Should show: AMD Radeon RX 6800

# Check GPU info
lspci -k | grep -A3 VGA

# Verify 32-bit libs are installed
pacman -Qs lib32-mesa lib32-vulkan
```

### Required Packages

```bash
# Essential
pacman -S mesa vulkan-radeon lib32-mesa lib32-vulkan-radeon

# Monitoring
pacman -S radeontop lm-sensors
```

---

## GPU Monitoring

| Tool | Command | Purpose |
|------|---------|---------|
| `radeontop` | `radeontop` | Real-time GPU usage monitor |
| `sensors` | `sensors` | Temperature readings |
| `corectrl` | GUI app (AUR) | GPU clocking, fan curves |
| `btop` | `btop` | Includes GPU monitoring |

### GPU Temperature for Scripts/Waybar

```bash
# Read GPU temp (divide by 1000 for °C)
cat /sys/class/drm/card1/device/hwmon/hwmon*/temp1_input | awk '{printf "%.0f°C\n", $1/1000}'

# GPU usage percentage
cat /sys/class/drm/card1/device/gpu_busy_percent
```

---

## Steam + Proton

### Installation

```bash
# Requires multilib repo enabled in /etc/pacman.conf
pacman -S steam
```

### Proton Setup

1. Steam → Settings → Compatibility
2. Enable **"Enable Steam Play for all other titles"**
3. Select Proton version (latest stable or Proton-GE)

### Proton-GE (Community Build)

Proton-GE includes extra patches, media codecs, and game fixes not in official Proton:

```bash
# Install via AUR
yay -S proton-ge-custom-bin
```

After installing, select it per-game: Game Properties → Compatibility → Force specific tool.

### Launch Options

Common Steam launch options (right-click game → Properties → Launch Options):

| Launch Option | Purpose |
|--------------|---------|
| `MANGOHUD=1 %command%` | Enable MangoHud overlay |
| `gamemoderun %command%` | Enable GameMode optimizations |
| `MANGOHUD=1 gamemoderun %command%` | Both MangoHud + GameMode |
| `DXVK_ASYNC=1 %command%` | Async shader compilation (reduces stuttering) |
| `AMD_VULKAN_ICD=RADV %command%` | Force RADV driver |
| `PROTON_USE_WINED3D=1 %command%` | Use OpenGL instead of Vulkan (compatibility fallback) |
| `PROTON_NO_ESYNC=1 %command%` | Disable esync (debugging) |

### Check Compatibility

- **ProtonDB** (protondb.com) — community reports on game compatibility
- Ratings: Platinum > Gold > Silver > Bronze > Borked
- Check for game-specific tweaks and launch options

---

## Lutris

### Installation

```bash
pacman -S lutris wine-staging
```

### Usage

- Manages non-Steam games, emulators, Windows applications
- Uses Wine runners (system Wine or custom builds)
- Install scripts available from lutris.net
- Good for: Battle.net, Epic Games, GOG, standalone games

### Common Runners

| Runner | Purpose |
|--------|---------|
| Wine (system) | System-installed Wine |
| Wine-GE | Custom Wine with gaming patches |
| Proton | Valve's Wine fork |
| Linux | Native Linux games |

---

## MangoHud

On-screen display showing FPS, CPU/GPU usage, temps, and frame timing.

### Installation

```bash
pacman -S mangohud lib32-mangohud
```

### Enabling

```bash
# Environment variable
MANGOHUD=1 game_command

# Steam launch option
MANGOHUD=1 %command%

# Lutris: enable in runner options
```

### Configuration

Config file: `~/.config/MangoHud/MangoHud.conf`

```ini
# Toggle HUD
toggle_hud=F12
toggle_fps_limit=F11

# Position
position=top-left

# Display options
fps
gpu_stats
gpu_temp
cpu_stats
cpu_temp
ram
vram
frame_timing
frametime
fps_limit=0

# Appearance
background_alpha=0.5
font_size=20
```

---

## GameMode

Optimizes system settings while games are running.

### Installation

```bash
pacman -S gamemode lib32-gamemode
```

### What It Does

| Optimization | Detail |
|-------------|--------|
| CPU governor | Switches to `performance` |
| Process priority | Raises to higher nice value |
| GPU power state | Sets to high performance |
| IO scheduler | Changes to `deadline` |
| Screensaver | Inhibits screen blanking |

### Usage

```bash
# Wrap game command
gamemoderun ./game

# Steam launch option
gamemoderun %command%

# Verify it works
gamemoded -t
```

### Configuration

Config file: `~/.config/gamemode.ini`

```ini
[general]
renice = 10
softrealtime = auto
inhibit_screensaver = 1

[gpu]
apply_gpu_optimisations = accept-responsibility
gpu_device = 0
```

---

## CurseForge (Minecraft)

### Installation

```bash
yay -S curseforge-bin
pacman -S jre-openjdk   # Java runtime for Minecraft
```

### Configuration

- Set Java path in launcher settings
- Allocate RAM: 4-8GB recommended for modded Minecraft
- JVM args: `-XX:+UseG1GC -XX:+ParallelRefProcEnabled`

---

## Hyprland Gaming Window Rules

Add to `hyprland.conf`:

```conf
# ── Steam ──
windowrulev2 = float, class:^(steam)$, title:^(Friends List)
windowrulev2 = float, class:^(steam)$, title:^(Steam Settings)
windowrulev2 = float, class:^(steam)$, title:^(Game Properties)
windowrulev2 = workspace 9, class:^(steam)$, title:^(Steam)$

# ── Games general ──
# Steam games: fullscreen, no idle, allow tearing (VRR)
windowrulev2 = fullscreen, class:^(gamescope)$
windowrulev2 = idleinhibit always, class:^(steam_app_.*)$
windowrulev2 = immediate, class:^(steam_app_.*)$

# ── Lutris ──
windowrulev2 = float, class:^(lutris)$
windowrulev2 = size 1200 800, class:^(lutris)$

# ── Minecraft ──
windowrulev2 = idleinhibit always, class:^(Minecraft.*)$
windowrulev2 = fullscreen, class:^(Minecraft.*)$, title:^(Minecraft.*)$
```

### Finding Window Classes

```bash
# Watch for new windows
hyprctl clients -j | jq '.[].class'

# Or use hyprctl event monitoring
hyprctl event-listener
```

---

## Performance Tips

### System Tuning

```bash
# Required by many games — increase memory map limit
# /etc/sysctl.d/99-gaming.conf
vm.max_map_count = 1048576

# Apply immediately
sudo sysctl vm.max_map_count=1048576
```

### Environment Variables for Performance

| Variable | Value | Effect |
|----------|-------|--------|
| `AMD_VULKAN_ICD` | `RADV` | Force RADV Vulkan driver |
| `DXVK_ASYNC` | `1` | Async shader compilation |
| `RADV_PERFTEST` | `gpl` | Graphics pipeline library (faster shaders) |
| `mesa_glthread` | `true` | Multi-threaded OpenGL |

### Hyprland Gaming Config

```conf
# Enable variable refresh rate
misc {
    vrr = 1          # 0=off, 1=on, 2=fullscreen only
}

# Disable unnecessary compositor effects during fullscreen
# (Hyprland is already very GPU-efficient, but these help)
decoration {
    blur {
        enabled = true
        # Blur doesn't apply to fullscreen, so no perf impact
    }
}
```

### Game-Specific Tips

- **Shader compilation stutter:** Use `DXVK_ASYNC=1` or wait for shader pre-caching in Steam
- **Input lag:** Disable V-Sync in game, use `vrr = 1` in Hyprland instead
- **Performance monitoring:** Always test with MangoHud to identify bottlenecks
- **Steam Shader Pre-Caching:** Enable in Steam Settings → Shader Pre-Caching
- **Proton compatibility:** Check ProtonDB before troubleshooting — often there's a known fix
