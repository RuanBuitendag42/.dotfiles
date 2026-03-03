# Handoff Patterns

Handoffs enable **guided sequential workflows** between agents in VS Code 1.106+. They appear as buttons in the chat interface.

## Frontmatter Syntax

```yaml
handoffs:
  - label: 'Start Implementation'       # Button text (action-oriented)
    agent: 'implementation'              # Target agent name (filename without .agent.md)
    prompt: 'Implement the architecture plan created above.'
    send: false                          # false = user reviews prompt before sending
  - label: 'Run Tests'
    agent: 'tester'
    prompt: 'Run the full test suite against the implementation.'
    send: true                           # true = auto-sends immediately
```

## Design Principles

### Label Guidelines
- **Action-oriented**: "Start Implementation" not "Next"
- **Specific**: "Review Security" not "Review"
- **2-4 words**: Keep concise for button display
- **Imperative mood**: "Generate Tests", "Deploy Changes", "Validate Output"

### Prompt Context
- Reference completed work: "Based on the architecture plan above..."
- Be specific about expectations: "Generate unit tests for all public methods..."
- Include relevant file paths or identifiers when possible

### Quantity
- **2-3 handoffs maximum** per agent — too many creates decision paralysis
- Order by most common/important workflow next step
- Non-existent target agents are silently ignored

## Common Handoff Chains

### Plan → Implement → Test → Review
```
Planner ─[Start Implementation]→ Implementer ─[Run Tests]→ Tester ─[Review Code]→ Reviewer
```

### Research → Design → Build
```
Researcher ─[Design Architecture]→ Architect ─[Start Building]→ Builder
```

### Write → Validate → Deploy
```
Writer ─[Validate Output]→ Validator ─[Deploy Changes]→ Deployer
```

## Compatibility

| Feature | GitHub.com (CCA) | VS Code |
|---------|:-:|:-:|
| `handoffs` | No | Yes (1.106+) |
| `send: true` | No | Yes |
| `send: false` | No | Yes |

**Note**: Handoffs are VS Code only. For CCA/GitHub.com, the orchestrator pattern with `runSubagent` achieves similar flows programmatically.

## Anti-Patterns

- **Circular handoffs**: A → B → A creates infinite loops — avoid
- **Too many handoffs**: More than 3 creates choice overload
- **Vague labels**: "Continue" or "Next Step" — not descriptive enough
- **Missing context in prompt**: Target agent doesn't know what happened before
- **`send: true` for destructive actions**: Always use `send: false` for deploys, deletes, commits
