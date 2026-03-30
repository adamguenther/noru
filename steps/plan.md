---
name: plan
display_name: Plan
execution_mode: subagent
description: "Break the spec into executable tasks with dependency graph and parallel execution waves."
agent: noru-planner
---

## Objective

Translate the specification into a concrete, executable task plan. Every task is specific enough that an agent can pick it up and implement it without asking clarifying questions. No hand-waving allowed.

## Process

1. **Spawn noru-planner agent.**
   The planner reads the spec (and architecture, if present) and produces the task breakdown.

2. **Decompose into tasks.**
   Each task specifies:
   - What to do (exact changes, not vague descriptions)
   - Which files to create or modify
   - Expected behavior when complete
   - How to verify (test command, expected output)
   Reject any task containing "TBD", "fill in later", "as needed", or equivalent.

3. **Build the dependency graph.**
   Determine which tasks depend on which. A task that creates a module must come before tasks that import from it. A task that defines an API contract must come before tasks that implement clients for it.

4. **Group into waves.**
   Tasks with no unmet dependencies go into the same wave. Waves execute in order. Tasks within a wave run in parallel.
   - Wave 1: foundational tasks (project structure, core types, base config)
   - Wave 2+: tasks that depend on Wave 1 outputs, grouped by independence
   - Final wave: integration tasks that depend on everything above

5. **Write the plan using the template.**
   Follow `templates/plan.md` for structure. Save to `.noru/plans/`.

## User Interaction

- Before starting: "Breaking spec into tasks and dependency waves..."
- This step runs autonomously via the planner subagent.
- On completion, present the plan summary: number of tasks, number of waves, estimated parallelism.
- The user MUST approve the plan before execution begins.
- GATE: After presenting the plan, wait for explicit user approval before marking this step complete. Support three responses: Y (proceed), n (stop), edit (revise). If "edit", ask what to change, revise, present again.

## Outputs

- `plan.md` written to `.noru/plans/`
- Tasks with exact file paths, changes, and verification criteria
- Dependency graph expressed as wave groupings
- No unresolved placeholders

## Completion Criteria

- Every requirement from the spec maps to at least one task.
- Every task has specific files, changes, and verification.
- No task contains "TBD" or deferred details.
- Dependencies are explicit and waves are correctly ordered.
- User has explicitly approved the plan (Y or Enter). 'edit' cycles back to revision. 'n' halts.
