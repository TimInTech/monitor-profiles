#!/usr/bin/env bash
set -euo pipefail
# Common functions for monitor profile management
# Generic helpers for KDE/KScreen configuration

# Non-blocking notification functions
notify_info() {
    local message="$1"
    # Check if we have a display to send to
    if [[ -n "${DISPLAY:-}" ]] || [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
        nohup notify-send "Monitor Profiles" "${message}" >/dev/null 2>&1 &
    fi
}

notify_error() {
    local message="$1"
    # Check if we have a display to send to
    if [[ -n "${DISPLAY:-}" ]] || [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
        nohup notify-send -u critical "Monitor Profiles Error" "${message}" >/dev/null 2>&1 &
    fi
}

notify_success() {
    local message="$1"
    # Check if we have a display to send to
    if [[ -n "${DISPLAY:-}" ]] || [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
        nohup notify-send "Monitor Profiles" "${message}" >/dev/null 2>&1 &
    fi
}

# Dry-run mode check
is_dry_run() {
    [[ "${DRY_RUN:-0}" == "1" ]] || [[ "${DRY_RUN:-}" == "true" ]]
}

# Execute command with optional dry-run
execute_cmd() {
    local cmd="$*"
    if is_dry_run; then
        echo "[DRY-RUN] Would execute: ${cmd}"
        return 0
    else
        eval "${cmd}"
    fi
}

# Log message
log_msg() {
    local level="$1"
    shift
    local message="$*"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] ${message}"
}

log_info() {
    log_msg "INFO" "$@"
}

log_error() {
    log_msg "ERROR" "$@"
}
