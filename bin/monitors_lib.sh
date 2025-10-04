#!/usr/bin/env bash
set -euo pipefail
wait_ready(){ for i in {1..60}; do kscreen-doctor -o >/dev/null 2>&1 && return 0; sleep 0.25; done; echo "KScreen nicht bereit"; exit 1; }
is_connected(){ 
	# kscreen-doctor prints lines like: "Output: 1 DP-1" then an indented "connected" or "Connected: true"
	kscreen-doctor -o | awk -v o="$1" '
		/^Output:/ { name=$NF; f=(name==o) }
		f && (/Connected:\s*true/ || /\bconnected\b/) { ok=1; f=0 }
		END{ exit(ok?0:1) }'
}
notify_(){ 
	# use nohup+background so notify from systemd oneshot services doesn't block
	if command -v kdialog >/dev/null; then
		nohup kdialog --passivepopup "$1" 3 >/dev/null 2>&1 &
	fi
}
is_triple_active(){ kscreen-doctor -o | awk '$1=="Output:"{o=$2} /Geometry:/{g[$2]=1} END{print ((g["1920,260"]&&g["3840,260"]&&g["5760,0"])?"maybe":"no")}'; }
start_revert_timer(){ systemctl --user stop monitors-revert.timer monitors-revert.service >/dev/null 2>&1 || true; systemctl --user start monitors-revert.timer; }
cancel_revert_timer(){ systemctl --user stop monitors-revert.timer monitors-revert.service >/dev/null 2>&1 || true; }
terra_session_start(){ systemctl --user start monitors-terra-session.service; systemctl --user restart monitors-terra-off.timer; }
terra_session_stop(){ systemctl --user stop monitors-terra-off.timer monitors-terra-off.service monitors-terra-session.service || true; }
