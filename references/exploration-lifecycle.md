# Exploration Lifecycle

Exploration is for learning, not shipping. It stays lightweight, but it still
needs enough structure that the findings can be trusted and promoted into real
work.

## Required Frame

Before changing code, capture four things:

- **Question:** What are we trying to learn?
- **Scope:** What areas are in or out?
- **Constraints:** Timebox, tools, data, and safety limits.
- **Stop condition:** What evidence is enough to stop exploring?

Keep this to a few lines. Do not turn it into a spec.

## Working Artifacts

Use:

```text
.noru/explorations/[topic-slug]/log.md
.noru/findings/[topic-slug]-[YYYY-MM-DD].md
```

The log is working memory. The findings document is the deliverable.

## Experiment Log

Every meaningful experiment gets a short entry:

```markdown
## Experiment: [name]
- Intent: [what this checks]
- Change: [what was tried]
- Evidence: [command output, screenshot, file path, benchmark, trace, or observation]
- Result: [worked | failed | inconclusive]
- Next: [follow-up or stop]
```

Evidence can be lightweight, but it must be concrete. A conclusion without evidence
does not go into findings.

## Branch Rules

- Use `explore/[topic-slug]-[YYYY-MM-DD]`.
- Check current branch and `git status --short` before creating the branch.
- If the worktree is dirty, preserve it. Do not discard or reset.
- The branch is throwaway and is not merged.
- Commits are optional. If made, they are checkpoints, not production history.

## Promotion Rules

Promote when the exploration crosses out of learning:

- Buildable new capability -> Feature.
- Existing behavior needs to change -> Change.
- Reproduced code bug -> Bug Fix.
- Fault domain is unclear or operational -> Troubleshoot.
- Empty-repo product idea is ready to build -> New Project.

Carry forward:
- Findings file path.
- Experiment log path.
- Evidence summary.
- Recommended next track.

Do not carry forward throwaway code as production implementation. Use it as a
reference only.
