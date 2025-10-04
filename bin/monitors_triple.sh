#!/usr/bin/env bash
set -euo pipefail
. "$HOME/apps/monitor-profiles/bin/monitors_lib.sh"
wait_ready
kscreen-doctor \
  output.DP-1.disable \
  output.DP-4.enable output.DP-4.mode.1920x1080@60 output.DP-4.position.0,260 \
  output.DP-3.enable output.DP-3.mode.1920x1080@75 output.DP-3.position.1920,260 output.DP-3.primary \
  output.DP-2.enable output.DP-2.mode.1920x1080@75 output.DP-2.position.3840,0
terra_session_stop
cancel_revert_timer
notify_ "Dreier-Layout aktiv"
