#!/usr/bin/env bash
# cstatus — desktop part: `cstatus`/`cs` on PATH, bash Tab completion, conky panels (board + cheat sheet), autostart.
# The Claude Code part (hooks, skill, /cstatus:* commands) comes from the plugin: /plugin install cstatus@cstatus
#   ./install-conky.sh [--head N] [--gap-x PX] [--lang ru|en] [--no-conky] [--uninstall]
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
HEAD=0; GAPX=""; CONKY=1; UNINSTALL=0; LANGSET=""
while [ $# -gt 0 ]; do case "$1" in
  --head) HEAD="$2"; shift 2;; --gap-x) GAPX="$2"; shift 2;; --lang) LANGSET="$2"; shift 2;;
  --no-conky) CONKY=0; shift;; --uninstall) UNINSTALL=1; shift;;
  -h|--help) sed -n '2,5p' "$0"; exit 0;; *) echo "unknown flag $1" >&2; exit 2;; esac; done

command -v jq >/dev/null || { echo "jq is required: sudo apt install jq" >&2; exit 1; }
BIN="$HOME/.local/bin/cstatus"
CONF="$HOME/.config/conky/cstatus-board.conf"
CHEAT="$HOME/.config/conky/cstatus-cheat.conf"
DESKTOP="$HOME/.config/autostart/cstatus-board.desktop"
COMP="${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion/completions"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/claude-board"

stop_panels() { local p; for p in $(pgrep -x conky); do tr '\0' ' ' </proc/$p/cmdline | grep -q -e "$CONF" -e "$CHEAT" && kill "$p"; done; return 0; }

if [ $UNINSTALL = 1 ]; then
  stop_panels; rm -f "$BIN" "$HOME/.local/bin/cs" "$CONF" "$CHEAT" "$DESKTOP" "$COMP/cstatus" "$COMP/cs"
  echo "Removed. Board state kept in $STATE. Claude Code part: /plugin uninstall cstatus@cstatus"; exit 0
fi

mkdir -p "$HOME/.local/bin" "$COMP" "$STATE"
install -m 755 "$HERE/bin/cstatus" "$BIN"; ln -sf "$BIN" "$HOME/.local/bin/cs"
cp "$HERE/completions/cstatus.bash" "$COMP/cstatus"; ln -sf cstatus "$COMP/cs"
[ -n "$LANGSET" ] && echo "$LANGSET" >"$STATE/lang"
echo "✓ cstatus + cs in ~/.local/bin, Tab completion (new terminals)"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) echo "  note: add ~/.local/bin to PATH";; esac

if [ $CONKY = 1 ]; then
  command -v conky >/dev/null || { echo "conky not found (sudo apt install conky-all) — use: cstatus render --plain"; exit 0; }
  if [ -z "$GAPX" ]; then if [ -f "$HOME/.config/conky/conky.conf" ] || [ -f "$HOME/.conkyrc" ]; then GAPX=580; else GAPX=40; fi; fi
  SCRH=$(xrandr --query 2>/dev/null | grep ' connected' | sed -n "$((HEAD + 1))p" | grep -o '[0-9]*x[0-9]*+' | head -1 | sed 's/.*x//; s/+//'); SCRH=${SCRH:-1080}
  BH=$((SCRH - 80))
  mkdir -p "$(dirname "$CONF")" "$(dirname "$DESKTOP")"
  sed "s|@HEAD@|$HEAD|; s|@GAPX@|$GAPX|; s|@BIN@ render|CB_HEIGHT=$((BH - 60)) $BIN render|; s|@HEIGHT@|$BH|; s|@BIN@|$BIN|" "$HERE/conky/board.conf.template" >"$CONF"
  sed "s|@HEAD@|$HEAD|; s|@GAPX@|$((GAPX + 840))|; s|@BIN@|$BIN|; s|minimum_height = @HEIGHT@,||" "$HERE/conky/cheat.conf.template" >"$CHEAT"
  cat >"$DESKTOP" <<EOD
[Desktop Entry]
Type=Application
Name=cstatus board (conky)
Exec=sh -c "sleep 10; pgrep -fx 'conky -c $CONF --daemonize' >/dev/null || conky -c $CONF --daemonize; pgrep -fx 'conky -c $CHEAT --daemonize' >/dev/null || conky -c $CHEAT --daemonize"
X-GNOME-Autostart-enabled=true
EOD
  stop_panels
  conky -c "$CHEAT" --daemonize >/dev/null 2>&1 || true
  conky -c "$CONF" --daemonize >/dev/null 2>&1 && echo "✓ conky panels started (monitor $HEAD, right offset $GAPX px), autostart on login"
  echo "  if another script runs 'killall conky', add to it: conky -c $CONF --daemonize; conky -c $CHEAT --daemonize"
fi
echo "Done. Sessions appear after their next prompt."
