---
name: hypothesis-tree
display_name: Hypothesis Tree
execution_mode: interactive
description: "Generate and rank hypotheses by fault domain."
---

## Objective

Produce a ranked list of hypotheses organized by fault domain. Each hypothesis includes what evidence would confirm or eliminate it. Recent changes get the highest rank -- most production issues trace back to something that changed.

## Process

1. **Generate hypotheses across fault domains.**
   Consider each domain against the symptom summary:
   - **Code** -- recent deploy introduced a regression?
   - **Infrastructure** -- resource exhaustion (CPU, memory, connections, disk)?
   - **Configuration** -- env vars, feature flags, secrets rotation?
   - **Deployment** -- partial rollout, failed health checks, version skew?
   - **Third-party** -- upstream API degraded or changed contract?
   - **Data** -- corrupt records, migration issue, schema drift?
   - **Client-side** -- user misconfiguration, expired credentials?

2. **Rank by likelihood.**
   - What changed recently ranks highest.
   - Blast radius narrows candidates (one user points to data or client-side; all users points to code, infra, or deploy).
   - Severity pattern narrows further (intermittent suggests infra or third-party; total outage suggests deploy or infra).

3. **Define evidence for each hypothesis.**
   For every hypothesis, state:
   - What evidence would **confirm** it
   - What evidence would **eliminate** it
   - Where to look (logs, metrics, config, endpoints, dashboards)

4. **Present to user for input.**
   The user may have context that reorders the list -- a known flaky dependency, a config change they forgot to mention, an infra alert they saw.

## User Interaction

- Present the ranked hypothesis list. Ask if anything looks wrong or missing.
- The user's domain knowledge may immediately eliminate or promote hypotheses. Incorporate and re-rank.
- Agree on investigation order before proceeding.

## Outputs

- Ranked hypothesis list with fault domain labels.
- For each hypothesis: confirming evidence, eliminating evidence, where to check.
- Agreed investigation order.

## Completion Criteria

- At least 3 hypotheses generated across different fault domains.
- Hypotheses are ranked with rationale.
- Investigation order is agreed with the user.
