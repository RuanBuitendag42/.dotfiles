#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  侍  REMOVE-EOS.SH  ·  EndeavourOS → Pure Arch Migration
#  Safely removes all EndeavourOS packages, switches dracut to
#  mkinitcpio, and cleans up the EOS repo from pacman.conf
# ═══════════════════════════════════════════════════════════════
# Usage: remove-eos.sh          # interactive migration
#        remove-eos.sh --check  # dry-run, show what would change
#
# IMPORTANT: This script modifies your boot system (dracut → mkinitcpio).
# Make sure you have a backup or live USB available just in case.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

step()  { echo -e "\n${BLUE}━━━ ${BOLD}$1${NC}"; }
ok()    { echo -e "  ${GREEN}✓${NC} $1"; }
warn()  { echo -e "  ${YELLOW}!${NC} $1"; }
err()   { echo -e "  ${RED}✗${NC} $1"; }
info()  { echo -e "  ${DIM}·${NC} $1"; }

DRY_RUN=false
[[ "$1" == "--check" ]] && DRY_RUN=true

echo -e "${BOLD}"
echo "  ┌──────────────────────────────────────────────┐"
echo "  │    EndeavourOS → Pure Arch Linux Migration    │"
echo "  │              未来侍 · Pure Arch               │"
echo "  └──────────────────────────────────────────────┘"
echo -e "${NC}"

if $DRY_RUN; then
	echo -e "  ${YELLOW}DRY RUN MODE — no changes will be made${NC}"
	echo ""
fi

# ─── 1. Detect EOS packages ──────────────────────────────────
step "Detecting EndeavourOS packages"

EOS_PKGS=$(pacman -Qq 2>/dev/null | grep -E "^(endeavouros|eos-|welcome|reflector-simple)" | sort)
EOS_COUNT=$(echo "$EOS_PKGS" | grep -c . || true)

if [ "$EOS_COUNT" -eq 0 ]; then
	ok "No EndeavourOS packages found — already pure Arch!"
	exit 0
fi

echo "$EOS_PKGS" | while read -r pkg; do
	desc=$(pacman -Qi "$pkg" 2>/dev/null | grep "^Description" | sed 's/Description     : //')
	info "$pkg — $desc"
done
echo ""
warn "$EOS_COUNT EndeavourOS packages detected"

# ─── 2. Check dracut vs mkinitcpio ───────────────────────────
step "Checking initramfs system"

HAS_DRACUT=false
HAS_MKINITCPIO=false
pacman -Qq dracut &>/dev/null && HAS_DRACUT=true
pacman -Qq mkinitcpio &>/dev/null && HAS_MKINITCPIO=true

if $HAS_DRACUT; then
	warn "dracut is installed (EndeavourOS default)"
	info "Will switch to mkinitcpio (standard Arch initramfs)"
fi

if $HAS_MKINITCPIO; then
	ok "mkinitcpio is already installed"
else
	info "mkinitcpio will be installed"
fi

# ─── 3. Check EOS repo in pacman.conf ────────────────────────
step "Checking pacman.conf"

if grep -q "\[endeavouros\]" /etc/pacman.conf 2>/dev/null; then
	warn "EndeavourOS repo found in /etc/pacman.conf"
	grep -n -A2 "\[endeavouros\]" /etc/pacman.conf | while read -r line; do
		info "  $line"
	done
else
	ok "No EndeavourOS repo in pacman.conf"
fi

# ─── Dry run stops here ──────────────────────────────────────
if $DRY_RUN; then
	echo ""
	step "Summary (dry run)"
	info "Would remove $EOS_COUNT EOS packages"
	$HAS_DRACUT && info "Would switch dracut → mkinitcpio"
	info "Would remove [endeavouros] repo from /etc/pacman.conf"
	info "Would remove /etc/pacman.d/endeavouros-mirrorlist"
	info "Would remove EOS SDDM theme config"
	info "Would restore /etc/os-release and /etc/lsb-release to Arch Linux"
	echo ""
	echo -e "  Run ${BOLD}remove-eos.sh${NC} (without --check) to apply changes."
	exit 0
fi

# ─── Confirmation ────────────────────────────────────────────
echo ""
echo -e "${YELLOW}${BOLD}  ⚠  This will modify your boot system and remove EOS packages.${NC}"
echo -e "${YELLOW}     Make sure you have a live USB or backup available.${NC}"
echo ""
read -p "  Continue with migration? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo "  Aborted."
	exit 1
fi

# ─── 4. Install mkinitcpio if needed ─────────────────────────
step "Setting up mkinitcpio"

if ! $HAS_MKINITCPIO; then
	info "Installing mkinitcpio..."
	sudo pacman -S --noconfirm mkinitcpio
	ok "mkinitcpio installed"
else
	ok "mkinitcpio already installed"
fi

# ─── 5. Remove EOS packages ──────────────────────────────────
step "Removing EndeavourOS packages"

# Remove in dependency order (leaves first, then dependants)
# reflector-simple depends on eos-bash-shared
# welcome depends on eos-bash-shared, eos-translations, eos-qogir-icons
# eos-apps-info, eos-log-tool, eos-rankmirrors depend on eos-bash-shared
# eos-bash-shared depends on eos-translations, eos-update, eos-reboot-recommended, endeavouros-branding

info "Removing packages (respecting dependency order)..."
if sudo pacman -Rns --noconfirm $EOS_PKGS 2>/dev/null; then
	ok "All EndeavourOS packages removed"
else
	warn "Some packages may have had issues, trying cascade removal..."
	sudo pacman -Rdd --noconfirm $EOS_PKGS 2>/dev/null || true
	ok "Packages removed (cascade)"
fi

# ─── 6. Remove dracut (if present) ───────────────────────────
if $HAS_DRACUT; then
	step "Switching from dracut to mkinitcpio"

	# Remove eos-dracut first (already gone from step 5), then dracut itself
	if pacman -Qq dracut &>/dev/null; then
		info "Removing dracut..."
		sudo pacman -Rns --noconfirm dracut 2>/dev/null || sudo pacman -Rdd --noconfirm dracut 2>/dev/null || true
		ok "dracut removed"
	fi

	# Clean up dracut config
	if [ -d /etc/dracut.conf.d ]; then
		info "Removing /etc/dracut.conf.d/"
		sudo rm -rf /etc/dracut.conf.d/
		ok "dracut config cleaned"
	fi

	# Regenerate initramfs with mkinitcpio
	info "Regenerating initramfs with mkinitcpio..."
	sudo mkinitcpio -P
	ok "Initramfs regenerated with mkinitcpio"
fi

# ─── 7. Clean pacman.conf ────────────────────────────────────
step "Cleaning pacman.conf"

if grep -q "\[endeavouros\]" /etc/pacman.conf 2>/dev/null; then
	info "Removing [endeavouros] repo block..."
	sudo sed -i '/^\[endeavouros\]/,/^$/d' /etc/pacman.conf
	ok "EndeavourOS repo removed from pacman.conf"
fi

# Remove mirrorlist
if [ -f /etc/pacman.d/endeavouros-mirrorlist ]; then
	info "Removing endeavouros-mirrorlist..."
	sudo rm -f /etc/pacman.d/endeavouros-mirrorlist
	ok "EOS mirrorlist removed"
fi

# Remove keyring remnants
if [ -d /usr/share/pacman/keyrings/endeavouros* ] 2>/dev/null; then
	info "Cleaning EOS keyring..."
	sudo rm -rf /usr/share/pacman/keyrings/endeavouros*
	ok "EOS keyring cleaned"
fi

# ─── 8. Fix SDDM theme ──────────────────────────────────────
step "Fixing SDDM theme"

if [ -f /etc/sddm.conf.d/10-endeavouros.conf ]; then
	info "Removing EOS SDDM config (10-endeavouros.conf)..."
	sudo rm -f /etc/sddm.conf.d/10-endeavouros.conf
	ok "EOS SDDM theme config removed"
fi

# Ensure catppuccin-macchiato is set as SDDM theme
if pacman -Qq catppuccin-sddm-theme-macchiato &>/dev/null; then
	ok "Catppuccin Macchiato SDDM theme is installed"
else
	warn "catppuccin-sddm-theme-macchiato not installed — SDDM may use default theme"
	info "Install with: yay -S catppuccin-sddm-theme-macchiato"
fi

# ─── 9. Fix os-release / lsb-release ────────────────────────
step "Restoring Arch Linux identity"

if grep -q "EndeavourOS" /etc/os-release 2>/dev/null; then
	info "Resetting /etc/os-release to Arch Linux..."
	sudo tee /etc/os-release > /dev/null << 'OSRELEASE'
NAME="Arch Linux"
PRETTY_NAME="Arch Linux"
ID=arch
BUILD_ID=rolling
ANSI_COLOR="38;2;23;147;209"
HOME_URL="https://archlinux.org/"
DOCUMENTATION_URL="https://wiki.archlinux.org/"
SUPPORT_URL="https://bbs.archlinux.org/"
BUG_REPORT_URL="https://gitlab.archlinux.org/groups/archlinux/-/issues"
PRIVACY_POLICY_URL="https://terms.archlinux.org/docs/privacy-policy/"
LOGO=archlinux-logo
OSRELEASE
	ok "os-release restored to Arch Linux"
else
	ok "os-release already shows Arch Linux"
fi

if grep -q "EndeavourOS" /etc/lsb-release 2>/dev/null; then
	info "Resetting /etc/lsb-release to Arch Linux..."
	sudo tee /etc/lsb-release > /dev/null << 'LSBRELEASE'
LSB_VERSION=1.4
DISTRIB_ID=Arch
DISTRIB_RELEASE=rolling
DISTRIB_DESCRIPTION="Arch Linux"
LSBRELEASE
	ok "lsb-release restored to Arch Linux"
else
	ok "lsb-release already shows Arch Linux"
fi

# ─── 10. Refresh package database ────────────────────────────
step "Refreshing package database"

sudo pacman -Sy
ok "Package database refreshed"

# ─── 11. Rebuild GRUB ────────────────────────────────────────
step "Rebuilding GRUB config"

if command -v grub-mkconfig &>/dev/null; then
	sudo grub-mkconfig -o /boot/grub/grub.cfg
	ok "GRUB config regenerated"
else
	warn "grub-mkconfig not found — update your bootloader manually"
fi

# ─── Done ─────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}  ┌──────────────────────────────────────────────┐${NC}"
echo -e "${GREEN}${BOLD}  │     Migration complete! Pure Arch Linux 侍    │${NC}"
echo -e "${GREEN}${BOLD}  └──────────────────────────────────────────────┘${NC}"
echo ""
info "Removed $EOS_COUNT EndeavourOS packages"
$HAS_DRACUT && info "Switched dracut → mkinitcpio"
info "Cleaned pacman.conf and EOS mirrorlist"
echo ""
warn "Recommended: Reboot to verify everything works"
echo -e "  ${DIM}If boot fails, use a live USB and run:${NC}"
echo -e "  ${DIM}  arch-chroot /mnt${NC}"
echo -e "  ${DIM}  mkinitcpio -P${NC}"
echo -e "  ${DIM}  grub-mkconfig -o /boot/grub/grub.cfg${NC}"
echo ""
