---
name: freeform-execute
display_name: Explore
execution_mode: inline
description: "Freeform exploration. No gates, no specs, no review."
---

## Objective

Work on whatever the user is investigating, without structure or ceremony. This is the most permissive step -- no specs, no atomic commits, no code quality gates. The goal is learning, not shipping.

## Process

1. **Create an exploration branch.**
   Branch name: `explore/[topic]-[YYYY-MM-DD]`
   Topic is a slugified version of the investigation subject.

2. **Work freeform.**
   Follow the user's lead. Try things, prototype, read code, spike solutions. There is no predetermined path -- the user directs.
   - No atomic commits required. Commit when convenient, or don't.
   - No test requirements. Write tests if they help investigate, skip them if not.
   - No style enforcement. This is throwaway code.

3. **Stay on the branch.**
   All work happens on the exploration branch. Do not merge to main.

## User Interaction

- Before starting: confirm the exploration topic (one sentence).
- During: follow the user's direction. Ask clarifying questions when the investigation stalls or forks.
- When the user signals done (says "done", "that's enough", "let's wrap up", or similar): transition to the findings step.

## Outputs

- Exploration branch with whatever was tried.
- No deliverable -- the next step captures findings.

## Completion Criteria

- The user signals they are done exploring.
