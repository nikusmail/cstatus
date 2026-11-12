---
description: Install the desktop part — conky panels, `cstatus`/`cs` on PATH, Tab completion (Linux)
argument-hint: "[--lang ru|en] [--head N] [--no-conky]"
---
Ask the user to confirm, then run this exactly (it writes to ~/.local/bin, ~/.config/conky, ~/.config/autostart; it does not touch Claude settings):

`bash "${CLAUDE_PLUGIN_ROOT}/install-conky.sh" $ARGUMENTS`

Show its output. If conky is missing, tell the user `sudo apt install conky-all jq` (or their distro's package) and that `cstatus render --plain` works without it.
