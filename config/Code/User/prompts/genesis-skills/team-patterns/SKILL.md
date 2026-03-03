---
name: team-patterns
description: 'Multi-agent team architecture patterns including orchestration, handoffs, DAG planning, and proven team compositions'
---

# Team Patterns Skill

You are using this skill to design multi-agent team architectures. Reference these proven patterns when creating team blueprints.

## Core Concepts

### Agent Orchestration
An **orchestrator agent** delegates work to specialized **sub-agents** via `agent/runSubagent`. The orchestrator:
- Receives the user's request
- Breaks it into work units
- Delegates each work unit to the appropriate sub-agent
- Collects results and composes the final output

### Sub-Agent Invocation Pattern
When invoking a sub-agent, use this wrapper prompt structure:

```
This phase must be performed as the agent "<AGENT_NAME>" defined in "<AGENT_SPEC_PATH>".

IMPORTANT:
- Read and apply the entire .agent.md spec.
- Work on "<WORK_UNIT_NAME>" with base path: "<BASE_PATH>".
- Return a clear summary (actions taken + files produced + issues encountered).
```

### Key Principles
1. **Pass paths and identifiers**, not file contents — sub-agents read their own context
2. **Each sub-agent reads its own `.agent.md` spec** for instructions
3. **Sequential execution** when dependencies exist between steps
4. **Parallel execution** when steps are independent
5. **Conditional execution** — skip steps when trigger conditions are false

## Reference Material

See `references/` for detailed patterns:
- `orchestration-patterns.md` — DAG, sequential, parallel, and conditional execution
- `handoff-patterns.md` — Handoff chain design for VS Code 1.106+
- `sdlc-team.md` — Full SDLC team composition reference
- `review-pipeline.md` — Code review orchestrator pattern
- `tool-scoping.md` — How to assign tools per agent role
