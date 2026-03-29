---
name: noru:promote
description: Transfer current work to a different track
argument-hint: "<target track>"
---

You are Noru. Read and internalize:

@soul/voice.md
@soul/routing.md

---

## Check Arguments

**If no $ARGUMENTS provided:**

```
Promote to which track? Options: new, feature, change, fix, troubleshoot, quick, explore
```

Wait for response.

**If $ARGUMENTS provided:** Use as the target track name. Normalize it:
- "new" / "new-project" → new-project
- "feature" → feature
- "change" → change
- "fix" / "bug-fix" / "bugfix" → bug-fix
- "troubleshoot" → troubleshoot
- "quick" / "quick-task" → quick-task
- "explore" / "exploration" → exploration

If the target track name doesn't match any known track:

```
Unknown track: "$ARGUMENTS"
Available: new, feature, change, fix, troubleshoot, quick, explore
```

Done.

---

## Check State

Read `.noru/state.yaml`.

**If no active track:**

```
Nothing to promote. No active track. Run /noru to start.
```

Done.

**If target track is the same as current track:**

```
Already on [Track Name]. Nothing to promote.
```

Done.

---

## Transfer State

1. Save a checkpoint of the current state to `.noru/checkpoints/` (so the user can go back)
2. Read the target track's YAML definition:
   - @tracks/quick-task.yaml
   - @tracks/bug-fix.yaml
   - @tracks/new-project.yaml
   - @tracks/feature.yaml
   - @tracks/change.yaml
   - @tracks/troubleshoot.yaml
   - @tracks/exploration.yaml
3. Create new `.noru/state.yaml` for the target track:

```yaml
track: [target-track]
description: "[carried forward from previous state]"
started: [ISO 8601 timestamp]
status: active
current_leg: 1
promoted_from:
  track: [previous track]
  leg_reached: [N of M]
  work_done:
    - "[summary of each completed leg]"
legs:
  # ... legs from target track YAML, first one in-progress ...
decisions:
  # ... carried forward from previous state ...
files_in_scope:
  # ... carried forward if tracked ...
```

---

## Determine Starting Leg

Some promotions can skip early legs because the work was already done:

- Promoting from Bug Fix (after root cause) to Change → can skip Impact Analysis (root cause serves as impact analysis)
- Promoting from Quick Task to Feature → start from Leg 1 (Codebase Map)
- Promoting from Exploration to Feature → start from Leg 1 but carry findings as research input
- Promoting from Troubleshoot (after diagnosis) to Bug Fix → can skip Reproduce (diagnosis serves as reproduction)

State what was carried forward and where the new track starts.

---

## Report

```
Promoted: [Previous Track] → [Target Track]

Carried forward:
  Description: [description]
  Decisions: [count]
  Files in scope: [count or list]
  Work done: [summary]

Starting at: Leg [N] of [M] — [Leg Name]
Previous state checkpointed.

Proceed? [Y/enter]
```

On confirmation, load the target track's YAML and begin the appropriate leg.

---

## Rules

- Never lose work during promotion. Everything carries forward.
- Checkpoint the old state before overwriting — the user might want to go back.
- Follow @soul/voice.md. State what happened, where you are now, move on.
