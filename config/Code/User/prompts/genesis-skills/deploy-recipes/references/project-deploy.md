# Project-Level Deployment

Deploy agents directly into a project repository so they're available when working in that project.

## Directory Structure

Create these directories in the target project root:

```
project-root/
├── .github/
│   ├── copilot-instructions.md          # Global project context
│   ├── agents/                          # Agent definitions
│   │   ├── architect.agent.md
│   │   ├── developer.agent.md
│   │   └── reviewer.agent.md
│   ├── instructions/                    # Pattern-specific guidelines
│   │   ├── typescript.instructions.md
│   │   └── testing.instructions.md
│   └── prompts/                         # Reusable prompts
│       ├── generate-tests.prompt.md
│       └── create-component.prompt.md
├── .vscode/
│   └── mcp.json                         # MCP server config
└── skills/                              # (if needed)
    └── my-skill/
        └── SKILL.md
```

## Deployment Steps

### 1. Create directory structure
```bash
cd /path/to/project
mkdir -p .github/agents .github/instructions .github/prompts
```

### 2. Create global instructions (optional but recommended)
```bash
# .github/copilot-instructions.md
cat > .github/copilot-instructions.md << 'EOF'
# Project Context

This is a [project type] built with [tech stack].

## Key Conventions
- [Convention 1]
- [Convention 2]
EOF
```

### 3. Create agent files
Write `.agent.md` files to `.github/agents/`

### 4. Create instruction files
Write `.instructions.md` files to `.github/instructions/`

### 5. Create MCP config (if team needs external tools)
Write `mcp.json` to `.vscode/`

### 6. Commit and push
```bash
git add .github/ .vscode/mcp.json
git commit -m "feat: add Copilot agent team configuration"
git push
```

## Verification

1. Open the project in VS Code
2. Check Copilot Chat agent dropdown — project agents should appear
3. Agents from `.github/agents/` merge with any global agents
4. If names conflict, project-level agents take priority over global ones

## Notes

- Project agents are **shared with the team** via version control
- Anyone who clones the repo gets the same agent setup
- No Makefile/stow needed — files are read directly by VS Code
- `.github/copilot-instructions.md` is auto-attached to EVERY Copilot interaction in the project
- `.github/instructions/*.instructions.md` are auto-attached based on `applyTo` globs
