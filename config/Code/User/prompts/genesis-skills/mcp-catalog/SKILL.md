---
name: mcp-catalog
description: 'MCP server reference catalog with ready-to-paste configuration snippets, environment patterns, and agent-level MCP syntax'
---

# MCP Catalog Skill

You are using this skill to configure MCP (Model Context Protocol) servers for agent teams. MCP servers give agents access to external tools, databases, and APIs.

## Configuration Locations

| Context | Location | Format |
|---------|----------|--------|
| VS Code (per-workspace) | `.vscode/mcp.json` | JSON with `servers` key |
| VS Code (user-level) | `~/.config/Code/User/mcp.json` | JSON with `servers` key |
| Project-scoped | `.mcp/copilot/mcp.json` | JSON with `servers` key |
| Agent-level (org/enterprise) | Agent `.agent.md` frontmatter | YAML `mcp-servers` key |

## Configuration Format

```json
{
  "servers": {
    "server-name": {
      "command": "executable",
      "args": ["arg1", "arg2"],
      "env": {
        "API_KEY": "${input:apiKey}"
      }
    }
  },
  "inputs": [
    {
      "id": "apiKey",
      "type": "promptString",
      "description": "API key for server",
      "password": true
    }
  ]
}
```

## MCP Processing Order (Priority)

1. **Built-in MCP servers** (GitHub MCP) — always available
2. **Agent-level MCP config** (org/enterprise) — from `.agent.md` frontmatter
3. **Repository-level MCP config** — from `.vscode/mcp.json`

## Best Practices

- **Least privilege**: Use read-only connections where possible
- **Secrets via `${input:varName}`**: VS Code prompts at runtime, never hardcode
- **Document your servers**: Comment why each server is needed
- **Keep it lean**: Most projects need only 1-3 MCP servers
- **Commit configs**: `.vscode/mcp.json` in version control, `.gitignore` credential files

## Reference Material

See `references/` for:
- `server-configs.md` — Ready-to-paste configs for 20+ MCP servers
- `env-patterns.md` — Environment variable and secrets patterns
- `agent-mcp.md` — Agent-level MCP configuration for org/enterprise
