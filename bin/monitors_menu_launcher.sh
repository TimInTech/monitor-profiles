#!/usr/bin/env bash
set -euo pipefail
CTL="$HOME/.local/bin/monitors-mode.sh"
notify(){ command -v kdialog >/dev/null && nohup kdialog --passivepopup "$1" 3 >/dev/null 2>&1 || echo "$1"; }
[ -x "$CTL" ] || { notify "Controller fehlt: $CTL"; exit 1; }
choice=$(kdialog --menu "Monitor-Layout wählen:" \
  "terra" "Nur Terra (DP-1)" \
  "triple" "AOC Triple (DP-4+DP-3+DP-2)" \
  "aoc-left" "Nur DP-4 (Links)" \
  "aoc-mid" "Nur DP-3 (Mitte)" \
  "aoc-right" "Nur DP-2 (Rechts)" 2>/dev/null || exit 0)
case "$choice" in
  terra)  notify "Aktiviere Terra…";  exec "$CTL" single terra ;;
  triple) notify "Aktiviere Triple…"; exec "$CTL" triple --primary DP-3 ;;
  aoc-left)  notify "Aktiviere DP-4…"; exec "$CTL" single aoc-left ;;
  aoc-mid)   notify "Aktiviere DP-3…"; exec "$CTL" single aoc-mid ;;
  aoc-right) notify "Aktiviere DP-2…"; exec "$CTL" single aoc-right ;;
esac
