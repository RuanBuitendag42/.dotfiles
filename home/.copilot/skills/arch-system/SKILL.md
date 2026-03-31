---
name: arch-system
description: "Arch Linux pacman, AUR, systemd, kernel, boot optimization, and system maintenance"
---

# Arch Linux System Administration

Comprehensive reference for managing an Arch Linux system — package management, services, kernel, boot, and maintenance.

---

## Package Management

### Pacman Essentials

| Command | Purpose |
|---------|---------|
| `pacman -S pkg` | Install package |
| `pacman -Syu` | Full system upgrade (**NEVER partial upgrades on Arch!**) |
| `pacman -Rs pkg` | Remove package + unused dependencies |
| `pacman -Rns pkg` | Remove package + deps + config files |
| `pacman -Qs pattern` | Search installed packages |
| `pacman -Ss pattern` | Search remote repos |
| `pacman -Qdt` | List orphan packages |
| `pacman -Rns $(pacman -Qdtq)` | Remove all orphans |
| `pacman -Qe` | List explicitly installed packages |
| `pacman -Ql pkg` | List files owned by package |
| `pacman -Qo /path/to/file` | Find which package owns a file |
| `pacman -Si pkg` | Show remote package info |
| `pacman -Qi pkg` | Show installed package info |
| `pacman -U /path/to/pkg.tar.zst` | Install local package file |

### Pacman Configuration (`/etc/pacman.conf`)

Key options to enable:

```ini
# Misc options
Color
ParallelDownloads = 5
VerbosePkgLists
ILoveCandy          # Fun progress bar (optional)

# Multilib — REQUIRED for 32-bit gaming (Steam, Wine)
[multilib]
Include = /etc/pacman.d/mirrorlist
```

**Package signing:**
- `SigLevel = Required DatabaseOptional` — verify package signatures
- Import keys: `pacman-key --init && pacman-key --populate archlinux`
- Refresh keys: `pacman-key --refresh-keys`

### AUR with yay

| Command | Purpose |
|---------|---------|
| `yay -S pkg` | Install from AUR |
| `yay -Sua` | Update AUR packages only |
| `yay -Ps` | Print yay/system stats |
| `yay --editmenu` | Review PKGBUILD before install |
| `yay -Sc` | Clean build cache |
| `yay -Bi .` | Build and install from local PKGBUILD |
| `yay -G pkg` | Download PKGBUILD without installing |

**Best practices:**
- Always review PKGBUILDs before installing AUR packages
- Use `--editmenu` for first-time AUR installs
- Clean build cache periodically: `yay -Sc`

### Package Tracking in Dotfiles

Package lists are maintained in the dotfiles repo:

- `packages/pacman.txt` — official repo packages
- `packages/aur.txt` — AUR packages

**Makefile targets:**
```bash
make packages-save    # Save current installed packages to lists
make packages-diff    # Show diff between saved and current
```

**Restore from lists:**
```bash
# Official packages
pacman -S --needed $(grep -v '^#' packages/pacman.txt | grep -v '^$')

# AUR packages
yay -S --needed $(grep -v '^#' packages/aur.txt | grep -v '^$')
```

---

## Mirror Management

### reflector

Automatic mirror ranking for fastest downloads:

```bash
# Rank mirrors by speed, filter by country and protocol
reflector --country ZA,DE,NL --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

**Set up a systemd timer for automatic updates:**

```bash
# /etc/xdg/reflector/reflector.conf
--country ZA,DE,NL
--protocol https
--sort rate
--save /etc/pacman.d/mirrorlist
```

```bash
sudo systemctl enable --now reflector.timer
```

---

## Systemd Service Management

### Core Commands

| Command | Purpose |
|---------|---------|
| `systemctl enable service` | Auto-start at boot |
| `systemctl start service` | Start now |
| `systemctl stop service` | Stop now |
| `systemctl restart service` | Restart |
| `systemctl status service` | Show service status |
| `systemctl enable --now service` | Enable and start in one go |
| `systemctl --user enable service` | User-level service |
| `systemctl list-unit-files --state=enabled` | List enabled services |

### Journal / Logging

| Command | Purpose |
|---------|---------|
| `journalctl -u service` | Logs for specific service |
| `journalctl -u service -f` | Follow logs (tail) |
| `journalctl -b` | Current boot logs |
| `journalctl -b -1` | Previous boot logs |
| `journalctl -p err` | Errors only |
| `journalctl -p err -b` | Errors this boot |
| `journalctl --since "1 hour ago"` | Time-filtered logs |
| `journalctl --vacuum-size=500M` | Trim journal to 500MB |

### Timer Units

Create scheduled tasks with timer units instead of cron:

```ini
# /etc/systemd/system/my-task.timer
[Unit]
Description=My scheduled task

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

### Common Services

| Service | Purpose |
|---------|---------|
| `sddm` | Display manager (login screen) |
| `NetworkManager` | Network management |
| `bluetooth` | Bluetooth support |
| `docker` | Container runtime |
| `pipewire` | Audio server |
| `pipewire-pulse` | PulseAudio compatibility |
| `wireplumber` | PipeWire session manager |

---

## Kernel Management

### Kernel Info

```bash
uname -r                    # Current kernel version
uname -a                    # Full kernel info
cat /proc/version           # Kernel version string
```

### Available Kernels

| Package | Purpose |
|---------|---------|
| `linux` | Latest stable kernel |
| `linux-lts` | Long-term support kernel |
| `linux-zen` | Performance-optimized kernel (good for gaming/desktop) |
| `linux-hardened` | Security-focused kernel |

Each kernel needs matching headers: `linux-headers`, `linux-lts-headers`, etc.

### DKMS

Dynamic Kernel Module Support — rebuilds out-of-tree modules on kernel updates:

```bash
pacman -S dkms
dkms status                 # Check module status
```

### Kernel Parameters

Set in bootloader config (systemd-boot or GRUB). Common useful params:
- `quiet` — suppress boot messages
- `splash` — show boot splash
- `amd_pstate=active` — AMD CPU performance scaling
- `amdgpu.ppfeaturemask=0xffffffff` — unlock GPU overclocking

### rebuild-detector

Check if packages need rebuilding after a kernel update:

```bash
pacman -S rebuild-detector
checkrebuild               # Lists packages needing rebuild
```

---

## Boot Optimization

### Analyze Boot Time

```bash
systemd-analyze                      # Total boot time
systemd-analyze blame                # Time per service (slowest first)
systemd-analyze critical-chain       # Dependency chain visualization
systemd-analyze plot > boot.svg      # Graphical boot chart
```

### Reduce Boot Time

1. Disable unneeded services: `systemctl disable service`
2. Use systemd-boot instead of GRUB (faster)
3. Mask unused services: `systemctl mask service`
4. Set timeout to 0 in bootloader config for instant boot

---

## System Health Checks

### Quick Status Commands

| Command | Purpose |
|---------|---------|
| `fastfetch` | System info overview |
| `btop` | Resource monitor (CPU, RAM, disk, network, GPU) |
| `duf` | Disk usage with nice formatting |
| `glances` | Comprehensive system overview |
| `sensors` | Hardware temperatures |

### Maintenance Checks

```bash
# Failed services
systemctl --failed

# Pacnew files (configs that need merging)
find /etc -name "*.pacnew" 2>/dev/null

# Orphan packages
pacman -Qdtq

# Broken symlinks
find /usr -xtype l 2>/dev/null

# Disk space hogs
du -sh /var/cache/pacman/pkg/   # Pacman cache size
```

### Fast File Finding

```bash
# plocate (fast, uses pre-built database)
pacman -S plocate
sudo updatedb                    # Build database
locate filename                  # Find files instantly
```

---

## Arch Linux Best Practices

### Critical Rules

1. **ALWAYS full system upgrades** — `pacman -Syu`, never `pacman -Sy package` (partial upgrades break Arch)
2. **Read the Arch Wiki** before configuring anything — it's the single best Linux resource
3. **Check Arch Linux news** (archlinux.org) before major updates — manual intervention sometimes required
4. **Keep a rescue USB** ready with latest Arch ISO
5. **Snapshot/backup before kernel upgrades** — use timeshift or btrfs snapshots
6. **Handle pacnew files** promptly — use `pacdiff` (from `pacman-contrib`) or `meld` for visual diffs

### Cache Management

```bash
# Keep only last 3 versions of each package
paccache -r

# Remove all cached packages except installed versions
paccache -ruk0

# Set up automatic cache cleaning
sudo systemctl enable --now paccache.timer
```

### Recovery

If system won't boot:
1. Boot from Arch USB
2. Mount root partition: `mount /dev/sdXn /mnt`
3. Chroot: `arch-chroot /mnt`
4. Fix the issue (downgrade package, fix config, etc.)
5. Downgrade: `pacman -U /var/cache/pacman/pkg/package-oldversion.pkg.tar.zst`
