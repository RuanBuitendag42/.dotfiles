---
name: stow-patterns
description: "GNU Stow dotfiles management, directory conventions, Makefile targets, and deploy workflow"
---

# GNU Stow Dotfiles Management

Complete reference for the dotfiles repo structure, Stow conventions, Makefile deployment, and best practices.

---

## Dotfiles Repo Structure

```
.dotfiles/                    # Repo root: /home/ruanb/Developer/github/.dotfiles
├── Makefile                  # Deployment automation (SINGLE ENTRYPOINT)
├── README.md
├── setup.sh                  # Initial setup script
├── config/                   # Stow package → ~/.config/
│   ├── btop/
│   ├── Code/
│   ├── dunst/
│   ├── fastfetch/
│   ├── hypr/
│   ├── kitty/
│   ├── nushell/
│   ├── nvim/
│   ├── sddm/
│   ├── starship/
│   ├── swaylock/
│   ├── tmux/
│   ├── waybar/
│   ├── wofi/
│   └── yazi/
├── home/                     # Stow package → ~/
│   ├── .copilot/             # Copilot agents, skills, instructions
│   ├── .gitconfig
│   ├── .ssh/                 # git-crypt encrypted
│   ├── .zshrc
│   └── ...
├── scripts/                  # Stow package → ~/
│   └── .local/
│       └── bin/
│           └── *.sh
└── packages/
    ├── pacman.txt            # Official repo packages
    └── aur.txt               # AUR packages
```

---

## Stow Concepts

### How GNU Stow Works

GNU Stow creates **symlinks** from a target directory to files in a stow package (source directory). The source directory structure mirrors the target.

**Example:** `config/kitty/kitty.conf` stowed to `~/.config/` creates:
```
~/.config/kitty/kitty.conf → /home/ruanb/Developer/github/.dotfiles/config/kitty/kitty.conf
```

### Key Stow Options

| Option | Purpose |
|--------|---------|
| `-t TARGET` | Set target directory (where symlinks are created) |
| `-d SOURCE` | Set stow directory (where packages live) |
| `-R` | Restow — remove then recreate symlinks |
| `--no-folding` | Create file-level symlinks, not directory-level |
| `-n` | Dry run — show what would happen without doing it |
| `-v` | Verbose — show each symlink operation |
| `--adopt` | Import existing files into stow package (use with caution) |

### `--no-folding` Explained

Without `--no-folding`, Stow may create a symlink for an entire directory. This means ALL files in that directory would be managed by stow, including new files created by applications. With `--no-folding`, only individual files are symlinked, keeping the directory real.

---

## Makefile Targets

**⚠️ CRITICAL: ALWAYS use Makefile targets. NEVER run `stow` directly.**

### Deployment Targets

| Target | What It Does |
|--------|-------------|
| `make install` | Deploy everything (configs, home, scripts) |
| `make install-configs` | Deploy `config/` → `~/.config/` |
| `make install-home` | Deploy `home/` → `~/` (.zshrc, .gitconfig, .copilot/) |
| `make install-scripts` | Deploy `scripts/` → `~/` (.local/bin/) |
| `make install-sddm` | Deploy SDDM config (needs sudo) |

### Maintenance Targets

| Target | What It Does |
|--------|-------------|
| `make backup` | Backup existing configs before stowing |
| `make status` | Show current deployment/symlink status |
| `make test` | Test config syntax for supported apps |
| `make clean` | Remove all symlinks created by stow |
| `make stow` | Alias for `make install` |

### Package Targets

| Target | What It Does |
|--------|-------------|
| `make packages-save` | Save installed package lists to `packages/` |
| `make packages-diff` | Show diff between saved and currently installed |
| `make packages-install` | Install packages from saved lists |

---

## The `stow_deploy` Helper

The Makefile uses a `stow_deploy` macro/function that provides safe deployment:

1. **Dry-run first** — runs `stow -n` to detect conflicts before making changes
2. **Auto-backup** — backs up conflicting files to `~/.dotfiles_backup/TIMESTAMP/`
3. **Restow** — uses `-R` and `--no-folding` for clean re-deployment
4. **Error reporting** — shows clear messages if anything fails

This is why you should never run `stow` directly — the Makefile handles conflict resolution and safety checks for you.

---

## Adding New Configs

### Step-by-Step Process

1. **Create the directory structure** mirroring the target location:
   ```bash
   # For an app that stores config in ~/.config/newapp/
   mkdir -p config/newapp/
   ```

2. **Move config files** into the stow package:
   ```bash
   # Move existing config into dotfiles repo
   mv ~/.config/newapp/config.toml config/newapp/config.toml
   ```

3. **Run the appropriate Makefile target:**
   ```bash
   make install-configs
   ```

4. **Verify symlinks:**
   ```bash
   ls -la ~/.config/newapp/
   # Should show: config.toml → /home/ruanb/Developer/github/.dotfiles/config/newapp/config.toml
   ```

### Adding Home Dotfiles

For files that live in `~/` (like `.zshrc`, `.gitconfig`):

```bash
# Move into home/ stow package
mv ~/.newrc home/.newrc
make install-home
ls -la ~/.newrc
```

### Adding Scripts

```bash
# Create script in the correct location
mkdir -p scripts/.local/bin/
cat > scripts/.local/bin/myscript.sh << 'EOF'
#!/usr/bin/env bash
echo "Hello from myscript"
EOF
chmod +x scripts/.local/bin/myscript.sh
make install-scripts
```

---

## Conventions

### Directory Mapping

| Stow Package | Target Directory | Contains |
|-------------|-----------------|----------|
| `config/appname/` | `~/.config/appname/` | Application configs |
| `home/` | `~/` | Dotfiles (.zshrc, .gitconfig, .copilot/) |
| `scripts/.local/bin/` | `~/.local/bin/` | User scripts |

### File Rules

- Configs always go in `config/appname/` — never directly in `config/`
- Home dotfiles go in `home/` with the same relative path as in `~/`
- Scripts go in `scripts/.local/bin/` with executable permissions
- Use `.stow-local-ignore` to exclude files from stowing (like README files within packages)
- git-crypt encrypted files (SSH keys, secrets in `home/.ssh/`) work transparently

### `.stow-local-ignore` Example

Place in a stow package directory to exclude files:

```
# .stow-local-ignore
README.md
LICENSE
\.git
\.gitignore
```

---

## Conflict Resolution

### What Causes Conflicts

A conflict occurs when a real file (not a symlink) exists where Stow wants to create a symlink.

### How the Makefile Handles It

1. Detects conflicts during dry-run
2. Moves conflicting files to `~/.dotfiles_backup/TIMESTAMP/`
3. Proceeds with stowing

### Manual Resolution

```bash
# Check what's there
ls -la ~/.config/appname/config.toml

# If it's a real file, back it up
mv ~/.config/appname/config.toml ~/.config/appname/config.toml.bak

# Re-run stow
make install-configs

# Verify
ls -la ~/.config/appname/config.toml
```

### Checking Symlink Health

```bash
# Verify a symlink points to the right place
readlink -f ~/.config/kitty/kitty.conf
# Should output: /home/ruanb/Developer/github/.dotfiles/config/kitty/kitty.conf

# Find broken symlinks
find ~/.config -xtype l 2>/dev/null
```

---

## Git Workflow

### Daily Workflow

```bash
cd /home/ruanb/Developer/github/.dotfiles

# Check what changed
git status
git diff

# Commit changes
git add -A
git commit -m "kitty: update opacity setting"
git push
```

### Sensitive Files

- git-crypt handles encryption transparently
- `git-crypt status` shows which files are encrypted
- `.gitattributes` controls encryption rules
- GPG key for git-crypt stored in Bitwarden

### `.gitignore`

Keep local-only files out of the repo:

```
*.swp
*.swo
.DS_Store
*.local
```

---

## Troubleshooting

### Common Issues

| Problem | Solution |
|---------|---------|
| "CONFLICT: file already exists" | Backup and remove the existing file, then re-stow |
| "stow: command not found" | `pacman -S stow` |
| Symlink points to wrong place | `make clean && make install` |
| Changes not reflected | Check symlink with `ls -la`, ensure you edited the repo file |
| Permission denied | Check file permissions, use `sudo` only for system configs (SDDM) |
