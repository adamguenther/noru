---
name: codebase-map
display_name: Codebase Map
execution_mode: subagent
description: "Scan existing codebase for patterns, conventions, and relevant files."
agent: noru-researcher
---

## Objective

Build a working map of the existing codebase before any planning begins. The goal is context -- what patterns exist, what conventions to follow, what files are in scope. This prevents the plan from inventing patterns that contradict the codebase.

## Process

1. **Spawn noru-researcher** with the task description and target area of the codebase.
2. **Scan for patterns.** The researcher identifies:
   - Code style and structure conventions (naming, file organization, module patterns)
   - Test patterns (framework, co-located vs. separate, naming conventions)
   - Relevant existing files (will be modified, extended, or depended upon)
   - Dependencies and imports that constrain the work
   - Configuration (linters, formatters, build tools)
3. **Tool enhancement.** If `grepai` is available, use semantic search for intent-based queries ("authentication middleware", "database connection handling"). Fall back to Grep/Glob for exact matches or if grepai is unavailable.
4. **Synthesize results.** The researcher returns a structured summary, not raw search output.

## User Interaction

- After completion: present the codebase context summary.
- Keep it scannable -- patterns found, files in scope, conventions to follow.
- If the codebase is large or ambiguous, note areas of uncertainty.
- Ask to proceed to the next leg.

## Outputs

Codebase context summary containing:
- Patterns found (style, structure, test approach)
- Files in scope (to modify, extend, or depend on)
- Conventions to follow
- Dependencies and constraints

## Completion Criteria

- Key patterns identified and documented.
- Files in scope are listed with their roles.
- The summary is sufficient for the planning leg to produce a concrete task breakdown.
