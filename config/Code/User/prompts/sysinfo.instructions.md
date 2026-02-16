---
description: 'Global system and infrastructure context for Copilot across all projects. Includes dotfiles, conventions, and Proxmox/homelab management.'
applyTo: '**'
---

# Global System Instructions for Copilot

## User & System
- **Owner:** Ruan Buitendag (@RuanBuitendag42)
- **Primary OS:** Arch Linux (pure, not derivative)
- **Shell:** ZSH (default, with zinit + Starship)
- **Editor:** Neovim (LazyVim) and VS Code
- **Terminal:** Kitty (primary, Catppuccin Macchiato theme)
- **Window Manager:** Hyprland (fully themed, Catppuccin Macchiato)
- **Automation:** Makefile and GNU Stow for all config deployment
- **Package Management:** Native (pacman) and AUR (yay), tracked in packages/
- **Scripts:** All automation scripts in scripts/.local/bin/ (deployed via stow)
- **Theme:** Catppuccin Macchiato everywhere (critical aesthetic)

## Dotfiles Repo Conventions
- All configs and scripts are managed in the .dotfiles repo
- Only README.md in root; all other docs in .github/instructions/ (with front matter)
- Use Makefile targets for all automation (see `make help`)
- All configs are idempotent and safe to re-run
- Frequent commits and pushes for backup/recovery

## Secrets Management

- All sensitive files (SSH keys, passwords, secrets) are encrypted in the repo using git-crypt.
- GPG key for git-crypt is stored securely in Bitwarden.
- Only authorized users with the GPG key can decrypt secrets.

## Proxmox & Homelab Management
- Proxmox cluster is used for virtualization and homelab services
- Infrastructure as Code is preferred (e.g., Terraform for Proxmox)
- API access is via Proxmox API tokens (never store secrets in repo)
- All automation for Proxmox/homelab should be in a separate repo (not .dotfiles)
- Use SSH keys for secure access to all nodes
- Document all service endpoints, ports, and management URLs in a secure location (not public repo)

## Copilot Usage
- Always reference this file for global system context
- Use .github/instructions/ for project-specific docs
- For new infra/automation, prefer new repo unless config is user-specific
- Never expose secrets or sensitive info in code or docs

---

This file is the single source of truth for Copilot about your system, dotfiles, and infrastructure conventions.
