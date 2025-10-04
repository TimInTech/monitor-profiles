#!/usr/bin/env bash
set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions for dry-run support
source "${SCRIPT_DIR}/common_functions.sh"

# Handle dry-run mode
if is_dry_run; then
  echo "[DRY-RUN] Would display monitor menu"
  exit 0
fi

# Check if kdialog is available
if ! command -v kdialog >/dev/null 2>&1; then
  echo "Error: kdialog not found. Please install kdialog for menu functionality."
  exit 1
fi

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
