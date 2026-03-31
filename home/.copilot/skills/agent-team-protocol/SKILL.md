---
name: agent-team-protocol
description: "MCP agent-team server communication protocol for multi-agent coordination. Use when implementing agent registration, messaging, task management, or context sharing between agents."
---

# Agent Team Communication Protocol

You have authoritative knowledge of the `agent-team` MCP server protocol for multi-agent coordination in VS Code Copilot.

## Overview

The `agent-team/*` MCP tools enable agents to register, communicate, assign tasks, and share context. Every agent in a team should follow this protocol.

## Startup Sequence (ALWAYS DO THIS)

Every agent must execute these 3 steps on session start:

```
1. register_agent(name="<agent-name>", team="<team>", role="orchestrator|specialist")
2. read_messages(agent_name="<agent-name>")
3. get_tasks(agent_name="<agent-name>", role="assigned")
```

## Task Assignment

Orchestrators assign work to specialists:

```
create_task(
  title="Brief task title",
  description="Detailed requirements with acceptance criteria",
  created_by="<orchestrator-name>",
  assigned_to="<specialist-name>",
  priority="normal|high|critical"
)
```

## Task Completion

Specialists report when done:

```
update_task(
  task_id="<task_id>",
  agent_name="<agent-name>",
  status="completed",
  progress_note="Summary of what was accomplished",
  result={"artifacts": ["file1.md", "file2.md"]}
)
```

## Checking Progress

```
get_tasks(agent_name="<name>", role="created")    # Tasks you assigned
get_tasks(agent_name="<name>", role="assigned")    # Tasks assigned to you
read_messages(agent_name="<name>")                  # Messages from other agents
```

## Requesting Help

```
send_message(
  from_agent="<your-name>",
  to_agent="<target-agent>",
  content="Description of what you need"
)
```

## Sharing Context

Store data for other agents to access:

```
set_context(key="relevant_key", value={"data": "here"}, scope="task:<task_id>")
get_context(key="relevant_key")
```

## Registered Teams

| Team | Orchestrator | Specialists |
|------|-------------|-------------|
| **genesis** | genesis-captain | genesis-researcher, genesis-foundry, genesis-maintainer, genesis-tester, genesis-docs |
| **mcp** | mcp-architect | mcp-implementer, mcp-tester, mcp-docs |
| **dotfiles** | dotfiles-captain | shell-craftsman, config-curator, script-smith, setup-sage |
| **[generated]** | {project}-{layer}-captain | {project}-{layer}-{role} |

## When to Use Which Communication Pattern

| Scenario | Action | Why |
|----------|--------|-----|
| Delegating complex work | `create_task` | Tracks progress, auto-notifies on completion |
| Need specialist expertise | `runSubagent` + `create_task` | Isolated context + tracked work |
| Checking on delegated work | `get_tasks(role="created")` | See status without switching agents |
| Multi-step workflow | Use task threads | All updates tracked in one conversation |
| Sharing data across agents | `set_context` | Avoid re-explaining project state |
| Quick question to another agent | `send_message` | Lightweight, no task overhead |

## Best Practices

1. **Always register on startup** — other agents need to know you're active
2. **Check messages before starting work** — you may have pending requests
3. **Update tasks promptly** — orchestrators track progress via task status
4. **Use `set_context` for large data** — don't repeat in every message
5. **Include `result` on completion** — structured data helps orchestrators process outcomes
