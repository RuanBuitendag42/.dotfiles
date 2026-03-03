# SDLC Team Reference

Full Software Development Lifecycle team composition based on proven patterns from awesome-copilot's `gem-team` and `software-engineering-team` plugins.

## Standard SDLC Team (7 Agents)

### 1. Orchestrator
- **Role**: Project coordinator, delegates work, aggregates results
- **Tools**: `agent/runSubagent`, `read/readFile`, `search/codebase`, `vscode/askQuestions`, `todo`
- **Responsibilities**: Break down requests, assign to specialists, track progress, compose final output

### 2. Architect
- **Role**: System design, technical decisions, architecture patterns
- **Tools**: `read/readFile`, `search/codebase`, `search/textSearch`, `search/fileSearch`
- **Responsibilities**: Design system architecture, define interfaces, choose patterns, review technical decisions

### 3. Developer / Implementer
- **Role**: Write production code
- **Tools**: `read/readFile`, `edit/editFiles`, `edit/createFile`, `edit/createDirectory`, `search/codebase`, `execute/runInTerminal`, `search/textSearch`
- **Responsibilities**: Implement features, write clean code, follow conventions, handle edge cases

### 4. Tester
- **Role**: Write and run tests
- **Tools**: `read/readFile`, `edit/editFiles`, `edit/createFile`, `execute/runTests`, `execute/testFailure`, `execute/runInTerminal`, `search/codebase`
- **Responsibilities**: Unit tests, integration tests, E2E tests, edge case coverage, test documentation

### 5. Reviewer
- **Role**: Code quality, standards enforcement
- **Tools**: `read/readFile`, `search/codebase`, `search/textSearch`, `read/problems`, `search/changes`
- **Responsibilities**: Code review, style enforcement, bug detection, performance review, security review

### 6. DevOps
- **Role**: CI/CD, deployment, infrastructure
- **Tools**: `read/readFile`, `edit/editFiles`, `edit/createFile`, `execute/runInTerminal`, `search/fileSearch`
- **Responsibilities**: CI/CD pipelines, Docker configs, deployment scripts, monitoring setup

### 7. Documentation Writer
- **Role**: Technical documentation
- **Tools**: `read/readFile`, `edit/editFiles`, `edit/createFile`, `search/codebase`, `search/textSearch`
- **Responsibilities**: README, API docs, architecture docs, setup guides, inline documentation

## Lean SDLC Team (4 Agents)

For smaller projects, combine roles:

### 1. Orchestrator (same as above)
### 2. Builder (Architect + Developer combined)
### 3. Quality (Tester + Reviewer combined)
### 4. Ops & Docs (DevOps + Documentation combined)

## Extended SDLC Team (10+ Agents)

For enterprise projects, add specialists:

- **Security Auditor** — OWASP, dependency scanning, secrets detection
- **Performance Engineer** — Profiling, optimization, benchmarking
- **UX/Accessibility** — A11y compliance, UX patterns
- **Database Specialist** — Schema design, query optimization, migrations
- **API Designer** — REST/GraphQL design, versioning, documentation

## Handoff Flow (Standard Team)

```
Orchestrator
  ├─[Design Architecture]→ Architect
  │   └─[Start Implementation]→ Developer
  │       └─[Write Tests]→ Tester
  │           └─[Review Code]→ Reviewer
  │               └─[Setup CI/CD]→ DevOps
  │                   └─[Write Docs]→ Documentation Writer
  └─ (Orchestrator aggregates all outputs)
```
