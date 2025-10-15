# Monitor Profiles - Technical Documentation

## Monitor Geometry and Roles

### Physical Setup

- **AOC Left (DP-4)**: 1920x1080@60Hz, landscape
- **AOC Mid (DP-3)**: 1920x1080@75Hz, landscape
- **AOC Right (DP-2)**: 1080x1920@75Hz, portrait (rotated right)

### Layout Coordinates

```
AOC Triple:     [0,260] DP-4    [1920,260] DP-3    [3840,0] DP-2
                (1920x1080)     (1920x1080)        (1080x1920)
                Landscape       Landscape          Portrait
```

Position calculations:

- DP-4 starts at x=0
- DP-3 starts at x=1920
- DP-2 starts at x=3840
- Landscape monitors offset by y=260 to align with portrait monitor's center

## Command Sequences

Each monitor configuration executes exactly ONE `kscreen-doctor` call with all parameters:

### Single AOC Left (DP-4)

```bash
kscreen-doctor output.DP-4.enable output.DP-4.mode.1920x1080@60 output.DP-4.rotation.normal output.DP-4.scale.1 output.DP-4.position.1920,260 output.DP-1.disable output.DP-3.disable output.DP-2.disable
```

### Single AOC Mid (DP-3)

```bash
kscreen-doctor output.DP-3.enable output.DP-3.mode.1920x1080@75 output.DP-3.rotation.normal output.DP-3.scale.1 output.DP-3.position.3840,260 output.DP-1.disable output.DP-4.disable output.DP-2.disable
```

### Single AOC Right (DP-2)

```bash
kscreen-doctor output.DP-2.enable output.DP-2.mode.1920x1080@75 output.DP-2.rotation.right output.DP-2.scale.1 output.DP-2.position.5760,0 output.DP-1.disable output.DP-4.disable output.DP-3.disable
```

### Triple AOC

```bash
kscreen-doctor output.DP-4.enable output.DP-4.mode.1920x1080@60 output.DP-4.rotation.normal output.DP-4.scale.1 output.DP-4.position.0,260 output.DP-3.enable output.DP-3.mode.1920x1080@75 output.DP-3.rotation.normal output.DP-3.scale.1 output.DP-3.position.1920,260 output.DP-2.enable output.DP-2.mode.1920x1080@75 output.DP-2.rotation.right output.DP-2.scale.1 output.DP-2.position.3840,0 output.${primary}.primary
```

## File Structure

```
~/github_repos/monitor-profiles/
├── bin/
│   ├── triple-aoc.sh             # Wrapper for triple mode
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

## Troubleshooting

### Wayland vs X11

This controller is designed for **Wayland only**. On X11, use `xrandr` instead of `kscreen-doctor`.

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
```
