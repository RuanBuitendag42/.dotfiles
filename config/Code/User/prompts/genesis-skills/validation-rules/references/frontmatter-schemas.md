# Frontmatter Schemas

Exact required and optional fields for each Copilot file type.

## Agent Files (`*.agent.md`)

```yaml
---
# REQUIRED
description: 'Brief description of the agent'

# RECOMMENDED
tools: ['tool1', 'tool2']    # Omit = all tools; [] = no tools
model: 'GPT-4.1'             # VS Code only, ignored on GitHub.com

# OPTIONAL
name: 'Display Name'          # Defaults to filename without .agent.md
infer: false                   # Default: true. Set false to disable inference
handoffs:                      # VS Code 1.106+ only
  - label: 'Button Text'
    agent: 'target-agent-name'
    prompt: 'Context for next agent'
    send: false                # false = user reviews first
metadata:                      # GitHub.com only
  category: 'testing'
mcp-servers:                   # Organization/Enterprise only
  server-name:
    type: 'local'
    command: 'command'
    args: ['--arg1']
    tools: ['*']
    env:
      API_KEY: ${{ secrets.KEY }}
---
```

### Validation Rules
- `description`: REQUIRED, non-empty string, single quotes
- `tools`: If present, must be a YAML list of strings
- `model`: String, one of known models (GPT-4.1, Claude Sonnet 4, etc.)
- `handoffs`: Array of objects, each with `label` (required), `agent` (required), `prompt` (recommended), `send` (optional boolean)
- `handoffs[].agent`: Must reference an existing `.agent.md` filename (without extension)

## Instruction Files (`*.instructions.md`)

```yaml
---
# REQUIRED
description: 'Brief description of these guidelines'
applyTo: '**/*.ts, **/*.tsx'   # Glob pattern(s)

# NO OTHER FIELDS ALLOWED
---
```

### Validation Rules
- `description`: REQUIRED, non-empty string, single quotes
- `applyTo`: REQUIRED, valid glob pattern(s), comma-separated for multiple

### Common `applyTo` Patterns
| Pattern | Matches |
|---------|---------|
| `**` | All files |
| `**/*.ts` | All TypeScript files |
| `**/*.py` | All Python files |
| `**/*.{ts,tsx,js,jsx}` | All JS/TS files |
| `src/**` | All files under src/ |
| `**/*.test.*` | All test files |
| `Dockerfile, docker-compose.*` | Docker files |

## Prompt Files (`*.prompt.md`)

```yaml
---
# RECOMMENDED
description: 'Brief description of what this prompt does'
agent: 'agent'                  # ask | edit | agent | custom-agent-name

# OPTIONAL
name: 'Display Name'           # Defaults to filename
model: 'GPT-4.1'               # VS Code only
tools: ['tool1', 'tool2']      # Specific tools for this prompt
argument-hint: 'Describe what you want'  # VS Code only, placeholder text
---
```

### Validation Rules
- `description`: Recommended, non-empty string
- `agent`: Recommended, string — one of `ask`, `edit`, `agent`, or a custom agent name
- `argument-hint`: String, VS Code only

## Skill Files (`SKILL.md`)

```yaml
---
# REQUIRED
name: skill-folder-name        # MUST match parent folder name exactly
description: 'Brief description'
---
```

### Validation Rules
- `name`: REQUIRED, must exactly match the parent folder name
- `description`: REQUIRED, non-empty string
- File must be named exactly `SKILL.md` (uppercase)
- Must be inside a folder named with `lowercase-with-hyphens`

## Plugin Files (`plugin.json`)

```json
{
  "name": "REQUIRED: lowercase-with-hyphens",
  "description": "REQUIRED: string",
  "version": "REQUIRED: semver string",
  "keywords": ["OPTIONAL: array of strings"],
  "author": { "name": "OPTIONAL: string" },
  "repository": "OPTIONAL: URL string",
  "license": "OPTIONAL: SPDX identifier",
  "agents": ["OPTIONAL: relative paths to .agent.md files"],
  "commands": ["OPTIONAL: relative paths to command .md files"],
  "skills": ["OPTIONAL: relative paths to skill folders"]
}
```

### Validation Rules
- `name`: REQUIRED, lowercase-with-hyphens, must match folder name
- `description`: REQUIRED, non-empty string
- `version`: REQUIRED, valid semver (e.g., "1.0.0")
- `agents`: If present, paths must point to existing `.agent.md` files
- `skills`: If present, paths must point to existing skill folders with `SKILL.md`
