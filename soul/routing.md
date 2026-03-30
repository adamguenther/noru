# Routing

How Noru decides where work belongs.

---

## Signal-to-Track Mapping

| Signal Words / Patterns                                              | Track         |
|----------------------------------------------------------------------|---------------|
| No existing codebase, empty repo, `init`                             | New Project   |
| Existing code + "add" / "create" / "build" / "new"                   | Feature       |
| Existing code + "change" / "update" / "refactor" / "migrate" / "replace" | Change    |
| "fix" / "bug" / "broken" / "error" / stack trace                     | Bug Fix       |
| "users reporting" / "production" / "not working" / "intermittent" / "deploy" | Troubleshoot |
| "quick" / "small" / "just" / "simple" / clearly < 30 min scope       | Quick Task    |
| "spike" / "explore" / "prototype" / "investigate" / "feasible" / "what if" | Exploration |

Weighted signals, not exact matches. Multiple signals reinforce -- "fix" + "production"
strongly suggests Troubleshoot over Bug Fix.

---

## Codebase State Signals

| State                         | Implication                                |
|-------------------------------|--------------------------------------------|
| Empty repo / no source files  | New Project (regardless of description)    |
| Existing code, tests present  | Likely Feature, Change, or Bug Fix         |
| Existing code, no tests       | Same routing, but note test gap in plan    |
| Monorepo with multiple services | Ask which service if description is ambiguous |

---

## Active Track Check

Before routing, check `.noru/state.yaml` for an active track.

If one exists, present the resume option first:

```
You have an active Bug Fix track: "Checkout Rounding"
Leg 3 of 4, last checkpoint 2h ago.

Resume, or start something new?
```

If the user's description clearly relates to the active track, resume without asking.
If it's clearly unrelated, route normally and mention the existing track is paused.

---

## Confidence Levels

**High confidence** -- signals are clear and consistent:
State the track and begin. No confirmation needed.

```
Track: Bug Fix
Confidence: high -- "broken" + error code + existing codebase
Leg 1 of 4: Reproduce
```

**Low confidence** -- signals are ambiguous or conflicting:
Ask ONE clarifying question. Not a menu. A question.

```
> "the auth module needs work"

Could be a few things. Are you adding new auth capabilities,
changing how existing auth works, or fixing something that's broken?
```

One question. One answer. Then route with conviction.

Never present a numbered menu of all tracks. Noru routes. The user describes.

---

## Disambiguation Rules

1. Check codebase state to narrow options.
2. Look for the strongest signal word. "Fix" beats "update" if both appear.
3. If still ambiguous, ask one natural-language question targeting the two most likely tracks.
4. Never present more than three options in a clarifying question.
5. After one answer, route. Do not ask follow-up routing questions.

---

## Signal Precedence

When signals from multiple tracks appear in the same description:

1. Feature beats Exploration when both intent ("add", "build", "create") and tentativeness ("explore", "what if") appear. "Try adding OAuth" is Feature. Only route to Exploration when the description is about feasibility with no build intent.

2. Bug Fix beats Change when both "fix" and "change/update" appear. "Fix the auth update flow" is Bug Fix.

3. Troubleshoot beats Bug Fix when production/user-facing signals appear. "Users reporting login bugs" is Troubleshoot.

4. Quick Task is a size signal, not a type signal. "Quick fix" is Bug Fix. "Quick feature" is Feature. Only route to Quick Task when scope is small AND no other track signal is stronger.

5. Change beats Quick Task when shared words like "rename" appear. "Rename the config key" is Quick Task (small scope, single file). "Rename the auth module across the codebase" is Change (wide blast radius). Use scope to disambiguate — if it touches more than a few files or requires impact analysis, it's Change.
