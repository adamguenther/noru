# noru

**noru** (NOR-oo) -- from Japanese 乗る, to board a route

Describe what you're doing. Noru routes to the right workflow.

---

## How It Works

One entry point: `/noru:go "fix the login bug"`. Noru reads your intent, picks the right track, and scales ceremony to match the work. Small tasks get zero overhead. Complex work gets full planning. You don't choose -- the router does.

## Tracks

Noru has seven tracks. Each defines a workflow shape matched to the type of work.

| Track | What it's for |
|---|---|
| **Quick Task** | Small, scoped work under 30 minutes -- no planning overhead |
| **Bug Fix** | The fault is in your code -- reproduce, root-cause, fix, verify |
| **Change** | Modify existing behavior -- refactor, migrate, update |
| **Feature** | Add new capability to an existing codebase |
| **New Project** | Greenfield -- full spec, full plan, parallel execution |
| **Troubleshoot** | You don't know where the fault is yet -- investigate first |
| **Exploration** | Spikes, prototypes, feasibility -- findings over code |

## Commands

| Command | Purpose |
|---|---|
| `/noru:go` | Auto-route by description (the 90% case) |
| `/noru:new` | New Project track |
| `/noru:feature` | Feature track |
| `/noru:change` | Change track |
| `/noru:fix` | Bug Fix track |
| `/noru:troubleshoot` | Troubleshoot track |
| `/noru:quick` | Quick Task track |
| `/noru:explore` | Exploration track |
| `/noru:status` | Current track, position, next step |
| `/noru:promote` | Transfer work to a different track |
| `/noru:checkpoint` | Save state (automatic at leg boundaries) |
| `/noru:resume` | Pick up from last checkpoint |
| `/noru:pause` | Park work with handoff context |

12 commands. Seven are track shortcuts most users won't need because `/noru:go` auto-routes. A user who learns `/noru:go`, `/noru:status`, and `/noru:resume` has 95% of the functionality.

## Install

```bash
# Via npx (recommended)
npx noru

# Or install globally, then run
npm install -g noru
noru install

# Or manual
git clone https://github.com/adamguenther/noru.git
cd noru && node bin/install.js install
```

The installer symlinks noru's commands into your Claude Code configuration and sets up session hooks for personality injection. Run `npx noru` with no arguments for interactive mode.

## Quick Start

```
> /noru:go "fix the login bug"

Track: Bug Fix
Scope: auth/login.ts -- token refresh not handling expired sessions.
Next: reproduce. Proceed?
```

That's it. Noru asked what you're doing, routed to Bug Fix, scoped the work, and is ready to move. No menus, no configuration, no ceremony you didn't need.

## Architecture

```
commands/    Slash commands -- the user-facing entry points
tracks/      Track definitions -- the 7 workflow shapes
steps/       Step definitions -- the legs within each track
agents/      Agent definitions -- the workers that execute steps
soul/        Voice, personality, principles -- injected everywhere
references/  Shared knowledge files agents can pull from
hooks/       Lifecycle hooks for extensibility
templates/   Output templates for specs, plans, findings
```

## License

MIT
