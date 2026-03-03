# Global Deployment (Stow)

Deploy agents to `~/.config/Code/User/prompts/` via the dotfiles Makefile so they're available in ALL VS Code workspaces.

## How It Works

1. Agent files live in the dotfiles repo at `config/Code/User/prompts/`
2. GNU Stow creates symlinks from this directory to `~/.config/Code/User/prompts/`
3. VS Code reads from `~/.config/Code/User/prompts/` and picks up all agents

## Deployment Steps

### 1. Create files in dotfiles repo
```bash
# Place agent files here:
~/.dotfiles/config/Code/User/prompts/my-agent.agent.md

# Place instruction files here:
~/.dotfiles/config/Code/User/prompts/my-rules.instructions.md

# Place skills here:
~/.dotfiles/config/Code/User/prompts/genesis-skills/my-skill/SKILL.md
```

### 2. Deploy via Makefile
```bash
cd ~/.dotfiles
make install-configs
```

This runs:
```bash
cd config && stow -R --adopt --no-folding --ignore='sddm' -v -t ~/.config .
git checkout -- config/
```

### 3. Verify
```bash
ls ~/.config/Code/User/prompts/*.agent.md
# Should show all your agent files as symlinks
```

## What Gets Deployed

The `config/` directory maps to `~/.config/`:
```
config/Code/User/prompts/genesis.agent.md
  → ~/.config/Code/User/prompts/genesis.agent.md

config/Code/User/prompts/genesis-skills/team-patterns/SKILL.md
  → ~/.config/Code/User/prompts/genesis-skills/team-patterns/SKILL.md

config/Code/User/mcp.json
  → ~/.config/Code/User/mcp.json
```

## Important Notes

- **NEVER run stow directly** — always use `make install-configs`
- The `--adopt` flag means existing files in `~/.config` get adopted into the repo
- The `git checkout -- config/` restores the repo source after adopt
- **`--no-folding`** ensures individual file symlinks (not directory symlinks)
- Run `make install-configs` after adding/removing any files

## Removing Agents

1. Delete the file from `config/Code/User/prompts/`
2. Run `make install-configs` to update symlinks
3. The symlink in `~/.config/Code/User/prompts/` is automatically removed

## Troubleshooting

### Stow Conflict Error
```bash
# If stow complains about existing files:
make backup      # Backup first
rm ~/.config/Code/User/prompts/conflicting-file
make install-configs
```

### Agent Not Appearing in VS Code
1. Check symlink exists: `ls -la ~/.config/Code/User/prompts/`
2. Check frontmatter has `description:` field
3. Restart VS Code / reload window
4. Check filename is `lowercase-with-hyphens.agent.md`
