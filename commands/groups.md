---
description: Task groups in priority order; with an argument sets the order ("A,B,C")
argument-hint: "[Group1,Group2,…]"
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/bin/cstatus:*)
---
!`${CLAUDE_PLUGIN_ROOT}/bin/cstatus task groups "$ARGUMENTS"`

Show the group order above as is (1 = highest priority). If it is empty, say that groups are not set and how to set them:
`/cstatus:groups Frontend,Backend,Ops` (or `cstatus task groups "…"` in a shell), and `CB_GROUP=<Group> cstatus task set …` for tasks.
