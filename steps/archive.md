---
name: archive
display_name: Archive
execution_mode: inline
description: "Finalize the track. Merge specs, update state, generate summary."
---

## Objective

Close out the track cleanly. All working artifacts are finalized, state is updated, and a completion summary captures what happened for future reference.

## Process

1. **Merge delta specs (if applicable).** For Feature and Change tracks, merge the delta spec into the main spec. The delta served its purpose during implementation -- the main spec should reflect the current state of the system.
2. **Update .noru/state.yaml.** Set the track status to `completed` with a timestamp. All legs should show `complete`.
3. **Generate completion summary.** Capture:
   - What was done (one paragraph).
   - Key decisions made (reference decision IDs if they exist).
   - Files changed (list with modification type: created, modified, deleted).
   - Any follow-up items noted during execution or review.
4. **Clean up temporary state.** Remove working artifacts that are no longer needed:
   - **Remove:** `.noru/plans/` (consumed during execution), `.noru/specs/` working drafts (final spec is merged into codebase)
   - **Keep:** `.noru/checkpoints/` (project history), `.noru/findings/` (exploration deliverables), `.noru/diagnoses/` (troubleshooting records)
   - **Reset:** `.noru/state.yaml` back to empty state (copy from `templates/state.yaml`)

## User Interaction

- Present the completion summary.
- If there are follow-up items: list them as potential future tracks.
- No confirmation needed -- archiving is automatic at track end.

## Outputs

- Updated .noru/state.yaml (status: completed).
- Merged specs (if delta specs existed).
- Completion summary in the track checkpoint.

## Completion Criteria

- State reflects completed status.
- Delta specs are merged (or no delta specs existed).
- Completion summary is written.
- No orphaned temporary state remains.
