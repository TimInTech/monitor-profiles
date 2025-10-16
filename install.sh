#!/usr/bin/env bash
set -euo pipefail

# Idempotent installer for monitor profiles controller

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPS_DIR="$HOME/.local/share/applications"
CONTROLLER="$HOME/.local/bin/monitors-mode.sh"

echo "Installing monitor profiles controller..."

# Ensure directories exist
mkdir -p "$HOME/.local/bin" "$APPS_DIR"

echo "Installing controller and wrappers..."
cp "$REPO_DIR/bin/monitors-mode.sh" "$HOME/.local/bin/"
cp "$REPO_DIR/bin/reset-monitors.sh" "$HOME/.local/bin/"
cp "$REPO_DIR/bin/triple-aoc.sh" "$HOME/.local/bin/"

# Ensure main controller exists now
if [[ ! -f "$CONTROLLER" ]]; then
    echo "Error: Main controller missing after copy: $CONTROLLER"
    exit 1
fi

# Install desktop files
echo "Installing desktop files to $APPS_DIR..."
cp "$REPO_DIR/applications/monitor-menu.desktop" "$APPS_DIR/"
cp "$REPO_DIR/applications/monitor-triple-aoc.desktop" "$APPS_DIR/"
cp "$REPO_DIR/applications/monitor-reset.desktop" "$APPS_DIR/"

# Make scripts executable
chmod +x "$HOME/.local/bin/monitors-mode.sh" "$HOME/.local/bin/reset-monitors.sh" "$HOME/.local/bin/triple-aoc.sh"
chmod +x "$REPO_DIR/bin/monitors_menu_launcher.sh"

# Mark desktop files as executable (trusted)
chmod +x "$APPS_DIR/monitor-menu.desktop" || true
chmod +x "$APPS_DIR/monitor-triple-aoc.desktop" || true
chmod +x "$APPS_DIR/monitor-reset.desktop" || true

# Refresh application menu
echo "Refreshing application menu..."
if command -v kbuildsycoca6 >/dev/null; then
    kbuildsycoca6
else
    echo "Warning: kbuildsycoca6 not found, application menu may not update immediately"
fi

USER_SYSTEMD_DIR="$HOME/.config/systemd/user"
mkdir -p "$USER_SYSTEMD_DIR"
cp "$REPO_DIR/systemd/monitors-reset.service" "$USER_SYSTEMD_DIR/"

# Reload systemd user services
echo "Reloading systemd user services..."
if command -v systemctl >/dev/null; then
    systemctl --user daemon-reload || true
else
    echo "Warning: systemctl not found, systemd services not reloaded"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Validation commands:"
echo "  # Test controller"
echo "  KS_BIN=echo ~/.local/bin/monitors-mode.sh triple"
echo ""
echo "  # Test menu launcher"
echo "  echo 'triple' | ~/github_repos/monitor-profiles/bin/monitors_menu_launcher.sh"
echo ""
echo "  # Check desktop files"
echo "  ls -la ~/.local/share/applications/monitor-*.desktop"
echo ""
echo "  # Check systemd services"
echo "  systemctl --user list-unit-files | grep monitors"
echo ""
echo "Usage:"
echo "  # Command line"
echo "  ~/.local/bin/monitors-mode.sh triple --primary DP-3"
echo "  ~/.local/bin/monitors-mode.sh quad --primary DP-3"
echo "  ~/.local/bin/monitors-mode.sh single dp1|dp2|dp3|dp4"
echo "  ~/.local/bin/monitors-mode.sh reset [triple|quad]"
echo ""
echo "  # GUI (search for 'Monitor' in application menu)"
echo "  # Or run: ~/github_repos/monitor-profiles/bin/monitors_menu_launcher.sh"
echo ""
echo "  # Auto-enable triple mode on login:"
echo "  systemctl --user enable monitors-triple.service"
echo "  # Manual reset service (optional):"
echo "  systemctl --user enable monitors-reset.service"
