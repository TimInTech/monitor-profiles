#!/usr/bin/env bash
set -euo pipefail
. "$HOME/apps/monitor-profiles/bin/monitors_lib.sh"
wait_ready
# Preferred order of fallbacks (avoid DP-2 portrait): DP-3, DP-4, DP-1, then DP-2 as last resort
for out in DP-3 DP-4 DP-1 DP-2; do
  if is_connected "$out"; then
    case "$out" in
      DP-3)
        kscreen-doctor \
          output.DP-1.disable output.DP-2.disable output.DP-4.disable \
          output.DP-3.enable output.DP-3.mode.1920x1080@75 output.DP-3.position.0,0 output.DP-3.primary
        ;;
      DP-4)
        kscreen-doctor \
          output.DP-1.disable output.DP-2.disable output.DP-3.disable \
          output.DP-4.enable output.DP-4.mode.1920x1080@60 output.DP-4.position.0,0 output.DP-4.primary
        ;;
      DP-1)
        kscreen-doctor \
          output.DP-2.disable output.DP-3.disable output.DP-4.disable \
          output.DP-1.enable output.DP-1.mode.1920x1080@60 output.DP-1.position.0,0 output.DP-1.primary
        ;;
      DP-2)
        # last resort: portrait monitor
        kscreen-doctor \
          output.DP-1.disable output.DP-3.disable output.DP-4.disable \
          output.DP-2.enable output.DP-2.mode.1920x1080@75 output.DP-2.position.0,0 output.DP-2.primary
        ;;
    esac
    terra_session_stop || true
    start_revert_timer
    notify_ "Fallback: $out aktiv"
    exit 0
  fi
done
echo "Kein Monitor gefunden"
exit 1
