---
name: board
description: The user's desktop task board (cstatus). Use when you take on a user request that takes more than a couple of minutes, make visible progress, need something from the user (an answer, a merge, a deploy, a decision), get blocked, or finish; and when asked "show/update the board", "what's in progress". Command: `cstatus task …`.
---

# Task board on the user's screen

The user runs several Claude Code sessions and watches them on a board (a conky panel on the desktop and/or `cstatus render --plain`
in a terminal). Sessions, their todo progress and workflow agents are shown automatically by the plugin hooks.
**The task list — the user's bigger requests with a percent — is yours to keep.**

The CLI is `cstatus` (on PATH via the plugin's `bin/`; if not, use `${CLAUDE_PLUGIN_ROOT}/bin/cstatus`).

## When to update

- You take a user request (more than a couple of minutes of work) → `set … run` — in your very first step, not at the end.
- A visible step (phase done, PR opened, tests green, agents finished) → update percent and note.
- You need the user (answer, merge, deploy, decision) → `wait` with a note saying exactly what, **and a ready command** when there is one.
- You can't continue for reasons outside the user → `block`.
- Done and verified → `done` (hidden after 24 h).

Percent is an honest share of the work done, not time. Note ≤ 40 chars. Write title/note in the user's language.

## Commands

```bash
cstatus task set <id> "<title ≤56>" <0-100> [run|wait|done|block] "<note>" ["<command for the user>"]
cstatus task done <id>
cstatus task rm <id>
cstatus task ls
cstatus render --plain
```

`id` — short, latin, stable for the task (`api-auth`, `release-1-2`). The same id from different sessions is one row. Check
`cstatus task ls` before `set` to avoid duplicates.

## Commands the user runs (`cstatus run N`)

The user runs the next step themselves with `cstatus run N` (it asks y/N). So a `wait` task should carry a ready command:
- waiting for a merge → `"gh pr merge 123 --squash"` (if the title/note contains `#123` and the PR is open in the repo where the task
  was created, `run` offers the merge by itself and shows the PR title and URL first);
- waiting for a deploy → the exact deploy command for that project (explicit host/env; never a script that commits everything);
- an answer, a decision, a message to a person → no command (`cstatus copy N` gives the note text).
After a successful `run` the note becomes "merged PR #…/done" and the command is removed — set the next step.

If `cstatus` is not available, do nothing about the board and don't let it get in the way of the actual work.
