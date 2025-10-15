#!/usr/bin/env bash
set -euo pipefail
CTL="$HOME/.local/bin/monitors-mode.sh"
notify(){ command -v kdialog >/dev/null && nohup kdialog --passivepopup "$1" 3 >/dev/null 2>&1 || echo "$1"; }
[ -x "$CTL" ] || { notify "Controller fehlt: $CTL"; exit 1; }
choice=$(kdialog --menu "Monitor-Layout wählen:" \
  "quad" "Quad Mode (DP-1+DP-4+DP-3+DP-2)" \
  "triple" "AOC Triple (DP-4+DP-3+DP-2)" \
  "aoc-left" "Nur DP-4 (Links)" \
  "aoc-mid" "Nur DP-3 (Mitte)" \
  "aoc-right" "Nur DP-2 (Rechts)" \
  "dp1" "Nur DP-1" \
  "reset" "Reset (alle aus, dann Triple)" 2>/dev/null || exit 0)
case "$choice" in
  quad)      notify "Quad aktivieren…";       exec "$CTL" quad --primary DP-3 ;;
  triple)    notify "Triple aktivieren…";     exec "$CTL" triple --primary DP-3 ;;
  aoc-left)  notify "Nur DP-4…";             exec "$CTL" single dp4 ;;
  aoc-mid)   notify "Nur DP-3…";             exec "$CTL" single dp3 ;;
  aoc-right) notify "Nur DP-2 (Hochkant)…";  exec "$CTL" single dp2 ;;
  dp1)       notify "Nur DP-1…";             exec "$CTL" single dp1 ;;
  reset)     notify "Setze Monitore zurück…"; exec "$CTL" reset triple ;;
esac
