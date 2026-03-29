# State Schema Reference (version: 1)

## .noru/state.yaml

| Field | Type | Required | Description |
|---|---|---|---|
| `version` | integer | yes | Schema version. Currently `1`. |
| `track` | string \| null | yes | Active track name (e.g., `bug-fix`, `feature`). Null when no track active. |
| `description` | string | yes | User's description of the work. |
| `started` | ISO 8601 \| null | yes | When the track was started. Null when no track active. |
| `current_leg` | integer | yes | Zero-indexed position in the legs array. `0` when not started. |
| `total_legs` | integer | yes | Number of legs in the active track. `0` when no track active. |
| `legs` | array | yes | Ordered leg status objects. Empty when no track active. |
| `decisions` | array | yes | Decisions locked during this track. Empty at start. |
| `files_in_scope` | array | no | Files identified as relevant. Populated during analysis legs. |

### Leg Object

| Field | Type | Description |
|---|---|---|
| `id` | string | Leg identifier from track definition (e.g., `reproduce`, `root-cause`). |
| `status` | enum | `pending` \| `in-progress` \| `complete` \| `skipped` |
| `started` | ISO 8601 \| null | When this leg began. |
| `completed` | ISO 8601 \| null | When this leg finished. |

### Decision Object

| Field | Type | Description |
|---|---|---|
| `id` | string | Sequential ID (e.g., `D-01`, `D-02`). |
| `text` | string | What was decided. |
| `reason` | string | Why this option was chosen. |

## Example: Bug Fix In Progress

```yaml
version: 1
track: bug-fix
description: "checkout total off by a penny on international orders"
started: 2026-03-29T14:22:00Z
current_leg: 2
total_legs: 4
legs:
  - id: reproduce
    status: complete
    started: 2026-03-29T14:22:00Z
    completed: 2026-03-29T14:25:00Z
  - id: root-cause
    status: complete
    started: 2026-03-29T14:25:00Z
    completed: 2026-03-29T14:38:00Z
  - id: fix
    status: in-progress
    started: 2026-03-29T14:38:00Z
    completed: null
  - id: verify
    status: pending
    started: null
    completed: null
decisions:
  - id: D-01
    text: "Fix rounding at conversion boundary, not introduce Money value object"
    reason: "Bug fix scope -- Money value object is a follow-up Change"
files_in_scope:
  - /src/checkout/currency.ts
```

## Example: Completed Quick Task

```yaml
version: 1
track: null
description: ""
started: null
current_leg: 0
total_legs: 0
legs: []
decisions: []
```

State resets to this after a track completes and is archived.

## Checkpoint Format (`.noru/checkpoints/[track]-[leg-id]-[timestamp].yaml`)

```yaml
version: 1
track: bug-fix
leg: root-cause
timestamp: 2026-03-29T14:38:00Z
summary: "Root cause identified: rounding before conversion in currency.ts:147"
state_snapshot: # Full copy of state.yaml at checkpoint time
  track: bug-fix
  description: "checkout total off by a penny on international orders"
  started: 2026-03-29T14:22:00Z
  current_leg: 1
  total_legs: 4
  legs: [...]
  decisions: [...]
  files_in_scope: [...]
```
