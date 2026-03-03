# Orchestration Patterns

## 1. Sequential Pipeline

Agents execute one after another, each receiving the output of the previous.

```
User → Agent A → Agent B → Agent C → Result
```

**When to use**: When each step depends on the previous step's output.
**Example**: Research → Design → Implement → Test

```yaml
# Orchestrator pseudocode
steps:
  1. delegate: researcher → research_brief
  2. delegate: architect (input: research_brief) → blueprint
  3. delegate: implementer (input: blueprint) → code
  4. delegate: tester (input: code) → test_results
```

## 2. DAG (Directed Acyclic Graph)

Some steps run in parallel when they don't depend on each other.

```
User → Agent A ─→ Agent B ──→ Agent E → Result
              ├→ Agent C ──┤
              └→ Agent D ──┘
```

**When to use**: When independent work can be parallelized for speed.
**Example**: After architecture design, skill creation + instruction writing + prompt design can happen in parallel.

```yaml
steps:
  1. delegate: architect → blueprint
  2. parallel:
     - delegate: skill-crafter (input: blueprint)
     - delegate: instruction-writer (input: blueprint)
     - delegate: prompt-designer (input: blueprint)
  3. delegate: validator (input: all_outputs)
```

## 3. Conditional Pipeline

Steps execute only if a condition is met.

```
User → Agent A → [if needs_security] → Agent B → Agent C → Result
                 [else] ──────────────────────→ Agent C → Result
```

**When to use**: When some steps are optional based on project requirements.
**Example**: Security review only for public-facing APIs.

## 4. Fan-Out / Fan-In

One agent generates multiple work items, which are processed in parallel, then aggregated.

```
User → Planner → [item1] → Worker → ┐
                  [item2] → Worker → ├→ Aggregator → Result
                  [item3] → Worker → ┘
```

**When to use**: Processing multiple similar items (files, modules, tests).
**Example**: Reviewing multiple PRs, generating tests for multiple modules.

## 5. Iterative Refinement

An agent loop that keeps improving until quality threshold is met.

```
User → Generator → Validator → [pass] → Result
                       ↓
                   [fail] → Generator (with feedback)
```

**When to use**: When output quality needs verification and may need multiple passes.
**Example**: Code generation → validation → fix → re-validate.

## Choosing the Right Pattern

| Scenario | Pattern | Why |
|----------|---------|-----|
| Step-by-step workflow | Sequential | Dependencies between steps |
| Independent parallel work | DAG | Speed, no inter-dependencies |
| Optional workflow steps | Conditional | Some steps may not apply |
| Bulk processing | Fan-Out/Fan-In | Many similar items to process |
| Quality-critical output | Iterative | Needs validation and refinement |
| Complex real-world teams | Hybrid | Mix patterns as needed |

## Hybrid Example: Genesis Pipeline

Genesis uses a hybrid of Sequential + DAG + Iterative:

```
Sequential: Research → Architect
DAG:        Skill Crafter + Instruction Writer + Prompt Designer (parallel)
Sequential: Validator
Iterative:  If validation fails → fix → re-validate
Sequential: Deployer
```
