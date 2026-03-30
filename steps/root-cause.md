---
name: root-cause
display_name: Root Cause
execution_mode: interactive
description: "Systematic backward tracing from symptom to source."
---

## Objective

Identify the exact root cause of the reproduced bug. Not the symptom, not a guess — the specific code path, line, and logic error that produces the wrong behavior.

## Process

1. **Start from the symptom.**
   What is the observable wrong behavior? What value is wrong, what error is thrown, what state is corrupted?

2. **Read error messages carefully.**
   Error messages and stack traces are evidence, not noise. Trace each frame.

3. **Check recent changes.**
   Use git log on the affected files. If the bug is new, the cause is likely recent.

4. **Trace data flow.**
   Follow the data from input to the point of failure. Where does the actual value diverge from the expected value?

5. **Narrow to a single cause.**
   The root cause is ONE thing. If you find multiple issues, identify which one causes the reported symptom. Others are separate bugs.

## User Interaction

- Before starting: "Tracing from symptom to source..."
- Share your reasoning as you narrow down. The user may have context that accelerates the search.
- When the root cause is found, explain it clearly: file, line, what the code does, why it is wrong.
- Ask the user to confirm the analysis makes sense before proceeding.

## Outputs

- Root cause identification: file path, line number, explanation.
- Why this causes the observed symptom.
- Confidence level (certain, high, probable).

## Completion Criteria

- Root cause is identified with file and line reference.
- The causal chain from root cause to symptom is explained.
- User confirms the analysis.
