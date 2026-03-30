---
name: reproduce
display_name: Reproduce
execution_mode: interactive
description: "Confirm the bug exists and is reproducible before attempting a fix."
---

## Objective

Verify the reported bug is real and reproducible. Do not proceed to root cause analysis until reproduction is confirmed. A bug you cannot reproduce is a bug you cannot reliably fix.

## Process

1. **Gather reproduction details from the user.**
   Ask for (one question at a time, not a form):
   - Steps to reproduce (exact sequence)
   - Expected behavior vs actual behavior
   - Error messages, stack traces, or logs
   - Environment details if relevant (browser, OS, version)

2. **Attempt local reproduction.**
   - Follow the user's steps exactly.
   - If there's a failing test, run it.
   - If there's a stack trace, trace it to the relevant code path.

3. **Confirm or escalate.**
   - If reproduced: state clearly what was observed and where.
   - If not reproduced: ask the user for more detail or different conditions. Do not proceed without reproduction.

## User Interaction

- Before starting: "Attempting to reproduce..."
- This step is conversational. Ask questions, listen, try, report back.
- Show what you tried and what you observed.
- If you can write a failing test that demonstrates the bug, do so — that is the ideal reproduction.

## Outputs

- Confirmed reproduction (or documented inability to reproduce).
- Reproduction steps (codified, not just prose).
- Failing test if possible.

## Completion Criteria

- Bug is confirmed reproducible with clear steps.
- OR: documented as non-reproducible with details of what was attempted.
