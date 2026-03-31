# YAML Frontmatter Examples

## Agent: Full-Featured Captain (Team Lead)

```yaml
---
name: "Project Captain"
description: "Coordinates feature implementation across planning, coding, and testing"
argument-hint: "Describe the feature or Jira story to implement"
model: "Claude Opus 4.6"
agents:
  - "*"
tools:
  - agent
  - readFile
  - problems
  - codebase
  - fileSearch
  - listDirectory
  - textSearch
  - usages
  - editFiles
  - createFile
  - runInTerminal
  - getTerminalOutput
  - runSubagent
  - askQuestions
  - todos
  - github/*
  - mcp-atlassian/*
  - agent-team/*
handoffs:
  - label: "📋 Plan Feature"
    agent: "Project Planner"
    prompt: "Create implementation plan for: "
    send: false
  - label: "💻 Implement"
    agent: "Project Implementer"
    prompt: "Implement the approved plan"
    send: false
  - label: "🧪 Test"
    agent: "Project Tester"
    prompt: "Test the implementation"
    send: false
---
```

**Key rules:**
- `agent` tool is **required** when both `agents` and `tools` are specified
- Handoff `agent` values use the target's `name` field (display name), not the filename
- Captain's tool list is inherited by subagents spawned via `runSubagent`

## Agent: Hidden Subagent (Specialist)

```yaml
---
name: "Project Implementer"
description: "Writes code changes following architect's design plan"
user-invokable: false
model: "Claude Opus 4.6"
agents: []
tools:
  - readFile
  - problems
  - codebase
  - fileSearch
  - listDirectory
  - textSearch
  - usages
  - editFiles
  - createFile
  - runInTerminal
  - getTerminalOutput
  - agent-team/*
handoffs:
  - label: "🧪 Run Tests"
    agent: "Project Tester"
    prompt: "Test the changes I just made"
    send: false
---
```

## Instructions: Path-Scoped

```yaml
---
applyTo: "**/*.ts"
description: "TypeScript coding standards for strict mode projects"
---
```

## Instructions: Global

```yaml
---
applyTo: "**"
description: "Universal code review standards"
---
```

## Skill: With Resources

```yaml
---
name: deployment-workflow
description: "Step-by-step deployment procedure for AWS EKS across TST, QA, STA, PROD environments. Use when deploying services or troubleshooting deployment issues."
---
```

Skill folder structure:
```
deployment-workflow/
├── SKILL.md                    # Main instructions
├── references/
│   ├── environment-config.md   # Per-env settings
│   └── troubleshooting.md      # Common issues
├── templates/
│   └── helm-values.yaml        # Base Helm template
└── scripts/
    └── health-check.sh         # Post-deploy validation
```

## Model Specification

```yaml
# Single model (recommended for consistency)
model: "Claude Opus 4.6"

# Fallback list (tries in order)
model:
  - "Claude Opus 4.6"
  - "Claude Sonnet 4"
  - "GPT-4.1"
```

## Subagent Control Patterns

```yaml
# Full autonomy — can delegate to any agent
agents:
  - "*"

# Specific agents only (use display names from `name` field)
agents:
  - "Project Implementer"
  - "Project Tester"

# No delegation — leaf agent
agents: []
```

## Handoff Patterns

```yaml
# User reviews before sending (agent values use display names)
handoffs:
  - label: "📋 Plan"
    agent: "Project Planner"
    prompt: "Create a plan for: "
    send: false

# Auto-submit (no user review)
handoffs:
  - label: "🔄 Auto-Review"
    agent: "Code Reviewer"
    prompt: "Review the changes above"
    send: true

# Model override per handoff
handoffs:
  - label: "Quick Fix"
    agent: "Quick Fixer"
    send: false
    model: "Claude Sonnet 4 (copilot)"
```
