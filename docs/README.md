# Monitor-Profile (KDE/KScreen)

## Profile

- **Dreier-Layout (Standard)**: DP-4 links (0,260), DP-3 Mitte (1920,260, primär), DP-2 rechts (3840,0); DP-1 aus.

- **Nur DP-1**: Falls DP-1 nicht verbunden, automatisch **Nur DP-2**.

- **Nur DP-2**: Notfallprofil, immer verfügbar.

- **Toggle**: Erkennung und Wechsel zwischen Standard und Nur DP-2.

## Komfort

- Failsafe: Nach 2 Minuten automatischer Revert auf Standard.

- Terra-only: Kein Standby/Lock; nach 90 Min Displays aus (ohne Passwortabfrage).

- Menü, Desktop-Starter, Benachrichtigungen.

## Wiederherstellung

1. `systemctl --user stop monitors-revert.timer monitors-terra-*`

2. `~/apps/monitor-profiles/bin/monitors_triple.sh`

3. `systemctl --user enable --now monitors-triple.service`

## Stolpersteine

- Wayland vorausgesetzt; KWin-Bus `powerOffMonitors` benötigt Plasma ≥ 6.

- Falls `kdialog` fehlt, installieren.

- Port-Namen können bei Umstecken wechseln; Scripts ändern nur Position/Modus, nicht Rotationen.

## Änderungen (kurz)

- 2025-10-04: Pfade in Desktop-Launcher und Menüskript auf `~/apps/monitor-profiles/bin/` korrigiert.

- 2025-10-04: `monitors_triple.sh` an reale Geometrie angepasst (DP-4: 0,260; DP-3: 1920,260; DP-2: 3840,0).

- 2025-10-04: `notify_()` in `bin/monitors_lib.sh` läuft nun nicht-blockierend (nohup &) um systemd-Hänger zu vermeiden.

[Unit]
Description=Apply selected monitor mode
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=oneshot
ExecStart=%h/.local/bin/monitors-mode.sh triple
RemainAfterExit=yes

[Install]
WantedBy=default.target
