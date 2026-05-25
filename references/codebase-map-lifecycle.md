# Codebase Map Lifecycle

The codebase map is the reusable context artifact for existing-code work. It keeps
tracks from rediscovering the same architecture, conventions, and test patterns on
every run.

## Applicability

Run this preflight for every existing-code track before the first track leg starts,
unless the track's first leg is already `codebase-map`.

Applies to:
- Feature
- Change
- Bug Fix
- Troubleshoot
- Quick Task
- Exploration
- New Project, only when it is running inside a non-empty repository

Does not apply to:
- New Project, when the repository is empty or has no meaningful source files

If the repository is not net new, the map is required. Do not proceed into the
track with no current map.

## Artifact

The canonical artifact is:

```text
.noru/codebase-map.md
```

The file starts with YAML metadata:

```yaml
---
version: 1
generated_at: 2026-05-25T12:00:00Z
base_ref: origin/main
base_sha: abc123
head_ref: feature/auth
head_sha: def456
merge_base_sha: abc123
working_tree: clean
---
```

The body contains:
- Architecture overview
- Main source areas and ownership
- Entry points
- Test approach and commands
- Build/lint/format conventions
- Dependency boundaries
- Files and directories most relevant to the current task
- Known uncertainty or unmapped areas

## Default Base Branch

Choose the base ref without asking:

1. `origin/main`
2. `main`
3. `origin/master`
4. `master`

Use the first ref that exists. If none exists, use `HEAD` and note that no
main/master base was found.

## Freshness Check

Before reusing `.noru/codebase-map.md`, compare its metadata to the current git
state.

Run:

```bash
git rev-parse --abbrev-ref HEAD
git rev-parse HEAD
git rev-parse --verify origin/main 2>/dev/null || git rev-parse --verify main 2>/dev/null || git rev-parse --verify origin/master 2>/dev/null || git rev-parse --verify master 2>/dev/null
git merge-base <base-ref> HEAD
git status --porcelain
```

Treat the map as stale if any of these are true:
- The map file is missing.
- Required metadata is missing.
- The selected `base_ref` changed.
- The selected base ref resolves to a different `base_sha`.
- `HEAD` resolves to a different `head_sha`.
- The merge base between the selected base and `HEAD` changed.
- The working tree is dirty and the map says `working_tree: clean`.

When stale, refresh it automatically. Do not ask the user for permission. The map is
context, not a plan gate.

## Refresh Behavior

When refreshing:

1. Use the selected main/master base as the baseline.
2. Compare the current branch/worktree against that base.
3. Preserve useful still-current findings from the previous map.
4. Replace stale findings that conflict with current code.
5. Update all metadata fields.
6. Write the refreshed artifact to `.noru/codebase-map.md`.

Report briefly:

```text
Codebase map refreshed: .noru/codebase-map.md
Base: origin/main @ abc123
Head: feature/auth @ def456
```

When current:

```text
Codebase map current: .noru/codebase-map.md
Base: origin/main @ abc123
Head: feature/auth @ def456
```

## State Link

When initializing or updating `.noru/state.yaml`, include:

```yaml
codebase_map:
  path: .noru/codebase-map.md
  base_ref: origin/main
  base_sha: abc123
  head_sha: def456
  status: current
```

Use `status: refreshed` when the map was updated during this entry flow.
