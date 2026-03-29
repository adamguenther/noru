# Promotion Rules Reference

When and how to suggest moving work from one track to another.

## Generic Triggers

These apply regardless of which track is active:

| Trigger | Suggested Track |
|---|---|
| Scope exceeds what the current track handles | Next-size track (Quick Task -> Feature, Bug Fix -> Change) |
| Wrong fault domain discovered | Track matching the actual domain |
| Design flaw found (not just a bug) | Change |
| Work is clearly smaller than the track expects | Lighter track |

## Per-Track Triggers

### Quick Task
- Touches more than 5 files or spans multiple services -> **Feature**
- Modifying existing behavior rather than adding -> **Change**

### Bug Fix
- Root cause is a design flaw, not a simple bug -> **Change**
- Fix requires new capabilities or significant additions -> **Feature**
- Cause is unclear and may not be a code issue -> **Troubleshoot**

### Feature
- Changes modify existing behavior rather than adding new -> **Change**

### Change
- Scope grows to require new capabilities beyond the modification -> **Feature**

### Troubleshoot
- Root cause identified as a code bug -> **Bug Fix**
- Remediation requires architectural changes -> **Change**

### Exploration
- Exploration yields a clear feature to build -> **Feature**
- Exploration reveals a needed change -> **Change**

### New Project
- No defined promotion triggers. (Where would you promote to?)

## What Carries Forward

On promotion, the following transfers to the new track:

| Carries Forward | Resets |
|---|---|
| `description` | `current_leg` (starts at 0) |
| `decisions` | `legs` (rebuilt from new track) |
| `files_in_scope` | `total_legs` (new track's count) |
| Work already committed | `started` (new timestamp) |
| Checkpoint history | Track-specific state |

The previous track's final state is saved as a checkpoint before promotion.

## How to Present Promotion

1. State the observation that triggered it.
2. Suggest the new track with a brief reason.
3. Default action is to promote (`[Y/n]`).
4. Never force. If the user declines, continue on the current track.

```
This is touching more files than a Quick Task typically should.
Promote to Feature? Your work so far carries forward. [Y/n]
```

```
Root cause is a design flaw in the auth middleware, not a bug.
Promote to Change? Investigation notes and decisions carry over. [Y/n]
```

Never revisit a declined promotion unless new evidence emerges.
