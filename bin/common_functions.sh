#!/usr/bin/env bash
# Common functions for monitor profile management
# Generic helpers for KDE/KScreen configuration

# Non-blocking notification functions
notify_info() {
    local message="$1"
    notify-send "Monitor Profiles" "${message}" &
}

notify_error() {
    local message="$1"
    notify-send -u critical "Monitor Profiles Error" "${message}" &
}

notify_success() {
    local message="$1"
    notify-send "Monitor Profiles" "${message}" &
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
