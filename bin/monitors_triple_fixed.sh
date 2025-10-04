#!/usr/bin/env bash
set -euo pipefail
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}"
export DISPLAY="${DISPLAY:-:0}"

# auf KScreen/DBus warten
for i in {1..20}; do kscreen-doctor -o >/dev/null 2>&1 && break; sleep 0.5; done

# Terra ausschalten, AOCs aktivieren (OHNE Rotation zu ändern!)
kscreen-doctor \
    output.DP-1.disable \
    output.DP-2.enable \
    output.DP-3.enable \
    output.DP-4.enable

sleep 1

# Modi setzen
kscreen-doctor \
    output.DP-2.mode.1920x1080@75 \
    output.DP-3.mode.1920x1080@75 \
    output.DP-4.mode.1920x1080@60

echo "Layout gesetzt: DP-3 (links), DP-4 (mitte), DP-2 (rechts)"
echo "Rotationen wurden NICHT geändert - so wie sie sind!"
