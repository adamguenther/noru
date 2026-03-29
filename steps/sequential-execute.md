---
name: sequential-execute
display_name: Execute (Sequential)
execution_mode: subagent
description: "One-at-a-time execution. Safer for modifications with cascading effects."
agent: noru-executor
---

## Objective

Execute the plan from the planning leg one task at a time. Each task completes and is verified before the next begins. Used by the Change track where modifications can have cascading effects that parallel execution would miss.

## Process

1. **Read the plan.** Load the task breakdown from the plan leg output, ordered by dependency.
2. **For each task, in order:**
   a. Spawn a noru-executor subagent with: task description, file scope, relevant context, and project conventions.
   b. Wait for the subagent to report status.
   c. On `DONE`: run affected tests to verify the change before moving on.
   d. On `DONE_WITH_CONCERNS`: log the concern, verify tests, then decide whether to proceed or pause.
   e. On `NEEDS_CONTEXT`: provide missing context and retry.
   f. On `BLOCKED`: stop execution and report the blocker.
3. **Verify between tasks.** After each task completes, run the relevant test subset. If tests fail, fix before proceeding -- cascading on a broken foundation wastes everything downstream.
4. **Atomic commits.** Each subagent makes one commit per task.

## User Interaction

- Before starting: confirm the task order and count.
- After each task: brief status. "Task 2/5 complete. Tests pass. Continuing."
- If a task fails verification: report what broke and whether it's safe to continue.
- After all tasks: report final status with commit summary.

## Outputs

- Implemented code with one atomic commit per task.
- Sequential execution log (task order, statuses, verification results).
- Any concerns raised by subagents.

## Completion Criteria

- All tasks from the plan are executed in order.
- Tests pass after each task (not just at the end).
- All subagent statuses are `DONE` or `DONE_WITH_CONCERNS`.
- Each task has an atomic commit.
