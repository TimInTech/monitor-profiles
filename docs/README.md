# Monitor Profiles - Technical Documentation

## Monitor Geometry and Roles

### Physical Setup

- **DP-1 (AOC 27G15N)**: 1920x1080@60Hz (bis 180Hz möglich), landscape
- **DP-4 (AOC 27B2G5)**: 1920x1080@60Hz, landscape
- **DP-3 (AOC 27B2G5)**: 1920x1080@75Hz, landscape
- **DP-2 (AOC 27B2G5)**: 1080x1920@75Hz, portrait (rotated right)

### Layout Coordinates

**Quad Mode (all 4 monitors):**

```text
[0,260] DP-1    [1920,260] DP-4    [3840,260] DP-3    [5760,0] DP-2
(1920x1080)     (1920x1080)         (1920x1080)        (1080x1920)
27G15N          27B2G5 Left         27B2G5 Mid         27B2G5 Right
Landscape       Landscape           Landscape          Portrait
```

**Triple Mode (3 AOC 27B2G5 monitors):**

```text
[0,260] DP-4    [1920,260] DP-3    [3840,0] DP-2
(1920x1080)     (1920x1080)        (1080x1920)
Left            Middle             Right
Landscape       Landscape          Portrait
```

Position calculations:

- Quad: DP-1 @ x=0, DP-4 @ x=1920, DP-3 @ x=3840, DP-2 @ x=5760
- Triple: DP-4 @ x=0, DP-3 @ x=1920, DP-2 @ x=3840
- Landscape monitors offset by y=260 to align with portrait monitor's center

## Controller Script Usage

Use the central controller `~/.local/bin/monitors-mode.sh` to switch layouts reliably. It wraps `kscreen-doctor` and adds safety checks and fallbacks.

Examples:

```text
# Triple mode (DP-4 + DP-3 + DP-2), DP-3 primary
~/.local/bin/monitors-mode.sh triple --primary DP-3
~/.local/bin/monitors-mode.sh quad --primary DP-3

# Single modes
~/.local/bin/monitors-mode.sh single dp1   # Only DP-1
~/.local/bin/monitors-mode.sh single dp2   # Only DP-2 (portrait)
~/.local/bin/monitors-mode.sh single dp3   # Only DP-3
~/.local/bin/monitors-mode.sh single dp4   # Only DP-4

# Reset (hard disable all, then apply layout)
~/.local/bin/monitors-mode.sh reset triple
~/.local/bin/monitors-mode.sh reset quad

# Status (raw kscreen-doctor output)
~/.local/bin/monitors-mode.sh status

# Dry run (no changes, just print commands)
KS_BIN=echo ~/.local/bin/monitors-mode.sh quad --primary DP-3
```

### Exclusive mode and two-phase sequencing

- Single modes are exclusive: the script disables all outputs first and then enables exactly one.
- Triple/Quad follow the same two-phase pattern: first disable all, short pause, then enable the desired outputs and apply mode/rotation/position and primary.
- Ordering and geometry (left → right): DP-1, DP-4, DP-3 (primary), DP-2 (portrait). Positions: DP-1 `0,260`, DP-4 `1920,260`, DP-3 `3840,260`, DP-2 `5760,0`. Rates: DP-1/DP-4 `60Hz`, DP-3/DP-2 `75Hz`.
- Only `kscreen-doctor` is used (Wayland). For dry-run use `KS_BIN=echo`.

## File Structure

```text
~/github_repos/monitor-profiles/
├── bin/
│   ├── monitors-mode.sh          # Central robust controller (installed to ~/.local/bin)
│   ├── reset-monitors.sh         # Reset wrapper (installed to ~/.local/bin)
│   ├── triple-aoc.sh             # Back-compat wrapper for triple mode
│   └── monitors_menu_launcher.sh # Interactive menu
├── applications/
│   ├── monitor-menu.desktop      # Menu launcher
│   └── monitor-triple-aoc.desktop
├── systemd/
│   ├── monitors-triple.service   # Auto-enable triple on login
│   └── monitors-revert.service   # Manual revert to triple
├── install.sh                    # Idempotent installer
├── uninstall.sh                  # Cleanup script
```

## Desktop File Format

Desktop files use absolute paths with bash wrapper to ensure proper environment:

```ini
Exec=/bin/bash -lc '~/path/to/script'
```

Systemd units can use `%h` for home directory:

```ini
ExecStart=%h/.local/bin/monitors-mode.sh triple --primary DP-3
```

Reset launcher and manual reset service examples:

```ini
# Desktop reset launcher
Exec=/bin/bash -lc '~/.local/bin/reset-monitors.sh'

# systemd --user unit
[Unit]
Description=Reset Monitors to Default Configuration
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=oneshot
ExecStart=%h/.local/bin/reset-monitors.sh

[Install]
WantedBy=default.target
```

## Troubleshooting

### Wayland vs X11

This controller is designed for **Wayland only**. On X11, use `xrandr` instead of `kscreen-doctor` (manual commands are encapsulated by `monitors-mode.sh`).

### Port Name Changes

If monitor port names differ (e.g., DisplayPort-1 instead of DP-1), check current names:

```bash
kscreen-doctor -o
```

Update the controller script accordingly.

### kdialog Missing

The menu launcher gracefully falls back to echo output if kdialog is not available:

```bash
command -v kdialog >/dev/null && kdialog ... || echo "Selection: $choice"
```

### Service Issues

Check systemd service status:

```bash
systemctl --user status monitors-triple.service
journalctl --user -u monitors-triple.service
```

### Dry Run Testing

Use `KS_BIN=echo` environment variable to see commands without execution:

```bash
KS_BIN=echo ~/.local/bin/monitors-mode.sh triple --primary DP-4
KS_BIN=echo ~/.local/bin/monitors-mode.sh quad --primary DP-3
```
