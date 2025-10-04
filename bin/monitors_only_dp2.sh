#!/usr/bin/env bash
set -euo pipefail
. "$HOME/apps/monitor-profiles/bin/monitors_lib.sh"
wait_ready
kscreen-doctor \
  output.DP-1.disable output.DP-3.disable output.DP-4.disable \
  output.DP-2.enable output.DP-2.mode.1920x1080@75 output.DP-2.position.0,0 output.DP-2.primary
terra_session_stop
start_revert_timer
notify_ "Nur DP-2 aktiv"
