# Agent-Level MCP Configuration

How to configure MCP servers directly in agent `.agent.md` frontmatter. This is available for **organization and enterprise** level agents only.

## Syntax

```yaml
---
description: 'Agent with custom MCP servers'
tools: ['read/readFile', 'my-server/query', 'my-server/update']
mcp-servers:
  my-server:
    type: local
    command: npx
    args:
      - '-y'
      - '@my-org/mcp-server'
    tools:
      - '*'          # Allow all tools from this server
    env:
      API_KEY: ${{ secrets.MY_API_KEY }}
      API_URL: https://api.example.com
---
```

## Key Differences from `.vscode/mcp.json`

| Feature | `.vscode/mcp.json` | Agent `mcp-servers:` |
|---------|:-------------------:|:--------------------:|
| Scope | Per-workspace or per-user | Per-agent |
| Secrets | `${input:varName}` | `${{ secrets.NAME }}` |
| Availability | VS Code, any workspace | Org/Enterprise agents only |
| Tool filtering | All server tools available | `tools: ['*']` or specific list |
| Server type | `command` or `http` | `type: local` or `type: http` |

## Tool Referencing

When using agent-level MCP, reference tools as `server-name/tool-name`:

```yaml
tools: ['read/readFile', 'my-server/query', 'my-server/list']
```

## Server Types

### Local (Stdio)
```yaml
mcp-servers:
  my-server:
    type: local
    command: npx
    args: ['-y', '@my-org/server']
    tools: ['*']
    env:
      KEY: ${{ secrets.KEY }}
```

### HTTP
```yaml
mcp-servers:
  my-server:
    type: http
    url: https://mcp.example.com/api
    headers:
      Authorization: Bearer ${{ secrets.TOKEN }}
    tools: ['*']
```

## Secrets Management

Agent-level secrets use the GitHub Actions-style syntax:
```yaml
env:
  API_KEY: ${{ secrets.MY_API_KEY }}
```

These secrets are:
- Stored at the organization or enterprise level
- Injected at runtime by the Copilot platform
- Never visible in the agent spec or logs
- Managed by org/enterprise admins

## When to Use Agent-Level MCP

| Scenario | Use |
|----------|-----|
| Team-shared tools | Yes — every user of the agent gets the MCP server |
| Org-wide databases | Yes — centralized config with org secrets |
| Individual developer tools | No — use `.vscode/mcp.json` instead |
| Project-specific tools | No — use `.vscode/mcp.json` or `.mcp/copilot/mcp.json` |
| Quick prototyping | No — repo-level is faster to iterate |

## Limitations

- Only available for organization and enterprise level agents
- Cannot use `${input:}` syntax (use `${{ secrets. }}` instead)
- Server must be accessible from the agent's execution environment
- Tool names must be referenced with `server-name/` prefix
