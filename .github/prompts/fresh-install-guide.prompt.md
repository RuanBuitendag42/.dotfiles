---
description: 'Complete fresh Arch Linux system setup workflow using setup.sh and Makefile'
agent: 'setup-deployer'
---

# Fresh Install Guide

Walk me through a complete fresh Arch Linux system setup using this dotfiles repository.

## Pre-requisites

- Fresh Arch Linux installation with base system + networking
- Git installed (`pacman -S git`)
- User account created with sudo access
- Internet connection active

## Setup Steps

1. **Clone the repo**
   ```bash
   mkdir -p ~/Developer/github
   git clone https://github.com/RuanBuitendag42/.dotfiles ~/Developer/github/.dotfiles
   cd ~/Developer/github/.dotfiles
   ```

2. **Run setup.sh** — This is the automated installer.
   ```bash
   ./setup.sh
   ```
   Available flags:
   - `--minimal` — skip optional packages
   - `--no-aur` — skip AUR packages (yay won't be installed)
   - `--no-hyprland` — skip Hyprland-specific packages and setup

3. **Deploy all configs**
   ```bash
   make install
   ```

4. **Verify deployment**
   ```bash
   make status
   ```

5. **Restore git-crypt secrets** — Retrieve GPG key from Bitwarden, then:
   ```bash
   gpg --import /path/to/key.gpg
   git-crypt unlock
   ```

6. **Set ZSH as default shell**
   ```bash
   chsh -s $(which zsh)
   ```

7. **Reboot into Hyprland** — Select Hyprland session at SDDM login screen.

8. **Post-reboot verification**
   ```bash
   make status
   make test
   ```

9. **Save package snapshot**
   ```bash
   make packages-save
   ```

10. **Tag as stable**
    ```bash
    git tag -a stable-$(date +%Y%m%d) -m "Fresh install — working state"
    git push --tags
    ```

## Post-Install Checklist

- [ ] All symlinks green in `make status`
- [ ] Hyprland launches correctly
- [ ] Waybar shows all modules
- [ ] Kitty terminal themed with Macchiato
- [ ] Neovim opens with Catppuccin Macchiato
- [ ] ZSH with Starship prompt working
- [ ] git-crypt secrets decrypted
- [ ] Package lists saved and committed
