---
name: impact-analysis
display_name: Impact Analysis
execution_mode: subagent
description: "Map the blast radius of a proposed change before planning begins."
agent: noru-researcher
---

## Objective

Determine what breaks, what needs updating, and what needs testing before any code changes happen. This is the critical differentiator for the Change track -- modifications to existing behavior require understanding the full dependency chain.

## Process

1. **Spawn noru-researcher** with the proposed change description and the entry-point files.
2. **Map direct dependents.** Files that import, extend, or call the code being changed. These will need modifications.
3. **Map indirect dependents.** Files that use the changed code through intermediate layers. These need regression testing even if they don't change.
4. **Assess test coverage.** For each affected file, check whether tests exist, what they cover, and where gaps are.
5. **Produce risk assessment.** Rate blast radius (narrow / moderate / wide) based on dependent count, test coverage, and whether public interfaces change.

## User Interaction

- After completion: present the impact report in a structured format.
- List direct dependents (will need changes) and indirect dependents (need testing).
- Show test coverage status for affected areas.
- State the blast radius rating and reasoning.
- Ask to proceed to specification.

## Outputs

Impact report containing:
- Direct dependents (files that need changes, with reason)
- Indirect dependents (files that need regression testing)
- Test coverage gaps (untested paths in the blast radius)
- Risk assessment (narrow / moderate / wide, with reasoning)

## Completion Criteria

- All direct dependents identified.
- Indirect dependents mapped at least one layer deep.
- Test coverage gaps are documented.
- Risk assessment is stated with evidence, not guessed.
