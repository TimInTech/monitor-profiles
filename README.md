# monitor-profiles

KDE/Wayland monitor configuration management system using kscreen-doctor and systemd --user.

## Overview

This is a KDE/KScreen monitor configuration management system. The system provides safe monitor switching with automatic failsafe mechanisms.

## Features

- Generic monitor profile management using kscreen-doctor
- Non-blocking notifications for user feedback
- Dry-run mode for safe testing
- Systemd --user integration ready
- Desktop launcher for easy access

## Directory Structure

```
.
├── bin/                          # Shell scripts
│   ├── monitors_menu_launcher.sh # Main launcher script
│   ├── common_functions.sh       # Shared utility functions
│   └── smoke_test.sh            # Smoke test suite (dry-run)
├── share/
│   └── applications/
│       └── monitor-profiles.desktop  # Desktop entry file
└── .github/
    └── workflows/
        └── bash-syntax-check.yml     # CI workflow for bash syntax checking
```

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/TimInTech/monitor-profiles.git
   cd monitor-profiles
   ```

2. Make scripts executable (already set in git):
   ```bash
   chmod +x bin/*.sh
   ```

3. Run smoke tests to verify setup:
   ```bash
   ./bin/smoke_test.sh
   ```

## Usage

### Running the Launcher

```bash
./bin/monitors_menu_launcher.sh
```

### Dry-Run Mode

Test commands without actually executing them:

```bash
DRY_RUN=1 ./bin/monitors_menu_launcher.sh
```

### Running Smoke Tests

```bash
./bin/smoke_test.sh
```

## Development

### Testing

All bash scripts are automatically tested for syntax errors using `bash -n` in the CI pipeline.

### Non-Blocking Notifications

All notification functions (`notify_info`, `notify_error`, `notify_success`) are non-blocking and run in the background using `&`.

### Adding New Profiles

This is a generic system designed to work with kscreen-doctor. No hardware-specific geometry configurations are included in the scripts.

## CI/CD

GitHub Actions workflow runs on every push and pull request:
- Bash syntax checking for all `.sh` files
- Smoke test execution

## Requirements

- KDE Plasma with KScreen
- kscreen-doctor command-line tool
- systemd (for --user services)
- bash
- notify-send (for notifications)

## License

See repository for license information.
