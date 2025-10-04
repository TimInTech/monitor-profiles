# monitor-profiles

KDE/Wayland monitor profiles using kscreen-doctor and systemd --user.

See `docs/README.md` for usage, recovery steps and profiles.

Requirements: KDE Plasma (Wayland), kdialog, kscreen-doctor, systemd --user.

Quick start (after cloning):

1. `scripts/set-exec-bits.sh` (marks scripts executable in git index)
2. `systemctl --user daemon-reload`
3. Run `bin/monitors_menu_launcher.sh` or use the desktop entry
