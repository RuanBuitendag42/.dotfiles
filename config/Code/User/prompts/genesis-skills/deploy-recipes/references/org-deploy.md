# Organization-Level Deployment

Deploy agents to an entire GitHub organization so all members have access.

## How It Works

Organization-level agents are stored in the org's `.github` (public) or `.github-private` (private) repository.

## Directory Structure

```
org/.github-private/
└── agents/
    ├── org-standards.agent.md
    ├── security-reviewer.agent.md
    └── onboarding-buddy.agent.md
```

Or in the public `.github` repo:
```
org/.github/
└── agents/
    ├── org-standards.agent.md
    └── code-reviewer.agent.md
```

## Deployment Steps

### 1. Create/access the org's `.github-private` repo
```bash
git clone https://github.com/YOUR-ORG/.github-private
cd .github-private
mkdir -p agents
```

### 2. Create agent files
Write `.agent.md` files to the `agents/` directory.

### 3. Add MCP servers (optional, org/enterprise only)
Use the `mcp-servers:` frontmatter property:
```yaml
---
description: 'Organization security reviewer'
mcp-servers:
  org-database:
    type: local
    command: npx
    args: ['-y', '@org/mcp-server']
    tools: ['*']
    env:
      DB_URL: ${{ secrets.ORG_DB_URL }}
---
```

### 4. Commit and push
```bash
git add agents/
git commit -m "feat: add organization Copilot agents"
git push
```

## Priority Resolution

When the same agent name exists at multiple levels:
1. **Repository-level** beats everything (highest priority)
2. **Organization-level** beats enterprise
3. **Enterprise-level** is the fallback (lowest priority)

## When to Use Org-Level

- **Coding standards** that apply across all repos
- **Security review** agents with org-wide policies
- **Onboarding** agents for new team members
- **Shared MCP servers** with organization secrets

## When NOT to Use Org-Level

- Project-specific domain knowledge (use repo-level)
- Personal preference agents (use user-level/global)
- Experimental agents still being tested (use repo-level)
