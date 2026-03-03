---
description: 'Conventional Commits format, granular commit strategy, and push discipline for dotfiles safety'
applyTo: '**'
---

# Commit Discipline

## The February 2026 Rule

After the catastrophic drive failure, this is law: **uncommitted work is gone forever.** Commit frequently. Push immediately. No exceptions.

## Conventional Commits Format

Every commit message MUST use a Conventional Commits prefix:

| Prefix | Use When |
|--------|----------|
| `feat:` | New config, new application, new feature, new script |
| `fix:` | Bug fix in configs, scripts, or deployment |
| `docs:` | Documentation changes (README, instruction files, comments) |
| `refactor:` | Restructuring without behavior change |
| `chore:` | Maintenance, cleanup, dependency updates, package lists |

## One Logical Change Per Commit

Never batch unrelated changes. Each commit should represent exactly one logical change:

- Adding a new app config = one commit
- Fixing a script bug = one commit
- Updating package lists = one commit
- Changing a keybinding = one commit

## Always Push Immediately

```bash
git commit -m "type: concise description"
git push
```

No accumulating local commits. Push after every commit.

## Tag Stable States

After a successful full setup or major milestone:

```bash
git tag -a stable-YYYYMMDD -m "Working state: brief description"
git push --tags
```

## Recommended Workflow

```bash
# 1. Check what changed
git status && git diff --stat

# 2. Stage specific files (not git add .)
git add <specific-files>

# 3. Commit with conventional prefix
git commit -m "type: concise description"

# 4. Push immediately
git push
```

## Commit Message Examples

```
feat: add yazi file manager config with Macchiato theme
feat: add nushell config with starship integration
fix: correct waybar workspace icon alignment
fix: resolve stow conflict in kitty theme include
docs: update HYPRLAND.md with new keybindings
docs: add package-tracking instruction file
refactor: simplify wallpaper.sh transition logic
refactor: reorganize tmux custom modules
chore: update pacman.txt with latest package list
chore: remove orphan AUR packages from aur.txt
```

## What NOT to Do

- `git add .` followed by a vague "update stuff" message
- Committing config changes, script changes, and doc changes in one commit
- Leaving work uncommitted overnight
- Forgetting to push after committing
- Using past tense ("added" instead of "add")
