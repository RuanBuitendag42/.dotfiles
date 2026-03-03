---
description: 'Baked-in reference knowledge from the awesome-copilot repository — file types, naming rules, frontmatter schemas, and key URLs'
applyTo: '**'
---

# Genesis Reference — Awesome-Copilot Knowledge Base

This is the baked-in reference for Agent Genesis. It contains critical knowledge from the [awesome-copilot](https://github.com/github/awesome-copilot) repository.

## Seven Resource Types

| Type | Extension/File | Purpose |
|------|---------------|---------|
| **Agent** | `*.agent.md` | Specialized AI personas/modes |
| **Instruction** | `*.instructions.md` | Coding standards that auto-apply by file pattern |
| **Prompt** | `*.prompt.md` | Reusable prompt templates |
| **Skill** | `SKILL.md` (in folder) | Self-contained folders with instructions + bundled assets |
| **Hook** | `hooks.json` (in folder) | Event-driven automations for CCA sessions |
| **Workflow** | `*.md` (standalone) | AI-powered GitHub Actions in markdown |
| **Plugin** | `plugin.json` (in folder) | Installable bundles of agents + skills + commands |

## Critical Naming Rules

- **All filenames**: `lowercase-with-hyphens` (except `SKILL.md`, `README.md`, `AGENTS.md`)
- **Allowed characters**: `.`, `-`, `_`, `a-z`, `A-Z`, `0-9`
- **No spaces** in any filename
- **Skill folder name** MUST match the `name` field in `SKILL.md`
- **Plugin folder name** MUST match the `name` field in `plugin.json`

## Frontmatter Quick Reference

### Agent: `description` (required), `tools`, `model`, `handoffs`
### Instruction: `description` (required), `applyTo` (required)
### Prompt: `description` (recommended), `agent` (recommended)
### Skill: `name` (required, match folder), `description` (required)

## File Placement Quick Reference

| Target | Agents | Instructions | Prompts | MCP |
|--------|--------|-------------|---------|-----|
| Global (user) | `~/.config/Code/User/prompts/` | Same | Same | `~/.config/Code/User/mcp.json` |
| Project | `.github/agents/` | `.github/instructions/` | `.github/prompts/` | `.vscode/mcp.json` |
| Organization | `.github-private/agents/` | Org `.github` repo | — | Agent frontmatter |

## Tool Behavior

- **No `tools` key** = ALL tools enabled
- **`tools: []`** = ALL tools disabled
- **`tools: ['specific']`** = Only listed tools
- **Unrecognized names** silently ignored

## Key URLs

| Resource | URL |
|----------|-----|
| Awesome-Copilot Repo | https://github.com/github/awesome-copilot |
| VS Code Customization Docs | https://code.visualstudio.com/docs/copilot/copilot-customization |
| Agent Skills Spec | https://agentskills.io/specification |
| Awesome-Copilot MCP Server | `ghcr.io/github/awesome-copilot-mcp` (Docker) |

## Awesome-Copilot MCP Server

For live searching of the awesome-copilot repository, use this MCP server (configured in `mcp.json`):
```json
"awesome-copilot": {
  "command": "docker",
  "args": ["run", "-i", "--rm", "ghcr.io/github/awesome-copilot-mcp"]
}
```

## Version Compatibility

| Feature | GitHub.com (CCA) | VS Code |
|---------|:-:|:-:|
| Agents | Yes | Yes |
| Instructions | Yes | Yes |
| `model` property | No | Yes |
| `handoffs` | No | Yes (1.106+) |
| `argument-hint` | No | Yes |
| Agent-level MCP | Yes (org/enterprise) | No |
| Repo-level MCP | Yes | Yes |
