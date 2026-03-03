---
name: deploy-recipes
description: 'Deployment procedures for global (stow), project (.github/), and org-level Copilot configurations with verification scripts'
---

# Deploy Recipes Skill

You are using this skill to deploy Copilot agent teams to the correct locations. There are three deployment targets, each with different procedures.

## Deployment Targets

### 1. Global (User-Level) — Available in All Workspaces
- **Location**: `~/.config/Code/User/prompts/`
- **Method**: GNU Stow via dotfiles Makefile
- **Source**: `config/Code/User/prompts/` in dotfiles repo
- **Best for**: Personal agents, Genesis itself, cross-project tools

### 2. Project-Level — Available in One Repository
- **Location**: `.github/agents/`, `.github/prompts/`, `.github/instructions/`, `skills/`
- **Method**: Direct file creation in the target project repo
- **Best for**: Project-specific teams, domain-specific agents

### 3. Organization-Level — Available to Org Members
- **Location**: `.github-private/agents/` in org's `.github` repo
- **Method**: Git push to organization's `.github` repository
- **Best for**: Shared team standards, org-wide agents

## Decision Matrix

| Question | Global | Project | Org |
|----------|:------:|:-------:|:---:|
| Used across multiple projects? | Yes | No | Yes |
| Shared with team members? | No | If in repo | Yes |
| Needs project-specific context? | No | Yes | Partial |
| Includes MCP servers? | User mcp.json | .vscode/mcp.json | Agent frontmatter |
| Personal preference agent? | Yes | No | No |

## Procedures

See `references/` for step-by-step deployment:
- `global-deploy.md` — Stow-based deployment to ~/.config/Code/User/prompts/
- `project-deploy.md` — .github/ directory structure for project repos
- `org-deploy.md` — Organization .github-private/ deployment
- `makefile-targets.md` — Adding management targets to the dotfiles Makefile

## Verification

After any deployment, run the verification script:
```bash
./genesis-skills/deploy-recipes/scripts/validate-deploy.sh [target-path]
```

Or manually verify:
1. Open VS Code
2. Open the Copilot Chat panel
3. Check the agent dropdown — deployed agents should appear
4. Select an agent and verify it responds with its identity
