---
name: full-spec
display_name: Full Specification
execution_mode: interactive
description: "Produce a complete project specification with requirements, constraints, and locked decisions."
---

## Objective

Produce a complete specification that is specific enough to implement against. Every ambiguity is either resolved or explicitly marked. Key decisions are locked with IDs so they can be referenced later.

## Process

1. **Draft functional requirements.**
   Based on discovery output and research summary, enumerate what the system must do. Group by capability area. Each requirement is testable.

2. **Draft non-functional requirements.**
   Performance, security, scalability, accessibility, observability. Only include what matters for this project — do not pad with boilerplate.

3. **Document constraints.**
   Technical constraints (existing infra, language, compatibility), business constraints (timeline, budget, compliance), and scope constraints (what is explicitly out of scope).

4. **Lock decisions.**
   Each significant decision gets an ID: D-01, D-02, etc. Record the decision, the alternatives considered, and the rationale. Decisions are referenced by ID in later legs.

5. **Define test scenarios.**
   For each functional requirement, at least one test scenario that would verify it. These become the verification criteria during review.

6. **Mark ambiguities.**
   Anything unclear gets a `[NEEDS CLARIFICATION]` marker with a specific question. Do not guess. Do not leave it vague. Ask.

7. **Write the spec using the template.**
   Follow `templates/spec.md` for structure. Present to the user for review.

## User Interaction

- Present sections incrementally. Get confirmation or corrections before moving on.
- When hitting ambiguity, ask one clarifying question at a time.
- If the user defers a decision, mark it `[NEEDS CLARIFICATION]` and continue.
- Push back on requirements that are untestable or contradictory.

## Outputs

- `spec.md` written to `.noru/specs/`
- All decisions locked with IDs (D-01, D-02, ...)
- Ambiguities marked with `[NEEDS CLARIFICATION]`

## Completion Criteria

- All sections of the spec template are populated.
- Functional requirements are testable.
- Decisions are locked with rationale.
- Remaining ambiguities are explicitly marked, not hidden.
- User has reviewed and confirmed the spec.
