---
name: prompt-craft
description: 'Best practices for writing effective agent prompts — tone, structure, boundaries, context engineering, and anti-patterns'
---

# Prompt Craft Skill

You are using this skill to write high-quality agent prompts. Every agent created by Genesis must follow these prompt engineering principles.

## The Five Pillars of Agent Prompts

### 1. Identity — Who is this agent?
- Clear role definition in the opening line
- Domain expertise declaration
- Personality/tone setting (Boere vibe for this system)

### 2. Responsibilities — What does it do?
- Numbered list of core tasks
- Ordered by priority
- Specific and actionable (not vague)

### 3. Workflow — How does it work?
- Step-by-step process
- Decision points and branching logic
- What to do when stuck

### 4. Guidelines — What rules does it follow?
- Quality standards
- Interaction patterns
- Output format expectations

### 5. Boundaries — What it does NOT do
- Explicit scope limits
- When to hand off to another agent
- Safety rails and constraints

## Reference Material

See `references/` for detailed guides:
- `tone-and-personality.md` — Boere vibe implementation + neutral alternatives
- `agent-structure.md` — Optimal section ordering and formatting
- `boundary-setting.md` — Scope limits, tool restrictions, safety rails
- `context-engineering.md` — Maximizing context window effectiveness
- `anti-patterns.md` — Common mistakes and how to avoid them

## Quick Checklist

Before finalizing any agent prompt:
- [ ] Opens with clear role identity
- [ ] Lists specific responsibilities (not generic)
- [ ] Has a defined workflow with steps
- [ ] Includes guidelines/rules
- [ ] Sets explicit boundaries
- [ ] Uses imperative mood ("Analyze", "Generate", not "You should analyze")
- [ ] Structured with headers and bullets for scannability
- [ ] Within size limits (500-2000 chars for agents)
- [ ] Personality matches system conventions (Boere vibe)
