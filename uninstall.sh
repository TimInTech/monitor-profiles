#!/usr/bin/env bash
set -euo pipefail

# Uninstaller for monitor profiles controller

APPS_DIR="$HOME/.local/share/applications"

echo "Uninstalling monitor profiles controller..."

# Remove desktop files
echo "Removing desktop files from $APPS_DIR..."
rm -f "$APPS_DIR/monitor-menu.desktop"
rm -f "$APPS_DIR/monitor-triple-aoc.desktop"

# Refresh application menu
echo "Refreshing application menu..."
if command -v kbuildsycoca6 >/dev/null; then
    kbuildsycoca6
else
    echo "Warning: kbuildsycoca6 not found, application menu may not update immediately"
fi

echo ""
echo "Uninstallation complete!"
echo ""
echo "Manual cleanup (if desired):"
echo "  # Remove controller and wrappers"
echo "  rm -f ~/.local/bin/monitors-mode.sh"
echo "  rm -f ~/.local/bin/triple-aoc.sh"
echo ""
echo "  # Disable and remove systemd services"
echo "  systemctl --user disable monitors-triple.service"
echo "  systemctl --user stop monitors-triple.service"
echo "  # Note: Service files remain in repository for future use"
echo ""
echo "  # Remove entire repository"
echo "  rm -rf ~/github_repos/monitor-profiles"
