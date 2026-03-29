---
name: delta-spec-mod
display_name: Delta Spec (Modify)
execution_mode: interactive
description: "Produce a delta specification for modifying or removing existing behavior."
---

## Objective

Specify what is changing or being removed in the codebase. Every modification states both the new behavior and the previous behavior it replaces. Every removal states what is being removed and why.

## Process

1. **Incorporate impact analysis.**
   Use blast radius findings from the impact-analysis leg. Every file and dependency identified as affected must be addressed in the spec.

2. **Define MODIFIED capabilities.**
   Each modification describes:
   - What the behavior is now (before)
   - What the behavior will be (after)
   - Why the change is needed
   - Files affected and nature of changes
   - Regression risks and how they are mitigated

3. **Define REMOVED capabilities (if applicable).**
   Each removal describes:
   - What is being removed
   - Why it is being removed
   - What depended on it and how those dependencies are handled
   - Migration path for consumers (if any)

4. **Lock decisions.**
   Significant choices get IDs: D-01, D-02, etc. Include rationale and alternatives considered. Pay attention to backward compatibility decisions.

5. **Mark ambiguities.**
   Use `[NEEDS CLARIFICATION]` for unresolved items. Attach specific questions.

6. **Write the delta spec.**
   Format: MODIFIED and/or REMOVED sections. No ADDED section — that belongs in delta-spec-add. Save to `.noru/specs/[change-name]/delta.md`.

## User Interaction

- Present each modification with before/after side by side. Confirm understanding before proceeding.
- Surface regression risks explicitly. Do not bury them.
- If the scope expands to adding net-new functionality, flag it and suggest splitting.

## Outputs

- `delta.md` written to `.noru/specs/[change-name]/`
- Contains MODIFIED and/or REMOVED sections
- Each MODIFIED entry includes before and after states
- Each REMOVED entry includes justification and dependency handling
- Decisions locked with IDs

## Completion Criteria

- All affected files from impact analysis are addressed.
- Every modification has both before and after states documented.
- Every removal has justification and dependency handling.
- Regression risks are identified with mitigation strategies.
- User has reviewed and confirmed the delta spec.
