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
 ◐ [1] Release 1.4 to the stores
   █████████████████████░░░  90%  needs you: merge #42, then say go
 ◐ [2] New pricing page
   ███████░░░░░░░░░░░░░░░░░  30%  needs you: pick plan names
 ▶ API: login with magic links
   ██████████████░░░░░░░░░░  60%  now: tests green, writing docs
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
| Manually | `cstatus task set ID "Title" 40 wait "note" "command"` · `task done/rm/ls/clear-done` |

`cstatus run N` runs the task's command after you confirm. If a waiting task mentions an open PR (`#123`) of the repo where the
task was created, it offers to merge it — and shows the PR title and URL before asking.

Settings: `cstatus lang ru|en` (default: from your locale); panel limits `CB_MAX_SESSIONS` (4), `CB_MAX_AGENTS` (2), tasks fill
the remaining height (`CB_HEIGHT`). State lives in `~/.local/state/claude-board/` — local files only, no network.

## Privacy and safety

- Everything stays on your machine. The hooks write your last prompt (first 90 chars), tool names and session state to
  `~/.local/state/claude-board/`. Nothing is sent anywhere.
- `cstatus run` never executes without your `y`, and refuses `@…`/`http…` notes that are not shell commands.
- Uninstall: `/plugin uninstall cstatus@cstatus` and `install-conky.sh --uninstall`.

## License

MIT
