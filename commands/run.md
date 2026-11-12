---
description: Do waiting task N from the board (see /cstatus:mine)
argument-hint: <N>
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/bin/cstatus:*)
---
The user asks you to do waiting task #$ARGUMENTS from the board:

!`${CLAUDE_PLUGIN_ROOT}/bin/cstatus copy $ARGUMENTS`

Do what it says (its command or the action in its note), following the project's normal rules: deploys, production writes, money and anything irreversible only if that is exactly what the user asked for. If it is a pull request merge, show the PR title and repo first. When done and verified, run `${CLAUDE_PLUGIN_ROOT}/bin/cstatus close $ARGUMENTS` and report briefly.
