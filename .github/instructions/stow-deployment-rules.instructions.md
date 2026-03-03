---
description: 'GNU Stow and Makefile deployment conventions — the ONLY way to deploy configs in this repo'
applyTo: 'Makefile, setup.sh, scripts/**'
---

# Stow & Makefile Deployment Rules

## CRITICAL RULE #1

**NEVER run `stow` directly.** Always use Makefile targets.

The Makefile wraps `stow` with the Detect-Backup-Stow pattern and correct flags.
Running `stow` manually risks broken symlinks or skipping conflict resolution.
This rule is non-negotiable.

## CRITICAL RULE #2

**NEVER use `--adopt` in deployment targets.** The `--adopt` flag is a one-time
migration tool for importing existing configs into the repo. It modifies the repo
by pulling target files into it — the opposite of deployment. Using it repeatedly
with `git checkout` to undo the damage is fragile and destroys uncommitted work.

## The Detect-Backup-Stow Pattern

This is the deployment strategy used by all `make install-*` targets:

1. `stow -n` (dry-run) identifies regular files that would block symlink creation
2. Only regular files (not symlinks) are backed up to `~/.dotfiles_backup/<timestamp>/`
3. `stow -R --no-folding` creates symlinks from repo to target. Idempotent.
4. The repo is NEVER modified during deployment

**Why it's superior to adopt-then-checkout:**

| Property | Old (adopt+checkout) | New (detect-backup-stow) |
|----------|---------------------|--------------------------|
| Repo modified during deploy? | Yes | **No** |
| Safe with uncommitted changes? | No | **Yes** |
| Race condition? | Yes | **No** |
| Requires git? | Yes | **No** |
| Backs up replaced files? | No | **Yes** |
| Idempotent? | Destructively | **Safely** |

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

## Directory Mappings

| Repo Directory | Deployed To | Method |
|---------------|-------------|--------|
| `config/` | `~/.config/` | stow (via Makefile, excludes sddm) |
| `home/` | `~/` | stow (via Makefile) |
| `scripts/` | `~/.local/bin/` | stow (via Makefile) + `chmod +x` |
| `config/sddm/` | `/etc/sddm.conf.d/` | `sudo cp` (only when diff detected) |

## Stow Flags Reference

| Flag | Purpose | Used In |
|------|---------|---------|
| `-R` (restow) | Unstow then re-stow — handles renames, idempotent | All install targets |
| `--no-folding` | Create file-level symlinks, never directory symlinks | All install targets |
| `-n` (dry-run) | Detect conflicts without making changes | Conflict detection step |
| `-v` (verbose) | Show what stow is doing | All targets |
| `-D` (delete) | Remove symlinks only | `make clean` |
| `--ignore=REGEX` | Skip files matching pattern | `--ignore='sddm'` in install-configs |
| `--adopt` | **FORBIDDEN in deployment** — one-time migration only | Never in Makefile |

## Standard Deployment Workflow

```bash
# 1. Back up existing configs first (optional safety net)
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

## When --adopt IS Appropriate

Only for **one-time initial import** of existing configs into the repo:

```bash
# ONCE — to suck in existing configs you want to track:
cd config && stow --adopt --no-folding -v -t ~/.config .
git add -A && git commit -m "feat: import existing configs"

# NEVER AGAIN — all future deploys use make install
```

After the initial import, `--adopt` should never appear in any Makefile target
or setup script.

## Conflict Recovery

If something goes sideways, the nuclear option is always safe:

```bash
# Remove ALL config symlinks, then re-stow from scratch
make clean     # stow -D everything (only removes symlinks, not files)
make install   # stow -R everything (no conflicts possible)
```

## Rules Summary

- Use `--no-folding` always — individual file symlinks, never directory symlinks
- Use `-R` (restow) for deployment — idempotent, handles renames
- Use `stow -n` (dry-run) for conflict detection before deploying
- SDDM config uses `sudo cp` because `/etc/` is root-owned
- `chmod +x` is applied automatically to scripts after deployment
- `make clean` prompts for confirmation before removing symlinks
- Always run `make backup` before major changes
- Conflicting files are auto-backed up to `~/.dotfiles_backup/`
- The repo is the source of truth — it is NEVER modified during deployment
