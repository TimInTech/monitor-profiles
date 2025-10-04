# Copilot Instructions: Monitor Profiles

## Project Overview
This is a KDE/KScreen monitor configuration management system for a specific triple-monitor setup. The system provides safe monitor switching with automatic failsafe mechanisms and special "Terra-only" power management modes.

## Architecture

### Core Components
- **`bin/monitors_lib.sh`**: Shared library functions for KScreen interaction, systemd service management, and user notifications
- **Profile Scripts** (`monitors_*.sh`): Individual monitor configuration implementations
- **SystemD Services**: Timer-based failsafe and power management automation
- **Desktop Integration**: KDialog-based menu system and .desktop launcher

### Monitor Layout Definitions
- **Triple Layout (Default)**: DP-4 (left), DP-3 (center, primary), DP-2 (right); DP-1 disabled
- **DP-1 Only**: Falls back to DP-2 if DP-1 not connected
- **DP-2 Only**: Emergency/fallback profile
- **Toggle Mode**: Auto-detects current state and switches between Triple and DP-2

## Key Patterns

### KScreen Integration
All scripts use `kscreen-doctor` for monitor configuration. Essential patterns:
```bash
# Always wait for KScreen readiness
wait_ready
# Check connection status before configuration
is_connected "DP-1" 
# Apply configuration with specific geometry
kscreen-doctor output.DP-3.position.1920,260 output.DP-3.primary
```

### Failsafe Mechanisms
- **Auto-revert Timer**: 2-minute systemd timer automatically reverts to triple layout
- **Connection Fallback**: DP-1 profile falls back to DP-2 if monitor not connected
- Scripts manage their own timers: `start_revert_timer()` / `cancel_revert_timer()`

### SystemD Service Lifecycle
Services follow specific patterns:
- **Revert Timer**: Started by non-standard profiles, stopped by standard profile
- **Terra Session**: Inhibits system idle/sleep using `systemd-inhibit`
- **Terra Off Timer**: 90-minute timer to power off displays in Terra mode

## Development Workflows

### Testing Monitor Configurations
```bash
# Check current monitor status
kscreen-doctor -o
# Test individual profiles
./bin/monitors_triple.sh
# Check service status
systemctl --user status monitors-revert.timer
```

### Recovery Commands
When system gets stuck:
```bash
systemctl --user stop monitors-revert.timer monitors-terra-*
~/apps/monitor-profiles/bin/monitors_triple.sh
systemctl --user enable --now monitors-triple.service
```

## Project-Specific Conventions

### Error Handling
- All scripts use `set -euo pipefail` for strict error handling
- Library functions return proper exit codes for conditional logic
- Systemd operations include `|| true` to prevent script failures

### Hardcoded Paths
Scripts assume installation in `~/apps/monitor-profiles/` and reference absolute paths. When modifying, update all path references consistently.

### Notification System
Uses `kdialog --passivepopup` for user feedback with graceful fallback if not available.

## Dependencies & Requirements
- **KDE Plasma 6+**: Required for KWin powerOffMonitors D-Bus method
- **Wayland**: System designed for Wayland display server
- **kdialog**: For user notifications and menu interface
- **systemd --user**: For timer and service management

## Critical Integration Points
- **KScreen Detection**: Monitor port names (DP-1, DP-2, etc.) can change on cable reconnection
- **Geometry Matching**: `is_triple_active()` uses specific pixel coordinates to detect layout state
- **Service Dependencies**: Terra mode requires coordination between session blocker and display timer services

## Common Gotchas
- Port names are hardware-dependent and may change between reboots
- Scripts only modify position/mode, not rotation settings
- systemd --user services require proper user session for D-Bus access
- Timer services must be explicitly stopped before starting conflicting profiles