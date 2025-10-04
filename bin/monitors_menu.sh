#!/usr/bin/env bash
set -euo pipefail
choice=$(kdialog --title "Monitor-Umschalter" --menu "Wähle Layout" \
  1 "Dreier-Layout (Standard)" \
  2 "Nur DP-1 (falls verbunden, sonst DP-2)" \
  3 "Nur DP-2" \
  4 "Umschalten (Auto)")
case "$choice" in
  1) ~/apps/monitor-profiles/bin/monitors_triple.sh ;;
  2) ~/apps/monitor-profiles/bin/monitors_only_dp1.sh ;;
  3) ~/apps/monitor-profiles/bin/monitors_only_dp2.sh ;;
  4) ~/apps/monitor-profiles/bin/monitors_toggle.sh ;;
  *) exit 0 ;;
esac
