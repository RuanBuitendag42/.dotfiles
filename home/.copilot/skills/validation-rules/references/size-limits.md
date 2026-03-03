# Size Limits

Recommended character/size limits for Copilot file types. Exceeding these may degrade performance or cause truncation.

## Per-File Limits

| File Type | Recommended | Maximum | Notes |
|-----------|:-----------:|:-------:|-------|
| `copilot-instructions.md` | 500–3,000 chars | 8,000 chars | Global project context — keep focused |
| Individual `.agent.md` | 500–2,000 chars | 5,000 chars | Core identity + instructions |
| Individual `.instructions.md` | 300–1,500 chars | 4,000 chars | Domain-specific guidelines |
| Individual `.prompt.md` | 200–1,000 chars | 3,000 chars | Task-specific instructions |
| `SKILL.md` | 1,000–5,000 chars | 8,000 chars | Can be larger due to bundled context |
| `AGENTS.md` (CCA) | 2,000–10,000 chars | 30,000 chars | Cheaper context for CLI/CCA |
| Skill reference docs | 500–3,000 chars | 5,000 chars | Supporting documentation |

## Total Context Budget

| Scope | Budget | Notes |
|-------|:------:|-------|
| Agent total prompt | < 30,000 chars | All instructions + agent spec combined |
| Attached instructions per session | < 15,000 chars | All auto-attached `.instructions.md` files |
| Skills loaded per session | < 20,000 chars | Skills are loaded on demand |

## Counting Characters

Quick estimation:
- **1 line of prose** ≈ 80 characters
- **1 code block** ≈ 200–500 characters
- **1 YAML frontmatter** ≈ 100–300 characters

## What Happens When Limits Are Exceeded

- **Truncation**: Content may be cut off mid-sentence
- **Ignored**: Some content may be silently dropped
- **Degraded performance**: Agent may lose focus or hallucinate
- **Slow responses**: More tokens = slower processing

## Optimization Strategies

1. **Be concise**: "Use TypeScript strict mode" not "Please make sure to always enable and use TypeScript's strict mode setting"
2. **Use bullets over paragraphs**: Easier to scan, less characters
3. **Reference don't repeat**: Point to a file instead of inlining its content
4. **Progressive disclosure**: Use skills for details, keep agent specs lean
5. **Scope narrowly**: Use `applyTo` globs to limit when instructions load
6. **Split large agents**: If an agent spec exceeds 3,000 chars, consider splitting into agent + skill
