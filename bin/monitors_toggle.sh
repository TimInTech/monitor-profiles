#!/usr/bin/env bash
set -euo pipefail
. "$HOME/apps/monitor-profiles/bin/monitors_lib.sh"
wait_ready
# Grobe Erkennung reicht: wenn DP-3 und DP-4 aktiv, dann auf DP-2; sonst Triple
if [ "$(is_triple_active)" = "maybe" ]; then
  "$HOME/apps/monitor-profiles/bin/monitors_only_dp2.sh"
else
  "$HOME/apps/monitor-profiles/bin/monitors_triple.sh"
fi
