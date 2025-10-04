# monitor-profiles

KDE/KScreen monitor configuration management system for triple-monitor setups with automatic failsafe mechanisms and power management modes.

## Features

- **Multiple Monitor Profiles**: Triple-monitor layout, single-monitor modes, and automatic toggle
- **Automatic Failsafe**: 2-minute timer to revert to safe configuration
- **Terra-Only Mode**: Special power management mode with display timeout
- **Desktop Integration**: KDialog menu system and .desktop launcher
- **Non-blocking Notifications**: Safe systemd service integration

## Quick Start

### Installation

1. Clone or copy this repository to `~/apps/monitor-profiles/`
2. Ensure all scripts in `bin/` are executable (use `scripts/set-exec-bits.sh` if needed)
3. Copy `share/applications/monitor-profiles.desktop` to `~/.local/share/applications/` for desktop integration

### Usage

Launch the menu:
```bash
~/apps/monitor-profiles/bin/monitors_menu_launcher.sh
```

Or use specific profiles directly:
```bash
~/apps/monitor-profiles/bin/monitors_triple.sh    # Standard triple-monitor layout
~/apps/monitor-profiles/bin/monitors_only_dp2.sh  # Emergency single-monitor
~/apps/monitor-profiles/bin/monitors_toggle.sh    # Auto-detect and switch
```

## Project Structure

```
monitor-profiles/
├── bin/                      # Executable scripts
│   ├── monitors_lib.sh       # Core library functions
│   ├── common_functions.sh   # Generic helper functions
│   ├── monitors_*.sh         # Profile implementations
│   ├── monitors_menu*.sh     # Menu system
│   └── smoke_test.sh         # Test suite
├── docs/                     # Detailed documentation
├── share/applications/       # Desktop integration files
├── systemd/                  # SystemD service/timer units
└── scripts/                  # Maintenance scripts
```

## Development

### Testing

Run smoke tests (dry-run mode):
```bash
bash bin/smoke_test.sh
```

### CI/CD

GitHub Actions workflow validates:
- Bash syntax checking (`bash -n`)
- Smoke test execution
- Script structure verification

## Requirements

- **KDE Plasma 6+**: Required for KWin powerOffMonitors D-Bus method
- **Wayland**: System designed for Wayland display server
- **kdialog**: For user notifications and menu interface
- **systemd --user**: For timer and service management

## Documentation

See [docs/README.md](docs/README.md) for detailed documentation including:
- Complete profile descriptions
- Hardware-specific geometry configurations
- SystemD service integration
- Recovery procedures
- Common issues and troubleshooting

## License

See [LICENSE](LICENSE) file for details.
