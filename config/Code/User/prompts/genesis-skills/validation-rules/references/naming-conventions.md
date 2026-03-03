# Naming Conventions

## Filename Rules

### General Pattern: `lowercase-with-hyphens`

**Allowed characters**: `a-z`, `A-Z`, `0-9`, `.`, `-`, `_`

**Regex for validation**:
```regex
# Agent files
^[a-z][a-z0-9-]*\.agent\.md$

# Instruction files
^[a-z][a-z0-9-]*\.instructions\.md$

# Prompt files
^[a-z][a-z0-9-]*\.prompt\.md$

# Skill files (always uppercase SKILL.md)
^SKILL\.md$

# Plugin config
^plugin\.json$

# Hook config
^hooks\.json$
```

### Examples

**VALID filenames:**
```
react-performance-expert.agent.md
python-django.instructions.md
generate-readme.prompt.md
SKILL.md
plugin.json
hooks.json
```

**INVALID filenames:**
```
React Performance Expert.agent.md  ← spaces, uppercase start
myAgent.agent.md                   ← camelCase
my_agent v2.agent.md               ← spaces
génerate.prompt.md                 ← special characters
skill.md                           ← must be uppercase SKILL.md
```

## Folder Naming

### Skills, Plugins, Hooks Folders
- **Pattern**: `lowercase-with-hyphens`
- **Regex**: `^[a-z][a-z0-9-]*$`

**VALID folder names:**
```
agent-scaffolding/
team-patterns/
mcp-catalog/
my-cool-plugin/
session-logger/
```

**INVALID folder names:**
```
Agent Scaffolding/     ← spaces, uppercase
teamPatterns/          ← camelCase
MCP_Catalog/           ← uppercase, underscore
my plugin/             ← space
```

### Exception: `genesis-skills/`
The parent skills directory uses `lowercase-with-hyphens` convention.

## Special Files

| File | Exact Name | Case |
|------|-----------|------|
| Global instructions | `copilot-instructions.md` | lowercase |
| CCA context | `AGENTS.md` | UPPERCASE |
| Skill definition | `SKILL.md` | UPPERCASE |
| Plugin manifest | `plugin.json` | lowercase |
| Hook manifest | `hooks.json` | lowercase |
| Hook docs | `README.md` | UPPERCASE |

## Name Conflict Resolution

When agents share the same name across scopes:
1. **Repository-level** agent wins (highest priority)
2. **Organization-level** agent (second priority)
3. **Enterprise-level** agent (lowest priority)

Always use unique, descriptive names to avoid conflicts.
