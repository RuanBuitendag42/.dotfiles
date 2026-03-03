---
name: templates-library
description: 'Pre-built and learned team templates for Agent Genesis — ready-to-customize blueprints for common team types'
---

# Genesis Team Templates

Pre-built blueprints for common agent team types. Genesis uses these as starting points and customizes based on the user's specific requirements. Read this skill when checking for matching templates. Update the Learned Templates section after creating a successful custom team.

---

## Template: SDLC Team

**Use when**: Building a full software project with design, implementation, testing, review, and deployment phases.

### Agents
| Agent | Role | Key Tools |
|-------|------|-----------|
| `orchestrator` | Coordinates team, delegates tasks | `agent`, `vscode`, `todo` |
| `architect` | System design, tech decisions | `read`, `search` |
| `developer` | Write production code | `read`, `edit`, `search`, `execute` |
| `tester` | Write and run tests | `read`, `edit`, `execute` |
| `reviewer` | Code quality, standards | `read`, `search` |
| `devops` | CI/CD, deployment, infra | `read`, `edit`, `execute` |
| `doc-writer` | Technical documentation | `read`, `edit`, `search` |

### Handoff Chain
`orchestrator → architect → developer → tester → reviewer → devops → doc-writer`

### Recommended Skills
- Project-specific coding standards (instruction file)
- Testing patterns (instruction file)

---

## Template: API Development Team

**Use when**: Building REST/GraphQL APIs with a focus on design, implementation, and testing.

### Agents
| Agent | Role | Key Tools |
|-------|------|-----------|
| `api-orchestrator` | Coordinates API development | `agent`, `todo` |
| `api-designer` | Endpoint design, schema definition | `read`, `search`, `edit` |
| `api-implementer` | Route handlers, middleware, validation | `read`, `edit`, `execute` |
| `api-tester` | API tests, contract tests, load tests | `read`, `edit`, `execute` |
| `api-doc-writer` | OpenAPI specs, README, examples | `read`, `edit`, `search` |

### Recommended MCP Servers
- Database MCP (Postgres/SQLite) for schema-aware development
- Fetch MCP for testing external API integrations

---

## Template: Frontend Team

**Use when**: Building web frontends with component-based architecture.

### Agents
| Agent | Role | Key Tools |
|-------|------|-----------|
| `ui-orchestrator` | Coordinates frontend work | `agent`, `todo` |
| `ui-architect` | Component hierarchy, state management | `read`, `search` |
| `component-builder` | Build UI components | `read`, `edit`, `search` |
| `ui-tester` | Component tests, E2E tests, visual regression | `read`, `edit`, `execute` |
| `a11y-reviewer` | Accessibility compliance | `read`, `search` |

### Recommended MCP Servers
- Playwright MCP for browser automation testing

---

## Template: Infra/DevOps Team

**Use when**: Managing infrastructure, CI/CD, containers, and deployment pipelines.

### Agents
| Agent | Role | Key Tools |
|-------|------|-----------|
| `infra-orchestrator` | Coordinates infrastructure work | `agent`, `todo` |
| `terraform-engineer` | IaC with Terraform/OpenTofu | `read`, `edit`, `execute` |
| `docker-engineer` | Containerization, Compose, registries | `read`, `edit`, `execute` |
| `ci-engineer` | GitHub Actions, CI/CD pipelines | `read`, `edit`, `search` |
| `monitoring-engineer` | Observability, alerting, logging | `read`, `edit`, `search` |

### Recommended MCP Servers
- Terraform MCP for state management
- Docker MCP for container operations
- Kubernetes MCP for cluster management

---

## Template: Dotfiles/System Team

**Use when**: Managing system configurations, shell scripts, and dotfiles automation.

### Agents
| Agent | Role | Key Tools |
|-------|------|-----------|
| `config-orchestrator` | Coordinates dotfiles work | `agent`, `todo` |
| `config-manager` | Application configs, theme enforcement | `read`, `edit`, `search` |
| `script-builder` | Bash/ZSH scripts, automation | `read`, `edit`, `execute` |
| `package-manager` | Package lists, dependency tracking | `read`, `edit`, `execute` |

### Recommended Skills
- Catppuccin Macchiato theme enforcement (instruction file)
- Stow deployment conventions (instruction file)

---

## Template: Research/Analysis Team

**Use when**: Analyzing codebases, auditing security, reviewing performance, or conducting technical research.

### Agents
| Agent | Role | Key Tools |
|-------|------|-----------|
| `research-orchestrator` | Coordinates analysis work | `agent`, `todo` |
| `codebase-analyst` | Architecture analysis, dependency mapping | `read`, `search` |
| `security-auditor` | Vulnerability scanning, OWASP checks | `read`, `search` |
| `performance-reviewer` | Bottleneck detection, complexity analysis | `read`, `search` |
| `report-writer` | Compile findings into structured reports | `read`, `edit` |

### Recommended MCP Servers
- Fetch MCP for CVE database lookups
- GitHub MCP for dependency analysis

---

## Learned Templates

_This section grows as Genesis creates successful custom teams. Each learned template includes the original request, the generated structure, and performance notes._
