# MCP Agent Team

> MCP server design, implementation, testing, and documentation team.

**Last updated:** 2026-03-31

---

## 1. Team Overview

**MCP** is a global Copilot agent team that owns the **Model Context Protocol server lifecycle** — from architecture design through implementation, testing, and documentation. All servers are built in Python using the FastMCP framework.

### Naming Convention

All agents use the `Team:Role` convention:

| Agent | Role |
|-------|------|
| **MCP:Captain** | Orchestrator — scopes, delegates, reviews |
| **MCP:Architect** | Server architecture and tool design |
| **MCP:Builder** | Python FastMCP implementation |
| **MCP:Tester** | Functional and security testing |
| **MCP:Writer** | Documentation and integration guides |

### Scope

- **Owns:** MCP server architecture, Python FastMCP code, tool definitions, resource patterns, server testing, VS Code MCP configuration
- **Does NOT own:** Application code (DevOps team), system config (Dotfiles team), agent creation (Genesis team)

---

## 2. Team Roster

| Agent | Role | Description | User-Invocable |
|-------|------|-------------|:--------------:|
| **MCP:Captain** | Captain | Leads MCP server design and implementation | Yes |
| **MCP:Architect** | Architect | Designs server architecture, tool definitions, resource patterns | No |
| **MCP:Builder** | Builder | Implements MCP servers in Python using FastMCP | No |
| **MCP:Tester** | Tester | Tests servers for functionality, error handling, edge cases | No |
| **MCP:Writer** | Writer | Generates documentation for servers, tools, and integration | No |

**Entry point:** All interactions go through `@MCP:Captain`.

---

## 3. Architecture Diagram

```mermaid
graph TD
    User([User]) -->|"@MCP:Captain"| MC[MCP:Captain]

    MC -->|"Design server"| MA[MCP:Architect]
    MC -->|"Implement"| MB[MCP:Builder]
    MC -->|"Test"| MT[MCP:Tester]
    MC -->|"Document"| MW[MCP:Writer]

    MA -.->|"Architecture spec"| MC
    MB -.->|"Working server"| MC
    MT -.->|"Test report"| MC
    MW -.->|"README, docs"| MC

    MC -.->|"Agent design help"| GC[Genesis:Captain]

    style MC fill:#f5a623,stroke:#333,stroke-width:2px,color:#000
    style MA fill:#7ed6df,stroke:#333
    style MB fill:#e056fd,stroke:#333
    style MT fill:#6ab04c,stroke:#333
    style MW fill:#f9ca24,stroke:#333
    style GC fill:#ccc,stroke:#333,stroke-dasharray:5 5
```

---

## 4. Delegation Flow

Captain is an **orchestrator, not an implementer**. Delegates all work to specialists.

### Routing Logic

```
User request arrives at MCP:Captain
  │
  ├── New MCP server?       → Architect → Builder → Tester → Writer
  ├── Design only?          → Architect
  ├── Implement spec?       → Builder
  ├── Test existing?        → Tester
  ├── Document existing?    → Writer
  ├── Review code?          → Architect (design) + Tester (quality)
  └── Agent design help?    → Handoff to Genesis:Captain
```

### Build Pipeline

```mermaid
sequenceDiagram
    participant User
    participant Cap as MCP:Captain
    participant Arch as MCP:Architect
    participant Build as MCP:Builder
    participant Test as MCP:Tester
    participant Write as MCP:Writer

    User->>Cap: Build MCP server for X
    Cap->>User: Clarifying questions
    User->>Cap: Requirements confirmed
    Cap->>Arch: Design architecture
    Arch->>Cap: Architecture spec
    Cap->>User: Review design?
    User->>Cap: Approved
    Cap->>Build: Implement spec
    Build->>Cap: Code complete
    Cap->>Test: Test server
    Test->>Cap: Test report
    Cap->>Write: Document server
    Write->>Cap: Docs complete
    Cap->>User: Delivered with VS Code config
```

---

## 5. Cross-Team Handoffs

| From | To | When |
|------|----|------|
| MCP:Captain | Genesis:Captain | Need help with agent design or customization |

---

## 6. File Locations

| Artifact | Path |
|----------|------|
| Agent files | `home/.copilot/agents/mcp-*.agent.md` |
| This doc | `home/.copilot/agents/MCP-TEAM.md` |
| Deploy target | `~/.copilot/agents/` (via GNU Stow) |
