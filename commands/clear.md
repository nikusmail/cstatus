---
description: Remove all done tasks from the board
argument-hint: 
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/bin/cstatus:*)
---
!`${CLAUDE_PLUGIN_ROOT}/bin/cstatus task clear-done && ${CLAUDE_PLUGIN_ROOT}/bin/cstatus task ls`

List the remaining tasks.
