#!/usr/bin/env bash
set -euo pipefail

notify(){
	local msg="$*"
	if command -v kdialog >/dev/null 2>&1; then
		nohup kdialog --passivepopup "$msg" 3 >/dev/null 2>&1 &
	elif command -v notify-send >/dev/null 2>&1; then
		notify-send "Monitors" "$msg" || true
	else
		echo "$msg"
	fi
}

LOG_FILE="${LOG_FILE:-$HOME/.cache/monitors-mode.log}"
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true
log(){ printf '[%s] %s\n' "$(date +'%F %T')" "$*" >>"$LOG_FILE" 2>/dev/null || true; }

notify "Setze Monitore zurück…"
if ~/.local/bin/monitors-mode.sh reset triple; then
	log "RESET: success (triple)"
	notify "Reset abgeschlossen (Triple aktiv)"
else
	log "RESET: failed"
	notify "Reset fehlgeschlagen"
	exit 1
fi
