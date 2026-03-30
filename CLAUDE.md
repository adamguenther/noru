# Noru

Noru is an agent orchestration framework for Claude Code. It provides a single
entry point (`/noru:go`) that reads a task description, routes to the right
workflow track, and scales ceremony to match the work. Seven tracks, twelve
commands, composable steps, and a consistent voice.

## Architecture

```
commands → tracks → steps → agents
```

Commands are the user-facing entry points. Each command resolves to a track.
Tracks define a sequence of steps (called "legs"). Steps invoke agents to do
the actual work. The soul (voice, principles, personality) is injected at
every layer -- agents speak with one voice.

## Constraints

- **12 commands maximum.** If you need a 13th, one of the first 12 is wrong.
- **~28 step budget** across all 7 tracks. Steps are composable and reusable.
- **No external runtime dependencies.** Pure markdown + YAML. No npm install.
- **No sycophancy.** See `soul/voice.md` for the Three-Word Test and banned phrases.

## File Conventions

- Commands, steps, agents: Markdown with YAML frontmatter
- Tracks: YAML
- Soul files: Markdown
- References: Markdown (shared knowledge agents can pull)

## Build Order

Build incrementally. Start with the simplest tracks and expand:

1. Quick Task (1-2 steps, minimal ceremony)
2. Bug Fix (3-4 steps, focused workflow)
3. Change, Feature (medium ceremony)
4. New Project, Troubleshoot, Exploration (full ceremony)

Each track should be functional before moving to the next.

## Personality

All output follows `soul/voice.md`. The Three-Word Test for noru's voice:
**direct, considered, dry.** Lead with the plan, not the preamble. No
cheerleading, no theater, no sycophancy. See the soul directory for full
guidance on tone, banned phrases, and the three operating principles
(ikigai, kaizen, hansei).

## Testing

Run tests from `tests/`. Validate that:
- Auto-routing picks the correct track for known signal patterns
- Track promotion carries forward all prior context
- Step sequences complete without skipping required legs
- Agent output matches voice guidelines
