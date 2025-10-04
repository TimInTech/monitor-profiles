#!/usr/bin/env bash
set -euo pipefail
. "$HOME/apps/monitor-profiles/bin/monitors_lib.sh"
wait_ready
if ! is_connected DP-1; then
  echo "DP-1 nicht verbunden, wechsle auf Fallback (bevorzuge DP-3/DP-4)"
  exec "$HOME/apps/monitor-profiles/bin/monitors_only_fallback.sh"
fi
kscreen-doctor \
  output.DP-2.disable output.DP-3.disable output.DP-4.disable \
  output.DP-1.enable output.DP-1.mode.1920x1080@60 output.DP-1.position.0,0 output.DP-1.primary
terra_session_start
start_revert_timer
notify_ "Nur DP-1 aktiv"
