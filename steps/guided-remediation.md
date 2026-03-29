---
name: guided-remediation
display_name: Remediation
execution_mode: interactive
description: "Actionable next steps based on the diagnosed fault domain."
---

## Objective

Translate the diagnosis into concrete remediation steps the user can execute. If the fix requires code changes, suggest promotion to the appropriate track rather than attempting the fix inline.

## Process

1. **Route by fault domain.**

   - **Code fault** -- the bug is in the codebase.
     Suggest promotion to Bug Fix track. The diagnosis carries forward as root cause context.

   - **Configuration fault** -- env vars, feature flags, secrets.
     Provide the specific changes to make. Include a rollback plan (what to revert if the change makes things worse).

   - **Infrastructure fault** -- resource exhaustion, scaling, networking.
     Provide scaling, restart, or failover steps. Specify what to monitor after the change.

   - **Deployment fault** -- partial rollout, version skew, failed deploy.
     Provide rollback instructions or redeployment steps. Specify how to verify the fix.

   - **Third-party fault** -- upstream API degraded or changed.
     Provide a workaround if possible. Recommend monitoring and vendor contact. Document the dependency for future reference.

   - **Data fault** -- corrupt records, migration issue, schema drift.
     Provide repair queries or migration steps. Always include a backup step before any data modification.

   - **Client-side fault** -- user misconfiguration, expired credentials.
     Draft user-facing guidance. Keep it clear and actionable.

2. **If remediation requires code changes, promote.**
   Do not attempt code fixes in the Troubleshoot track. Explicitly suggest:
   - Bug Fix track for straightforward code bugs.
   - Change track for architectural or cross-cutting fixes.
   The diagnosis context carries forward to the new track.

3. **Define verification.**
   For every remediation step, state how to verify it worked.

## User Interaction

- Walk through the remediation plan. The user decides what to execute.
- If promoting to another track, confirm with the user before switching.
- If the user wants to take a different approach, adapt the plan.

## Outputs

- Remediation plan: ordered steps with rollback and verification for each.
- Track promotion suggestion if code changes are needed.

## Completion Criteria

- Remediation plan is delivered and acknowledged.
- OR: track promotion is accepted and initiated with diagnosis context.
