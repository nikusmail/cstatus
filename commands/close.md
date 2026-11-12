---
description: Mark waiting task N done (see /cstatus:mine)
argument-hint: <N>
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/bin/cstatus:*)
---
!`${CLAUDE_PLUGIN_ROOT}/bin/cstatus close $ARGUMENTS`

Say in one line which task was closed (from the output above).
