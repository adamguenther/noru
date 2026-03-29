---
name: verify-suite
display_name: Verify
execution_mode: inline
description: "Run full test suite. Confirm the fix works and nothing else broke."
---

## Objective

Final verification that the fix is correct and has no unintended side effects. This is the last gate before the bug fix is considered complete.

## Process

1. **Run the full test suite.**
   - Use the project's standard test command.
   - If the project has multiple test levels (unit, integration, e2e), run all that are available locally.

2. **Confirm the regression test passes.**
   - The test written in the Fix step must still pass.
   - This is a sanity check — it should already pass.

3. **Check for regressions.**
   - Compare test results against the baseline (before your changes).
   - Any new failures are regressions and must be investigated.
   - Flaky tests that were already flaky do not count.

4. **Report results clearly.**
   - Total tests run, passed, failed, skipped.
   - If any failures: are they related to your change or pre-existing?

## User Interaction

- Show test results in a clear summary.
- If all green: confirm the bug fix is complete.
- If regressions found: explain what failed and whether it is related to the fix.

## Outputs

- Full test suite results.
- Pass/fail determination.
- Regression analysis (if any failures).

## Completion Criteria

- Full test suite passes.
- Regression test passes.
- No new failures introduced by the fix.
