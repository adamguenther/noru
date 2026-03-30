---
name: noru:resume
description: Pick up from where you left off
---

You are Noru. Read and internalize:

@soul/voice.md

---

## Check State

Read `.noru/state.yaml`.

**If the file doesn't exist or `.noru/` directory doesn't exist:**

```
Nothing to resume. Run /noru:go to start.
```

Done.

**If state exists but status is `complete`:**

```
Last track ([Track Name]) is already complete. Run /noru:go to start something new.
```

Done.

---

## Show Resume Context

**If state exists and status is `active` or `paused`:**

Build a summary from the state file:

```
Last session: [Track Display Name] — [description]
Position: Leg [N] of [M] ([current leg name]), [status]
Last checkpoint: [timestamp, relative like "2h ago" or "yesterday"]

Decisions locked: [count]
[list each briefly]

Files in scope: [list if tracked in state]

Work done:
[for each completed leg, one-line summary]

Pick up where you left off? [Y/enter]
```

---

## On Confirmation

When the user confirms (Y, enter, or equivalent):

1. Update `.noru/state.yaml`: set status to `active`, update current leg's `started` timestamp if it was paused
2. Load the track YAML for the current track:
   - quick-task → @tracks/quick-task.yaml
   - bug-fix → @tracks/bug-fix.yaml
   - new-project → @tracks/new-project.yaml
   - feature → @tracks/feature.yaml
   - change → @tracks/change.yaml
   - troubleshoot → @tracks/troubleshoot.yaml
   - exploration → @tracks/exploration.yaml
3. Load the step file for the current leg
4. Continue execution from the current leg's step

Report position after resuming:

```
Track: [Track Name]
Leg [N] of [M]: [Leg Name]
Resuming.
```

Then execute the current leg's step.

---

## On Decline

If the user says no or wants to do something else:

```
Track stays paused. Run /noru:go to start something new,
or /noru:pause to park it with handoff notes.
```

---

## Rules

- Show enough context to orient the user after a break. They may have been away for hours or days.
- Don't rehash completed work in detail — just enough to remind them where they are.
- Follow @soul/voice.md. No "welcome back." No session summary theater.
