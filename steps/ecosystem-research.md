---
name: ecosystem-research
display_name: Ecosystem Research
execution_mode: subagent
description: "Parallel research into technology landscape, prior art, and tooling options."
---

## Objective

Investigate the technology ecosystem relevant to the project before committing to a stack. Produce a synthesized summary with recommendations, not a dump of raw findings.

## Process

1. **Spawn parallel research subagents (noru-researcher).**
   Each subagent investigates one domain:
   - **Technology landscape**: languages, frameworks, runtimes relevant to the project's needs
   - **Prior art and competitors**: existing solutions, open source projects, commercial products
   - **Libraries and tools**: dependencies, build tools, testing frameworks, deployment options

2. **Collect and deduplicate results.**
   Subagents return structured findings. Merge overlapping discoveries.

3. **Synthesize into a research summary.**
   Distill findings into trade-offs and recommendations. Every recommendation states why and what was considered against it.

4. **Flag decisions that need user input.**
   Some choices depend on team preferences, existing infrastructure, or constraints not visible from research alone. Surface these clearly.

## User Interaction

- Before starting: "Researching technology options and prior art..."
- This step runs autonomously. The user waits while subagents research.
- On completion, present the summary and ask if any area needs deeper investigation before moving on.

## Outputs

- Research summary containing:
  - **Technology options**: evaluated candidates with trade-offs
  - **Prior art**: relevant existing solutions and what can be learned from them
  - **Recommended stack**: specific recommendations with rationale
  - **Open questions**: decisions that require user input or team context

## Completion Criteria

- All three research domains have been investigated.
- Findings are synthesized into a coherent summary, not raw lists.
- Recommendations are actionable and justified.
- Open questions are surfaced for user decision in the next leg.
