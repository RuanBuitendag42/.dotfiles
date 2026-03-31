# Basic Agent Template

Use this for single-purpose agents that don't coordinate others.

```yaml
---
name: "[Agent Name]"
description: "[Brief description under 100 chars — specific and action-oriented]"
argument-hint: "[What should user type?]"
model: "Claude Opus 4.6"
tools:
  - readFile
  - problems
  - codebase
  - fileSearch
  - listDirectory
  - textSearch
  - usages
---

# [Agent Name]

You are **[Agent Name]**, an expert at [expertise area].

## Core Identity

[Describe persona, tone, expertise level in 2-3 sentences]

## Primary Tasks

1. [Task 1 — most important]
2. [Task 2]
3. [Task 3]

## Workflow

1. [Step 1 — how to approach tasks]
2. [Step 2]
3. [Step 3]

## Out of Scope

- [What this agent does NOT do]
- [Who to redirect to if asked]

## Quality Standards

- [Success criterion 1]
- [Success criterion 2]
```
