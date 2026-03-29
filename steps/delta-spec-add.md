---
name: delta-spec-add
display_name: Delta Spec (Add)
execution_mode: interactive
description: "Produce a delta specification for adding new capabilities to an existing codebase."
---

## Objective

Specify what is being added to the codebase without restating what already exists. The delta spec covers only new capabilities — if existing behavior is being modified, that belongs in delta-spec-mod.

## Process

1. **Reference existing patterns.**
   Pull conventions, architecture patterns, and file structures identified during the codebase-map leg. New code must follow established patterns unless there is a documented reason to diverge.

2. **Define ADDED capabilities.**
   Each addition describes:
   - What it does (functional behavior)
   - Where it lives (files, modules, layers)
   - How it integrates with existing code (entry points, dependencies)
   - How it is tested (test approach and scenarios)

3. **Lock decisions.**
   Significant choices get IDs: D-01, D-02, etc. Record what was decided, what was considered, and why. Reference codebase-map findings where relevant.

4. **Mark ambiguities.**
   Use `[NEEDS CLARIFICATION]` for anything unresolved. Attach a specific question to each marker.

5. **Write the delta spec.**
   Format: ADDED section only. No MODIFIED or REMOVED sections — those belong in delta-spec-mod. Save to `.noru/specs/[change-name]/delta.md`.

## User Interaction

- Walk through additions one at a time. Confirm each before moving to the next.
- When a proposed addition conflicts with existing patterns, surface the conflict and ask for a call.
- If scope creeps into modifying existing behavior, flag it and suggest splitting into a separate Change track.

## Outputs

- `delta.md` written to `.noru/specs/[change-name]/`
- Contains only ADDED sections
- Decisions locked with IDs
- Ambiguities marked with `[NEEDS CLARIFICATION]`

## Completion Criteria

- Every new capability is specified with behavior, location, integration, and test approach.
- Existing codebase patterns are referenced and respected.
- No MODIFIED or REMOVED sections are present.
- User has reviewed and confirmed the delta spec.
