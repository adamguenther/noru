---
name: architecture
display_name: Architecture
execution_mode: interactive
description: "System design covering data model, API contracts, component structure, and key technical decisions."
---

## Objective

Design the system architecture for a new project. Translate the specification into concrete technical structure: what components exist, how they communicate, what the data looks like, and where the key technical risks live.

## Process

1. **Define the data model.**
   Entities, relationships, storage approach. Start from the domain, not the database. If the spec has a decision locked on storage technology, honor it.

2. **Design API contracts.**
   External interfaces the system exposes. For each: endpoint/method, input shape, output shape, error cases. Contracts are specific enough to implement against.

3. **Map component structure.**
   How the system is organized: modules, services, layers. Define boundaries and responsibilities. State what each component owns and what it delegates.

4. **Document key technical decisions as ADRs.**
   Each Architecture Decision Record covers:
   - Context: what prompted the decision
   - Decision: what was chosen
   - Alternatives: what was considered
   - Consequences: trade-offs accepted
   Use decision IDs from the spec (D-01, etc.) where they apply. Add new IDs for architecture-level decisions.

5. **Identify technical risks.**
   What could go wrong architecturally. Where are the scaling bottlenecks, single points of failure, or complexity hotspots. State each risk and the mitigation approach.

## User Interaction

- Walk through each section. The data model and API contracts deserve the most discussion.
- Present trade-offs with a lean and ask for the call. Do not make major architecture choices silently.
- If the spec is ambiguous on something architecture needs to resolve, surface it and lock a decision.

## Outputs

- `architecture.md` written to `.noru/specs/`
- Sections: Data Model, API Contracts, Component Structure, ADRs, Technical Risks
- ADRs with decision IDs

## Completion Criteria

- Data model covers all entities from the spec.
- API contracts are specific enough to implement against.
- Component boundaries and responsibilities are clear.
- Key decisions are documented as ADRs with rationale.
- User has reviewed and confirmed the architecture.
