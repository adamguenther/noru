---
name: capture-findings
display_name: Findings
execution_mode: interactive
description: "Capture what was learned during exploration as a structured document."
---

## Objective

Produce a structured FINDINGS.md that captures what was tried, what worked, what didn't, and what to do next. This is the deliverable of an exploration -- not the code.

Read and follow:

@~/.claude/noru/references/exploration-lifecycle.md

## Process

1. **Review what happened.**
   Look at the exploration branch, experiment log, commits, changed files, command outputs, and any notes. Reconstruct the investigation arc.

2. **Draft findings with the user.**
   Walk through each section of the findings template (`templates/findings.md`). Ask the user to confirm or correct each section -- they know things the code doesn't show. Every conclusion needs evidence from the log, git diff, command output, or user-confirmed observation.

3. **Write FINDINGS.md.**
   Create `.noru/findings/` directory if it doesn't exist.
   Write the document to `.noru/findings/[topic]-[YYYY-MM-DD].md`.

4. **Suggest track promotion if applicable.**
   If findings point to a buildable feature: suggest Feature track.
   If findings point to a needed change: suggest Change track.
   If findings identify a reproducible code bug: suggest Bug Fix track.
   If findings need operational diagnosis: suggest Troubleshoot track.
   If findings validate a greenfield product idea: suggest New Project track.
   If findings are purely informational: no promotion needed.

## User Interaction

- Walk through findings section by section. Confirm each one.
- If the user corrects something, update without pushback.
- At the end, ask about promotion.

## Outputs

- FINDINGS.md in `.noru/findings/`.
- Track promotion suggestion (if applicable).
- Evidence summary and experiment log path carried forward on promotion.

## Completion Criteria

- Findings document written and confirmed by user.
- Findings distinguish worked, failed, inconclusive, and unknown.
- Recommendations are backed by evidence.
- Promotion offered if findings warrant it.
