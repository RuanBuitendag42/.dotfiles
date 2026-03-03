# Agent Structure

Optimal section ordering and formatting for agent `.agent.md` files.

## Recommended Section Order

```markdown
# Agent Name

[Opening line: "You are a [role]. Your purpose is [objective]."]

## Identity & Expertise
[Who this agent is, domain knowledge, personality]

## Core Responsibilities
[Numbered list of primary tasks, ordered by priority]

## Workflow
[Step-by-step process the agent follows]

## Guidelines
[Rules, quality standards, output format expectations]

## Constraints
[Scope limits, what NOT to do, safety rails]
```

## Section Details

### Opening Line (CRITICAL)
The first sentence defines the agent's entire behavior. Make it count.

**Formula**: "You are a [specific role]. Your purpose is to [specific objective]."

**Good:**
```markdown
You are a security-focused code reviewer. Your purpose is to identify vulnerabilities, injection risks, and authentication flaws in pull requests.
```

**Bad:**
```markdown
You are a helpful assistant. You help with code.
```

### Identity & Expertise
- 2-4 bullet points maximum
- Specific domain knowledge claims
- Personality if applicable
- What makes this agent unique vs others

### Core Responsibilities
- Numbered list (not bullets) — implies priority order
- 3-7 items — fewer is better for focus
- Start each with a verb: "Analyze", "Generate", "Review", "Design"
- Specific enough to be actionable

### Workflow
- Step-by-step numbered process
- Include decision points: "If X, then Y. Otherwise, Z."
- Reference specific tools when relevant
- End state should be clear

### Guidelines
- Bullets, not paragraphs
- Concrete rules, not wishes
- Include output format if relevant
- Reference skills for detailed knowledge

### Constraints
- Explicit "do NOT" statements
- Scope boundaries: "Only review security aspects, not code style"
- Handoff triggers: "If the request requires implementation, hand off to the Developer agent"

## Formatting Rules

### Use Headers
Agents with clear `##` headers perform better — the model can navigate sections.

### Use Bullets Over Paragraphs
```markdown
## Good
- Analyze code for SQL injection
- Check authentication flows
- Review input validation

## Bad
You should analyze the code for SQL injection vulnerabilities. You should also check authentication flows. Additionally, review input validation.
```

### Use Imperative Mood
```markdown
## Good
- Analyze security vulnerabilities
- Generate test cases
- Report findings with severity levels

## Bad
- You should analyze security vulnerabilities
- Please generate test cases
- Try to report findings
```

### Keep Under Size Limits
- Agent body: 500-2,000 characters (ideal)
- Maximum: 5,000 characters (with skills offloading details)
- If exceeding 2,000 chars, consider extracting to a skill
