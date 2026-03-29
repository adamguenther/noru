# Track Compositions Reference

Canonical reference for leg ordering, checkpoints, and execution mode per track.

## Quick Reference

| Track | Legs | Execution Mode |
|---|---|---|
| New Project | 8 | parallel |
| Feature | 6 | parallel |
| Change | 6 | sequential |
| Bug Fix | 4 | inline |
| Troubleshoot | 5 | interactive |
| Quick Task | 2 | inline |
| Exploration | 2 | inline |

## Leg Compositions

### New Project
| # | Leg | Step | Checkpoint |
|---|---|---|---|
| 1 | Discovery | discovery | no |
| 2 | Research | ecosystem-research | no |
| 3 | Specification | full-spec | no |
| 4 | Architecture | architecture | yes |
| 5 | Planning | plan | no |
| 6 | Execution | wave-execute | yes |
| 7 | Review | multi-review | no |
| 8 | Archive | archive | no |

### Feature
| # | Leg | Step | Checkpoint |
|---|---|---|---|
| 1 | Codebase Map | codebase-map | no |
| 2 | Specification | delta-spec-add | yes |
| 3 | Planning | plan | no |
| 4 | Execution | wave-execute | yes |
| 5 | Review | multi-review | no |
| 6 | Archive | archive | no |

### Change
| # | Leg | Step | Checkpoint |
|---|---|---|---|
| 1 | Impact Analysis | impact-analysis | no |
| 2 | Specification | delta-spec-mod | yes |
| 3 | Planning | plan | no |
| 4 | Execution | sequential-execute | yes |
| 5 | Review | multi-review + regression-review | no |
| 6 | Archive | archive | no |

### Bug Fix
| # | Leg | Step | Checkpoint |
|---|---|---|---|
| 1 | Reproduce | reproduce | no |
| 2 | Root Cause | root-cause | yes |
| 3 | Fix | targeted-fix | no |
| 4 | Verify | verify-suite | no |

### Troubleshoot
| # | Leg | Step | Checkpoint |
|---|---|---|---|
| 1 | Symptom Triage | symptom-triage | no |
| 2 | Hypothesis Tree | hypothesis-tree | yes |
| 3 | Investigation | investigate-domain | yes |
| 4 | Diagnosis | diagnosis-report | no |
| 5 | Remediation | guided-remediation | no |

### Quick Task
| # | Leg | Step | Checkpoint |
|---|---|---|---|
| 1 | Execute | inline-execute | no |
| 2 | Self-Review | self-review | no |

### Exploration
| # | Leg | Step | Checkpoint |
|---|---|---|---|
| 1 | Explore | freeform-execute | no |
| 2 | Findings | capture-findings | no |

## Execution Modes

- **parallel** -- Tasks grouped into dependency waves. Independent tasks run concurrently via subagents (wave-execute).
- **sequential** -- Tasks run one at a time via subagents (sequential-execute). Safer for modifications with cascading effects.
- **inline** -- Direct execution in the current context. No subagents spawned.
- **interactive** -- Conversational. Noru guides, user provides observations and data.

## Checkpoint Behavior

Checkpoints save full state to `.noru/checkpoints/`. They happen:
- Automatically at legs marked `checkpoint: true` in the track definition
- Manually via `/noru:checkpoint`
- On track cancellation (preserves work)

All leg boundaries trigger a transition prompt, but only marked legs persist a checkpoint file.
