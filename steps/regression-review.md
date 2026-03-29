---
name: regression-review
display_name: Regression Review
execution_mode: subagent
description: "Verify no regressions introduced. Specific to the Change track."
agent: noru-reviewer
---

## Objective

Confirm that the change works correctly AND that unchanged behavior still works. This step cross-references the impact analysis from earlier in the track to verify every identified risk area.

## Process

1. **Run the full test suite.** Not just the tests for changed files -- the entire suite. Changes to existing behavior can break things far from the modification point.
2. **Verify modified behavior.** The code that was intentionally changed must work as specified. Compare against the delta spec.
3. **Verify unchanged behavior.** The indirect dependents identified in the impact analysis must still function correctly. This is the regression check.
4. **Cross-reference impact analysis.** For each item flagged in the impact report:
   - Direct dependents: confirm they were updated and work.
   - Indirect dependents: confirm they still pass their tests.
   - Coverage gaps: note any flagged areas that remain untested.
5. **Report results.** Clear pass/fail with evidence. If regressions are found, identify whether they are from the change or pre-existing.

## User Interaction

- Report test suite results: total run, passed, failed, skipped.
- If all green: confirm no regressions. "Full suite passes. Impact analysis items verified."
- If regressions found: list each one with the likely cause (this change vs. pre-existing).
- If coverage gaps remain: note them as accepted risk, not failures.

## Outputs

- Full test suite results.
- Regression report: pass/fail per impact analysis item.
- Any regressions found with cause attribution.
- Coverage gaps acknowledged.

## Completion Criteria

- Full test suite passes (or pre-existing failures are identified as such).
- All direct dependents verified working.
- All indirect dependents verified not regressed.
- Impact analysis items are accounted for.
