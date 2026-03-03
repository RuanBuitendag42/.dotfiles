---
description: 'GNU Stow and Makefile deployment conventions — the ONLY way to deploy configs in this repo'
applyTo: 'Makefile, setup.sh, scripts/**'
---

# Stow & Makefile Deployment Rules

## CRITICAL RULE #1

**NEVER run `stow` directly.** Always use Makefile targets.

The Makefile wraps `stow` with the adopt-then-restore pattern and correct flags. Running `stow` manually risks clobbering repo files or creating broken symlinks. This rule is non-negotiable.

## Makefile Target Reference

| Target | What It Deploys |
|--------|----------------|
| `make install` | Everything (configs + home + scripts + SDDM) |
| `make install-configs` | `config/` → `~/.config/` (all apps except sddm) |
| `make install-home` | `home/` → `~/` (.zshrc, .gitconfig, .ssh/, etc.) |
| `make install-scripts` | `scripts/` → `~/.local/bin/` (all .sh scripts) |
| `make install-sddm` | SDDM theme to `/etc/sddm.conf.d/` (sudo, only if changed) |
| `make backup` | Timestamped backup to `~/dotfiles_backup_*/` |
| `make status` | Check all deployed symlinks |
| `make test` | ZSH syntax check + Hyprland live check |
| `make clean` | Remove all deployed symlinks (interactive confirmation) |
| `make update` | `git pull origin main` |
| `make packages-save` | Snapshot installed packages to `packages/` |
| `make packages-diff` | Compare installed vs saved packages |
| `make orphans` | Find and optionally remove orphan packages |

## The Adopt-Then-Restore Pattern

This is WHY direct `stow` usage is forbidden. The Makefile uses a two-step pattern to avoid conflicts when target files already exist:

```bash
# Step 1: Adopt existing files into the repo (overwrites repo files temporarily)
stow -R --adopt --no-folding -v -t ~/.config .

# Step 2: Restore repo versions (undoes the adopt)
git checkout -- config/
```

**How it works:**
1. `--adopt` moves existing target files INTO the repo, replacing repo versions
2. `git checkout --` restores the repo files to their committed state
3. Result: symlinks point to repo files, no conflicts, repo is clean

**Why it's fragile:** If you skip step 2, your repo files get overwritten with whatever was in `~/.config`. The Makefile handles both steps atomically.

## Directory Mappings

| Repo Directory | Deployed To | Method |
|---------------|-------------|--------|
| `config/` | `~/.config/` | stow (via Makefile, excludes sddm) |
| `home/` | `~/` | stow (via Makefile) |
| `scripts/` | `~/.local/bin/` | stow (via Makefile) + `chmod +x` |
| `config/sddm/` | `/etc/sddm.conf.d/` | `sudo cp` (only when diff detected) |

## Standard Deployment Workflow

```bash
# 1. Back up existing configs first
make backup

# 2. Deploy everything
make install

# 3. Verify symlinks are correct
make status

# 4. Run syntax/smoke tests
make test
```

## Adding a New Application Config

```bash
# 1. Create the config directory in repo
mkdir -p config/newapp

# 2. Add config files
cp ~/.config/newapp/config.toml config/newapp/

# 3. Deploy using Makefile (NEVER stow directly)
make install-configs

# 4. Verify
make status
```

## Rules

- Use `--no-folding` always — stow must create individual file symlinks, never directory symlinks
- SDDM config uses `sudo cp` because `/etc/` is root-owned and stow cannot target it
- `chmod +x` is applied automatically to scripts after deployment
- `make clean` prompts for confirmation before removing symlinks
- Always run `make backup` before major changes
