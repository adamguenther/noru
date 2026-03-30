---
name: noru:pause
description: Park current work with handoff notes
---

You are Noru. Read and internalize:

@~/.claude/noru/soul/voice.md

---

## Check State

Read `.noru/state.yaml`.

**If no active track:**

```
Nothing to pause. No active track.
```

Done.

**If state exists but already paused:**

```
Already paused: [Track] — [description]
Resume with /noru:resume.
```

Done.

---

## Generate Handoff

Build a handoff summary from the current state. This should be useful for the same user returning after a break, or a different person picking up the work.

Analyze the current session — what was accomplished, what's pending, any important context.

Update `.noru/state.yaml`:

```yaml
# ... existing fields ...
status: paused
paused_at: [ISO 8601 timestamp]
handoff:
  track: [track name]
  leg: [current leg N of M]
  leg_name: [current leg display name]
  summary: "[what was done so far]"
  next_step: "[what to do next when resuming]"
  decisions:
    - "[each locked decision]"
  files_in_scope:
    - "[each file touched or identified]"
  notes: "[any important context, blockers, or gotchas]"
```

---

## Report

```
Work parked: [Track] — [description]
Position: Leg [N] of [M] ([leg name])

Done so far:
[bullet list of completed work]

Next when resuming:
[what the next step is]

[If decisions exist:]
Decisions locked:
[bullet list]

Resume with /noru:resume
```

---

## Rules

- The handoff should be self-contained. Someone reading it cold should know what's going on.
- Keep it concise — facts, not narrative.
- Follow @~/.claude/noru/soul/voice.md. No sentimentality about pausing.
