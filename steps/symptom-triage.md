---
name: symptom-triage
display_name: Symptom Triage
execution_mode: interactive
description: "Collect symptoms, classify severity, and determine blast radius."
---

## Objective

Understand what is happening before jumping to why. Collect a structured picture of the symptoms: what, who, when, and what changed. Classify severity and blast radius so investigation effort is proportional.

## Process

1. **Collect the report.**
   Ask one question at a time, not a form. Cover:
   - What is happening? (Error messages, unexpected behavior, missing functionality)
   - Who is affected? (One user, a subset, everyone)
   - When did it start? (Timestamp, "after the deploy", "this morning")
   - What changed recently? (Deploys, config changes, infra updates, dependency upgrades)

2. **Classify severity.**
   Based on collected symptoms, assign one:
   - **Total outage** -- service is down for affected users
   - **Degraded** -- service works but with errors, latency, or partial failure
   - **Intermittent** -- works sometimes, fails sometimes, no clear pattern yet
   - **Cosmetic** -- wrong output or display, core functionality intact

3. **Determine blast radius.**
   - One user (likely client-side or data-specific)
   - Subset of users (feature flag, region, account type)
   - All users (global code or infra issue)
   - Regional (CDN, DNS, or region-specific infra)
   - Global (everything is broken)

4. **Identify recent changes.**
   Check git log, deployment history, and config changes. What changed in the window before symptoms appeared gets the most attention in the hypothesis step.

## User Interaction

- Conversational. One question at a time -- adapt based on answers.
- If the user volunteers details early, skip redundant questions.
- Do not ask for information you can gather from the codebase (recent commits, deploy config). Look it up yourself.

## Outputs

- Structured symptom summary: what, who, when, severity, blast radius.
- Recent changes identified (deploys, config, dependencies).

## Completion Criteria

- Severity is classified.
- Blast radius is determined.
- Recent changes are catalogued.
- Enough context to generate hypotheses.
