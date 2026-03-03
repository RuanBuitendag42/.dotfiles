---
name: reference-knowledge
description: 'Copilot customization file types, naming rules, frontmatter schemas, tool sets, MCP patterns, and key URLs from awesome-copilot'
---

# Reference Knowledge — Awesome-Copilot Knowledge Base

This skill contains critical reference knowledge from the [awesome-copilot](https://github.com/github/awesome-copilot) repository. Load this skill when you need to create, validate, or reason about Copilot customization files.

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

## Handoff Object Schema

Each entry in the `handoffs` array MUST have all three properties:

```yaml
handoffs:
  - label: 'Display Label'       # required — shown in UI
    agent: 'target-agent-name'    # required — filename without .agent.md
    prompt: 'What to tell the target agent'  # required — context for the handoff
```

**Missing `prompt` causes a lint error.** Always include a descriptive prompt that tells the target agent what task to perform.

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
- **Unrecognized names** cause lint warnings or errors

### Built-in Tool Sets (use these in `tools` array)

| Tool Set | Purpose |
|----------|---------|
| `'agent'` | Sub-agent invocation (`runSubagent`) — required for orchestrators |
| `'read'` | File reading (`readFile`) |
| `'edit'` | File editing (`createFile`, `replaceStringInFile`, etc.) |
| `'search'` | File search, grep, semantic search |
| `'execute'` | Terminal commands (`runInTerminal`) |
| `'web'` | Web search and fetch |
| `'todo'` | Todo list management |
| `'vscode'` | VS Code commands and UI (askQuestions, etc.) |

### MCP Server Tools

To include tools from MCP servers, use the `servername/*` wildcard pattern:
- `'fetch/*'` — all tools from the `fetch` MCP server
- `'context7/*'` — all tools from the `context7` MCP server
- `'github/*'` — all tools from the `github` MCP server

**NEVER use individual MCP tool names** like `mcp_fetch_fetch` or `mcp_github_search_repositories` in the `tools` array — these cause lint errors. Always use the `servername/*` pattern.

### The `agents` Property

- **`agents: ["*"]`** — this agent can see and invoke ALL other agents in the workspace (required for orchestrators)
- **Without `agents` key** — agent can only invoke agents listed in its `handoffs`
- Use `agents: ["*"]` + `tools: ['agent']` for orchestrator agents that need to delegate to any specialist

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
