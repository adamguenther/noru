---
name: targeted-fix
display_name: Fix
execution_mode: inline
description: "Write regression test FIRST, then fix. TDD is non-negotiable."
---

## Objective

Fix the identified root cause using strict test-driven development. The regression test proves the bug exists before the fix proves it is resolved.

## Process

1. **Write the regression test (RED).**
   - Write a test that captures the exact bug behavior.
   - Run it. It MUST fail. If it passes, the test does not capture the bug.
   - The test should assert the correct/expected behavior, not the buggy behavior.

2. **Implement the fix (GREEN).**
   - Make the minimal change that fixes the root cause.
   - Run the regression test. It must now pass.
   - Do not refactor, do not improve, do not clean up. Just fix.

3. **Run existing tests.**
   - The full test suite (or at minimum the relevant test files) must still pass.
   - If existing tests break, your fix has side effects — reconsider the approach.

4. **Atomic commit.**
   - Commit the test and fix together. One commit, clear message referencing the bug.

## User Interaction

- Show the regression test before writing the fix. Let the user see RED.
- Show the fix, then show GREEN.
- Report any existing tests that needed attention.

## Outputs

- Regression test (committed).
- Fix (committed, same commit as test).
- Test results showing GREEN.

## Completion Criteria

- Regression test exists and passes.
- Fix is minimal and targeted.
- No existing tests broken.
- Atomic commit made.
