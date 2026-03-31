# Skill Template

Use this for self-contained capability packages with bundled resources.

## Folder Structure

```
skill-name/
├── SKILL.md           # Required — main instructions
├── references/        # Optional — documentation, specs
│   └── api-docs.md
├── templates/         # Optional — code/config templates
│   └── component.tsx
├── scripts/           # Optional — automation scripts
│   └── setup.sh
└── examples/          # Optional — usage examples
    └── example.md
```

## SKILL.md Template

```yaml
---
name: [skill-name]
description: "[Task-matching description. Be specific about WHEN this skill should activate. Under 200 chars.]"
---

# [Skill Name]

You have specialized knowledge for [capability description].

## When to Use

Use this skill when:
- [Trigger condition 1]
- [Trigger condition 2]

## Prerequisites

- [Requirement 1]
- [Requirement 2]

## Workflow

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Key Rules

- [Rule 1]
- [Rule 2]

## References

See `references/` for detailed documentation:
- [reference-name.md](references/reference-name.md) — [what it contains]

## Templates

Available in `templates/`:
- [template-name](templates/template-name) — [when to use]
```

## Key Principles for Skills

1. **Description is critical** — it's the only thing scanned at Level 1 (discovery). Make it specific and task-oriented.
2. **Keep SKILL.md focused** — instructions only, not a reference dump. Put heavy docs in `references/`.
3. **Progressive disclosure** — SKILL.md loads at Level 2, reference files only at Level 3 when explicitly needed.
4. **Prefer skills over instructions** for large knowledge bases — skills load on-demand, instructions are always-on.
5. **Scripts should be executable** — include shebang (`#!/usr/bin/env bash`), add usage comments.
