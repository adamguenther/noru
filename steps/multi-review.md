---
name: multi-review
display_name: Review
execution_mode: subagent
description: "Combined review step. Runs appropriate review levels based on track context."
agent: noru-reviewer
---

## Objective

Review the implementation through multiple independent lenses. Each review reads the code fresh -- no inherited context, no confirmation bias from having written it.

## Process

1. **Self-review (always, inline, ~30 seconds).**
   - Placeholder scan: TODO, FIXME, HACK, hardcoded secrets, temp values.
   - Debug artifacts: console.log, print(), debugger, commented-out code.
   - Style compliance: run linter/formatter if configured.
   - File hygiene: no unintended files staged.

2. **Spec compliance review (Feature, Change, New Project tracks).**
   - Spawn noru-reviewer with the spec and the implementation.
   - Check: does the implementation match what was specified?
   - Check: are there spec requirements that were missed?
   - Check: are there implementation details that contradict the spec?

3. **Code quality review (always).**
   - Spawn noru-reviewer with the changed files and surrounding context.
   - Check: existing patterns followed or diverged from?
   - Check: naming clarity, function size, abstraction level.
   - Check: error handling, edge cases, maintainability.

4. **Adversarial review (New Project critical paths only).**
   - Spawn noru-reviewer with instructions to find issues. Minimum: 1 issue.
   - This reviewer assumes the code has problems and looks for them.
   - Covers: security, performance, race conditions, failure modes.

5. **Fix cycle.** Issues found by any review are fixed, then the failing review re-runs until clean. Self-review fixes are applied inline. Subagent review fixes get their own atomic commits.

## User Interaction

- Report each review result as it completes.
- If all clean: compact summary. "Self-review, spec compliance, quality -- all clear."
- If issues found: list them, fix, report the re-review result.
- Do not ask permission to fix obvious issues (placeholder left behind, lint violation). Just fix and report.

## Outputs

- Review results per level (pass/fail, issues found).
- Fixes applied (if any), with commits.
- Final review status: clean or issues remaining.

## Completion Criteria

- All applicable review levels pass.
- No unresolved issues from any review level.
- Fixes are committed atomically.
