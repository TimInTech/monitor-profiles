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
