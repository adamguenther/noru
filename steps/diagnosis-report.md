---
name: diagnosis-report
display_name: Diagnosis
execution_mode: inline
description: "Produce a structured diagnosis document from investigation findings."
---

## Objective

Produce a structured DIAGNOSIS.md document that captures the full investigation: symptoms, hypotheses tested, root cause identified, fault domain, and supporting evidence. This document serves as the record of the troubleshooting session and input to remediation.

## Process

1. **Create the diagnosis directory if needed.**
   Ensure `.noru/diagnoses/` exists in the project root.

2. **Generate DIAGNOSIS.md using the template.**
   Use the template at `templates/diagnosis.md` as the structure. Fill in:
   - **Summary** -- one-sentence description of the issue and root cause.
   - **Symptoms** -- what was observed, severity, blast radius.
   - **Hypotheses Tested** -- each hypothesis, what was checked, result (confirmed/eliminated).
   - **Root Cause** -- the identified cause, or narrowed candidates if still ambiguous.
   - **Fault Domain** -- one of: code, infrastructure, configuration, deployment, third-party, data, client.
   - **Evidence** -- specific log entries, metrics, config values, or code references that support the diagnosis.
   - **Recommended Action** -- what to do next (feeds into the remediation step).

3. **Name the file descriptively.**
   Use the pattern: `DIAGNOSIS-{date}-{short-description}.md`
   Example: `DIAGNOSIS-2024-03-15-payment-timeout.md`

4. **Write the file to `.noru/diagnoses/`.**

## User Interaction

- This step runs inline -- no user interaction required.
- The diagnosis is generated from data collected in previous steps.

## Outputs

- `DIAGNOSIS-{date}-{description}.md` written to `.noru/diagnoses/`.
- Diagnosis summary displayed to user.

## Completion Criteria

- Diagnosis document is written with all sections populated.
- Fault domain is identified.
- Recommended action is stated.
