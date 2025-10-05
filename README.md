# Monitor Profiles Controller

A unified controller for switching between monitor configurations on KDE Plasma 6 (Wayland) using `kscreen-doctor`.

## Prerequisites

- KDE Plasma 6 (Wayland)
- `kscreen-doctor` command available
- `kdialog` for menu launcher (optional but recommended)

## Installation

```bash
# Clone/navigate to this repository
cd ~/github_repos/monitor-profiles

# Run the installer
./install.sh
```

The installer will:
- Copy desktop files to `~/.local/share/applications/`
- Run `kbuildsycoca6` to refresh application menu
- Reload systemd user services
- Print validation commands

## Usage

### Command Line
```bash
# Single monitor modes
~/.local/bin/monitors-mode.sh single terra      # Terra (DP-1) only
~/.local/bin/monitors-mode.sh single aoc-left   # DP-4 only
~/.local/bin/monitors-mode.sh single aoc-mid    # DP-3 only  
~/.local/bin/monitors-mode.sh single aoc-right  # DP-2 only

# Triple monitor mode
~/.local/bin/monitors-mode.sh triple                    # Default primary: DP-3
~/.local/bin/monitors-mode.sh triple --primary DP-4     # Primary: left monitor
~/.local/bin/monitors-mode.sh triple --primary DP-2     # Primary: right monitor
```

### GUI Menu
Launch "Monitor-Umschalter" from application menu or run:
```bash
~/github_repos/monitor-profiles/bin/monitors_menu_launcher.sh
```

### Desktop Shortcuts
- "Monitor: Nur Terra (DP-1)" - Single Terra mode
- "Monitor: AOC Triple" - Triple AOC mode

### Systemd Services
```bash
# Enable/start triple mode on login
systemctl --user enable monitors-triple.service
systemctl --user start monitors-triple.service

# Manual revert service
systemctl --user start monitors-revert.service
```

## Dry Run / Testing

Set `KS_BIN=echo` to see commands without executing:
```bash
KS_BIN=echo ~/.local/bin/monitors-mode.sh single terra
KS_BIN=echo ~/.local/bin/monitors-mode.sh triple
```

## Recovery

If monitors get stuck or misconfigured:
```bash
# Terra recovery (always runs first in any mode)
kscreen-doctor output.DP-1.enable output.DP-1.mode.1920x1080@60 output.DP-1.rotation.normal output.DP-1.scale.1

# Or revert to triple mode
systemctl --user start monitors-revert.service
```

## Uninstallation

```bash
./uninstall.sh
```

This removes desktop files and prints instructions for disabling services.

## Troubleshooting

- **Wayland required**: This uses `kscreen-doctor` which works on Wayland
- **Port names may vary**: Check `kscreen-doctor -o` if ports differ from DP-1/2/3/4
- **kdialog missing**: Menu launcher falls back to echo if kdialog unavailable
- **Services not starting**: Check `journalctl --user -u monitors-triple.service`