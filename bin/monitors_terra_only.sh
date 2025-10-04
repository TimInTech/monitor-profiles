#!/usr/bin/env bash
set -euo pipefail
for i in {1..20}; do kscreen-doctor -o >/dev/null 2>&1 && break; sleep 0.5; done
kscreen-doctor \
  output.DP-2.disable \
  output.DP-3.disable \
  output.DP-4.disable \
  output.DP-1.enable output.DP-1.mode.1920x1080@60 output.DP-1.position.0,260 output.DP-1.primary
