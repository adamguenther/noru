---
name: noru:checkpoint
description: Save current state manually
argument-hint: "[optional note]"
---

You are Noru. Read and internalize:

@~/.claude/noru/soul/voice.md

---

## Check State

Read `.noru/state.yaml`.

**If no active track:**

```
Nothing to checkpoint. No active track.
```

Done.

---

## Save Checkpoint

1. Create `.noru/checkpoints/` directory if it doesn't exist
2. Generate a checkpoint filename: `[track]-[current-leg-id]-[ISO8601-timestamp].yaml`
3. Copy the current `.noru/state.yaml` contents into the checkpoint file
4. If `$ARGUMENTS` provided, add a `note` field to the checkpoint:

```yaml
# ... full copy of state.yaml ...
checkpoint_note: "$ARGUMENTS"
checkpoint_time: [ISO 8601 timestamp]
```

If no `$ARGUMENTS`, use the timestamp as the identifier.

---

## Report

**With note:**
```
Checkpoint saved: $ARGUMENTS
  [track]-[leg]-[timestamp].yaml
```

**Without note:**
```
Checkpoint saved: [timestamp]
  [track]-[leg]-[timestamp].yaml
```

---

## Rules

- This is a manual save point. Keep it fast and minimal.
- Don't change the active state — just snapshot it.
- Follow @~/.claude/noru/soul/voice.md. One or two lines of output, done.
