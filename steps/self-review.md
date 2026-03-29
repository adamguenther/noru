---
name: self-review
display_name: Self-Review
execution_mode: inline
description: "30-second quality checklist. No subagent — just a quick sanity pass."
---

## Objective

Catch obvious mistakes before considering the work done. This is not a thorough code review — it is a fast, automated checklist that takes seconds, not minutes.

## Process

Run through this checklist against the changes made:

1. **Placeholder scan.** Search for TODO, FIXME, HACK, XXX, placeholder, lorem ipsum, hardcoded secrets, or temp values left in committed code.
2. **Test pass.** Run the project's test command. All tests must pass.
3. **Style compliance.** If the project has a linter or formatter configured, run it. No new violations.
4. **Debug artifacts.** No console.log, print(), debugger statements, or commented-out code left behind.
5. **File hygiene.** No unintended files staged (node_modules, .env, build artifacts, OS files).

## User Interaction

- Report the checklist results as a compact list.
- If everything passes: show the green list and ask to proceed.
- If something fails: fix it inline, re-run, then report.

## Outputs

- Checklist results (pass/fail per item).
- Any auto-fixes applied.

## Completion Criteria

- All 5 checklist items pass.
- No manual intervention needed (or issues were auto-fixed).
