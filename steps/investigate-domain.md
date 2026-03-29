---
name: investigate-domain
display_name: Investigation
execution_mode: interactive
description: "Systematically investigate hypotheses until the fault is localized."
---

## Objective

Work through the ranked hypothesis list, highest priority first. For each hypothesis, guide the user through specific checks. Eliminate domains progressively until the fault is localized to a single cause or a narrow set of candidates.

## Process

1. **For each hypothesis (highest-ranked first):**
   - State what to check: logs, metrics, config, endpoints, dashboards.
   - State how to check it: specific commands, queries, URLs, or API calls.
   - State what the result means: what confirms, what eliminates, what narrows.

2. **Agent reads code and config; user provides production observations.**
   The agent cannot access production systems. It can:
   - Read source code, config files, deploy manifests, migration scripts.
   - Suggest specific log queries, metric dashboards, or health check endpoints.
   - Interpret results the user reports back.

3. **Narrow progressively.**
   After each check, update the hypothesis list:
   - Eliminated hypotheses are marked and skipped.
   - Confirmed hypotheses are investigated deeper.
   - New hypotheses that emerge from evidence are added and ranked.

4. **Localize the fault.**
   Continue until the fault is narrowed to a specific domain and cause, or until the remaining candidates are documented for the diagnosis step.

## User Interaction

- This is the most conversational step. Back-and-forth between agent and user.
- Give one check at a time. Wait for the result before suggesting the next.
- Interpret results for the user -- what does this log line mean, what does this metric pattern indicate.
- If a check is ambiguous, suggest a follow-up check that disambiguates.

## Outputs

- Investigation log: hypotheses tested, checks performed, results observed.
- Eliminated fault domains with reasoning.
- Narrowed diagnosis: fault domain and likely cause with supporting evidence.

## Completion Criteria

- Fault is localized to a specific domain and cause.
- OR: narrowed to 2-3 candidates with a documented reason why further narrowing requires action (e.g., need to reproduce, need access to a system).
- Evidence supports the conclusion.
