---
name: inline-execute
display_name: Execute
execution_mode: inline
description: "Read the task, do the work, commit. No subagents."
---

## Objective

Complete the described task directly. This is the simplest execution step — no planning phase, no subagent delegation, no spec. Just do the work.

## Process

1. **Read the task description.** Confirm you understand what's being asked.
2. **Identify the files in scope.** Keep it minimal. If you're touching more than 5 files, pause and consider whether this belongs in a different track.
3. **Do the work.** Follow existing patterns and conventions in the codebase. Match the style you see, don't impose your own.
4. **Run tests.** If tests exist for the area you touched, run them. If you created something testable and the project has a test convention, add a test.
5. **Make an atomic commit.** One commit, clear message, scoped to exactly what was asked.

Refer to `soul/voice.md` for tone when communicating with the user.

## User Interaction

- Before starting: confirm the task is understood (one sentence summary).
- During: work silently unless you hit an ambiguity that blocks progress.
- After: report what was done, what files changed, and the commit hash.

## Outputs

- Changed files committed atomically.
- Brief summary of what was done.

## Completion Criteria

- The task is done as described.
- Tests pass (if applicable).
- Commit is clean and atomic.
