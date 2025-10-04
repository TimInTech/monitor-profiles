#!/usr/bin/env bash
set -euo pipefail
# Launcher: ensure monitors_menu.sh exists and is executable, then run it.
MENU="$HOME/apps/monitor-profiles/bin/monitors_menu.sh"
notify() { command -v kdialog >/dev/null && kdialog --error "$1" || echo "$1"; }

if [ ! -f "$MENU" ]; then
  notify "Monitor-Umschalter: Datei fehlt: $MENU"
  exit 1
fi

if [ ! -x "$MENU" ]; then
  # try to set executable bit locally; this fails if permissions don't allow it
  chmod +x "$MENU" 2>/dev/null || true
  if [ ! -x "$MENU" ]; then
    notify "Monitor-Umschalter: $MENU ist nicht ausführbar (rechte fehlen)."
    exit 1
  fi
fi

exec "$MENU" "$@"
