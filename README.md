# Monitor Profiles Controller

Ein Controller zum Umschalten zwischen Monitor-Konfigurationen auf KDE Plasma 6 (Wayland) mit kscreen-doctor.

## Voraussetzungen

- KDE Plasma 6 (Wayland)
- kscreen-doctor ist installiert
- kdialog für den Menü-Starter (optional)

## Installation

```bash
# Repository öffnen
cd ~/github_repos/monitor-profiles

# Installer ausführen
./install.sh
```

Der Installer erledigt:

- Kopiert Desktop-Dateien nach ~/.local/share/applications/
- Führt kbuildsycoca6 zum Aktualisieren des Menüs aus
- Lädt systemd --user neu
- Gibt Prüf-/Validierungsbefehle aus

## Nutzung

### Kommandozeile

```bash
# Single-Modi
~/.local/bin/monitors-mode.sh single aoc-left   # DP-4 only
~/.local/bin/monitors-mode.sh single aoc-mid    # DP-3 only
~/.local/bin/monitors-mode.sh single aoc-right  # DP-2 only

# Triple-Modus
~/.local/bin/monitors-mode.sh triple                    # Standard-Primary: DP-3
~/.local/bin/monitors-mode.sh triple --primary DP-4     # Primary: linker Monitor
~/.local/bin/monitors-mode.sh triple --primary DP-2     # Primary: rechter Monitor
```

### GUI-Menü

Starte „Monitor-Umschalter“ aus dem Anwendungsmenü oder:

```bash
~/github_repos/monitor-profiles/bin/monitors_menu_launcher.sh
```

### Desktop-Shortcuts

- „Monitor: AOC Triple“ – Triple-AOC-Modus

### Systemd-Services

```bash
# Triple-Modus beim Login aktivieren/starten
systemctl --user enable monitors-triple.service
systemctl --user start monitors-triple.service

# Manuelles Revert
systemctl --user start monitors-revert.service
```

## Dry Run / Testing

Setze KS_BIN=echo, um Befehle nur auszugeben:

```bash
KS_BIN=echo ~/.local/bin/monitors-mode.sh triple
```

## Uninstallation

```bash
./uninstall.sh
```

Der Uninstaller entfernt Desktop-Dateien und gibt Hinweise zum Deaktivieren von Services.

## Troubleshooting

- Wayland erforderlich: nutzt kscreen-doctor
- Port-Namen können abweichen: prüfe mit kscreen-doctor -o
- kdialog fehlt: Menü-Skript fällt auf echo zurück
- Services starten nicht: journalctl --user -u monitors-triple.service prüfen

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
KS_BIN=echo ~/.local/bin/monitors-mode.sh triple
```

## Recovery

If monitors get stuck or misconfigured:

```bash
# Revert to triple mode
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
