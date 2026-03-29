---
name: wave-execute
display_name: Execute (Parallel)
execution_mode: subagent
description: "Parallel execution engine. Groups tasks into dependency-aware waves."
agent: noru-executor
---

## Objective

Execute the plan from the planning leg using parallel waves. Independent tasks run simultaneously, dependent tasks wait for their prerequisites. Each task gets a fresh noru-executor subagent with only the context it needs.

## Process

1. **Read the plan.** Load the task breakdown and dependency graph from the plan leg output.
2. **Build waves.**
   - Wave 1: all tasks with no dependencies. These run in parallel.
   - Wave 2: all tasks whose dependencies are satisfied by Wave 1. These run in parallel.
   - Continue building waves until all tasks are assigned.
   - If a circular dependency is detected, stop and report it.
3. **Execute each wave.**
   - For each task in the current wave, spawn a noru-executor subagent.
   - Each subagent receives: task description, file scope, relevant codebase context, and project conventions.
   - Subagents do not inherit prior conversation context -- fresh context only.
   - Wait for all subagents in the wave to report status before starting the next wave.
4. **Handle subagent statuses.**
   - `DONE`: proceed.
   - `DONE_WITH_CONCERNS`: log the concern, proceed.
   - `NEEDS_CONTEXT`: provide missing context and retry.
   - `BLOCKED`: halt the wave, report the blocker.
5. **Atomic commits.** Each subagent makes one commit per task. No mega-commits.

## User Interaction

- Before starting: confirm the wave breakdown (number of waves, tasks per wave).
- During execution: report wave completion. "Wave 1: 3/3 complete. Starting Wave 2."
- If a task is blocked or raises concerns: surface it immediately.
- After all waves: report final status with commit summary.

## Outputs

- Implemented code with one atomic commit per task.
- Wave execution log (which tasks ran in which wave, statuses).
- Any concerns raised by subagents.

## Completion Criteria

- All tasks from the plan are executed.
- All subagent statuses are `DONE` or `DONE_WITH_CONCERNS`.
- Each task has an atomic commit.
- No `BLOCKED` statuses remain unresolved.
