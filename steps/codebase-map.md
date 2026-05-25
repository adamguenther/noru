---
name: codebase-map
display_name: Codebase Map
execution_mode: subagent
description: "Scan existing codebase for patterns, conventions, and relevant files."
agent: noru-researcher
---

## Objective

Build a working map of the existing codebase before any planning begins. The goal is context -- what patterns exist, what conventions to follow, what files are in scope. This prevents the plan from inventing patterns that contradict the codebase.

This step also owns the reusable map artifact. Read and follow:

@~/.claude/noru/references/codebase-map-lifecycle.md

## Process

1. **Check map freshness.** Inspect `.noru/codebase-map.md` and compare its metadata to the current git state. Use `origin/main`, `main`, `origin/master`, then `master` as the default base-ref order. If the map is current, reuse it and continue with the task-specific scope summary.
2. **Refresh when stale or missing.** If the artifact is missing or stale, regenerate it automatically before proceeding. Do not ask permission.
3. **Spawn noru-researcher** with the task description, target area of the codebase, selected base ref, and current branch/head metadata.
4. **Scan for patterns.** The researcher identifies:
   - Code style and structure conventions (naming, file organization, module patterns)
   - Test patterns (framework, co-located vs. separate, naming conventions)
   - Relevant existing files (will be modified, extended, or depended upon)
   - Dependencies and imports that constrain the work
   - Configuration (linters, formatters, build tools)
5. **Tool enhancement.** If `grepai` is available, use semantic search for intent-based queries ("authentication middleware", "database connection handling"). Fall back to Grep/Glob for exact matches or if grepai is unavailable.
6. **Synthesize results.** The researcher returns a structured summary, not raw search output.
7. **Write the artifact.** Save the map to `.noru/codebase-map.md` with YAML metadata for `generated_at`, `base_ref`, `base_sha`, `head_ref`, `head_sha`, `merge_base_sha`, and `working_tree`.
8. **Link state.** When `.noru/state.yaml` exists or is being initialized, add or update its `codebase_map` field with the artifact path and current git metadata.

## User Interaction

- Before freshness check: "Checking codebase map against git..."
- If refreshing: "Refreshing codebase map from main/master baseline..."
- If current: report the map is current and continue.
- After completion: present the codebase context summary and artifact path.
- Keep it scannable -- patterns found, files in scope, conventions to follow.
- If the codebase is large or ambiguous, note areas of uncertainty.
- Ask to proceed to the next leg.

## Outputs

- `.noru/codebase-map.md` with current git metadata.
- Codebase context summary containing:
  - Patterns found (style, structure, test approach)
  - Files in scope (to modify, extend, or depend on)
  - Conventions to follow
  - Dependencies and constraints

## Completion Criteria

- `.noru/codebase-map.md` exists and is current against the selected main/master base and current `HEAD`.
- Key patterns identified and documented.
- Files in scope are listed with their roles.
- The summary is sufficient for the planning leg to produce a concrete task breakdown.
