# cstatus — a task board for Claude Code on your desktop

[Русская версия](README.ru.md)

When you run Claude Code in several terminals at once, it is easy to lose track: which session is working, which one is
waiting for your permission, what you still have to merge or decide. **cstatus** puts it all on one board:

- **My tasks** — the bigger requests you gave Claude, with progress and what is needed from you. Claude keeps this list itself
  (a bundled skill tells it when to add and update tasks).
- **Claude sessions** — every session in every terminal: working / needs you / idle, project, branch, your last prompt, todo
  progress, what it is asking for. Comes from hooks — nothing to do.
- **Agents** — subagents and workflows that are running right now, with phase and progress.

It shows on a **conky panel** on a Linux desktop (full monitor height, plus a cheat-sheet panel), and anywhere as
`cstatus render --plain` in a terminal. Interface in **English and Russian**.

```
== MY TASKS ==
 — total 4
 ▌ Frontend
 ◐ [1] ★ Release 1.4 to the stores
   █████████████████████░░░  90%  needs you: merge #42, then say go
 ◐ [2] New pricing page
   ███████░░░░░░░░░░░░░░░░░  30%  needs you: pick plan names
 ▌ Backend
 ▶ API: login with magic links
   ██████████████░░░░░░░░░░  60%  now: tests green, writing docs
 ▌ Ops
 ✔ Fix flaky e2e test
   ████████████████████████ 100%  done: merged

== CLAUDE SESSIONS ==
 ● project: billing  working: editing a file · 0s ago
   your prompt: refactor the billing module
```

## Install

In Claude Code:

```
/plugin marketplace add nikusmail/cstatus
/plugin install cstatus@cstatus
```

That adds the hooks, the skill and the `/cstatus:*` commands. Then, for the desktop panels and the `cstatus` / `cs` command in
your shell (Linux, needs `jq`; panels need `conky`):

```
/cstatus:desktop            # or: /cstatus:desktop --lang ru --head 1
```

or from a clone: `git clone https://github.com/nikusmail/cstatus && ./cstatus/install-conky.sh`.

Requirements: `bash`, `jq`, `git`; optional `conky` (X11) for the panels, `gh` for one-key PR merges, `xclip`/`xsel`/`wl-copy`
for copying.

## Use

| Where | What |
|---|---|
| Claude Code | `/cstatus:mine` — what is waiting for you · `/cstatus:board` · `/cstatus:run N` · `/cstatus:close N` · `/cstatus:clear` |
| Shell | `cstatus mine` · `cstatus run N` (asks y/N) · `cstatus close N` · `cstatus render --plain` · `cs <Tab>` |
| Manually | `cstatus task set ID "Title" 40 wait "note" "command"` · `task done ID ["final note"]` · `task rm/ls/clear-done` |
| Groups | `CB_GROUP=Backend cstatus task set …` · `cstatus task group ID "Backend"` · `cstatus task groups "Frontend,Backend,Ops"` · `/cstatus:groups` |
| Priority | `cstatus task important ID [on\|off]` — ★, first within its group |

`cstatus run N` runs the task's command after you confirm. If a waiting task mentions an open PR (`#123`) of the repo where the
task was created, it offers to merge it — and shows the PR title and URL before asking.

Settings: `cstatus lang ru|en` (default: from your locale); panel limits `CB_MAX_SESSIONS` (4), `CB_MAX_AGENTS` (2), tasks fill
the remaining height (`CB_HEIGHT`). State lives in `~/.local/state/claude-board/` — local files only, no network.

### Groups

Tasks can be grouped (by project, team, area — whatever you like). The board prints a header per group, and **the order of the
groups is their priority**:

```bash
cstatus task groups "Frontend,Backend,Ops"   # set the order (no argument — show it)
CB_GROUP=Backend cstatus task set api-auth "API: magic links" 20 run "spec"   # new task in a group
cstatus task group api-auth Frontend          # move a task; "" removes the group
```

- A group set once sticks: later `set` calls without `CB_GROUP` keep it.
- Groups not listed in `task groups` come after the listed ones; tasks without a group come last (shown as "Other").
- Within a group: waiting for you → blocked → in progress → done, then ★ important first, then by percent. The `[N]` numbers
  on the panel match `cstatus mine`.
- No groups configured — the board works as before. The order lives in `~/.local/state/claude-board/groups.json`.

For a second conky column with the tasks that did not fit, render it with `cstatus render --tasks2` and set `CB_SPLIT=1` for
the main panel.

## Changelog

- **1.1.0** — task groups (`CB_GROUP`, `task group`, `task groups`, group order = priority, board grouped by headers),
  ★ important tasks (`task important`), `task done ID "final note"`, optional second task column (`render --tasks2`),
  `/cstatus:groups`, Tab completion for the new commands.
- **1.0.0** — first public release: board, sessions, agents, conky panels, RU/EN.

## Privacy and safety

- Everything stays on your machine. The hooks write your last prompt (first 90 chars), tool names and session state to
  `~/.local/state/claude-board/`. Nothing is sent anywhere.
- `cstatus run` never executes without your `y`, and refuses `@…`/`http…` notes that are not shell commands.
- Uninstall: `/plugin uninstall cstatus@cstatus` and `install-conky.sh --uninstall`.

## License

MIT
