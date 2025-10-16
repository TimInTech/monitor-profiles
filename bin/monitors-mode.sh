#!/usr/bin/env bash
set -euo pipefail

KS_BIN="${KS_BIN:-kscreen-doctor}"

# Logging & Notify
LOG_FILE="${LOG_FILE:-$HOME/.cache/monitors-mode.log}"
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true
log(){ printf '[%s] %s\n' "$(date +'%F %T')" "$*" >>"$LOG_FILE" 2>/dev/null || true; }
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
ks(){ echo "$*"; log "KS: $*"; "$KS_BIN" "$@"; }
done_msg(){ local m="$*"; log "DONE: $m"; notify "$m"; }

# ---- feste Layout-Parameter ----
P_DP1_POS="0,260";    P_DP1_MODE="1920x1080@60"
P_DP4_POS="1920,260"; P_DP4_MODE="1920x1080@60"
P_DP3_POS="3840,260"; P_DP3_MODE="1920x1080@75"
P_DP2_POS="5760,0";   P_DP2_MODE="1920x1080@75"  # 1080x1920 via rotation.right

off_all(){
  ks output.DP-1.disable output.DP-4.disable output.DP-3.disable output.DP-2.disable || true
  sleep 0.4
}

only(){
  local target="$1"
  off_all
  ks output."$target".enable
  sleep 0.3
  case "$target" in
    DP-1) ks output.DP-1.mode.${P_DP1_MODE} output.DP-1.rotation.normal  output.DP-1.scale.1 output.DP-1.position.${P_DP1_POS} output.DP-1.primary ;;
    DP-4) ks output.DP-4.mode.${P_DP4_MODE} output.DP-4.rotation.normal  output.DP-4.scale.1 output.DP-4.position.${P_DP4_POS} output.DP-4.primary ;;
    DP-3) ks output.DP-3.mode.${P_DP3_MODE} output.DP-3.rotation.normal  output.DP-3.scale.1 output.DP-3.position.${P_DP3_POS} output.DP-3.primary ;;
    DP-2) ks output.DP-2.mode.${P_DP2_MODE} output.DP-2.rotation.right   output.DP-2.scale.1 output.DP-2.position.${P_DP2_POS} output.DP-2.primary ;;
  esac
  # Sicherheitsnetz: alles außer Ziel erneut deaktivieren
  for o in DP-1 DP-4 DP-3 DP-2; do [[ "$o" == "$target" ]] || ks output.$o.disable || true; done
  done_msg "Single aktiv: $target"
}

layout_triple(){
  local primary="${1:-DP-3}"
  off_all
  ks output.DP-4.enable output.DP-3.enable output.DP-2.enable
  sleep 0.4
  ks \
    output.DP-4.mode.${P_DP4_MODE} output.DP-4.rotation.normal output.DP-4.scale.1 output.DP-4.position.${P_DP4_POS} \
    output.DP-3.mode.${P_DP3_MODE} output.DP-3.rotation.normal output.DP-3.scale.1 output.DP-3.position.${P_DP3_POS} \
    output.DP-2.mode.${P_DP2_MODE} output.DP-2.rotation.right  output.DP-2.scale.1 output.DP-2.position.${P_DP2_POS} \
    output.${primary}.primary
  done_msg "Triple aktiv (Primary: ${primary})"
}

layout_quad(){
  local primary="${1:-DP-3}"
  off_all
  ks output.DP-1.enable output.DP-4.enable output.DP-3.enable output.DP-2.enable
  sleep 0.4
  ks \
    output.DP-1.mode.${P_DP1_MODE} output.DP-1.rotation.normal output.DP-1.scale.1 output.DP-1.position.${P_DP1_POS} \
    output.DP-4.mode.${P_DP4_MODE} output.DP-4.rotation.normal output.DP-4.scale.1 output.DP-4.position.${P_DP4_POS} \
    output.DP-3.mode.${P_DP3_MODE} output.DP-3.rotation.normal output.DP-3.scale.1 output.DP-3.position.${P_DP3_POS} \
    output.DP-2.mode.${P_DP2_MODE} output.DP-2.rotation.right  output.DP-2.scale.1 output.DP-2.position.${P_DP2_POS} \
    output.${primary}.primary
  done_msg "Quad aktiv (Primary: ${primary})"
}

status(){ "$KS_BIN" -o; }

usage(){
  echo "Usage:"
  echo "  $0 single dp1|dp4|dp3|dp2   # exklusiv EIN Monitor"
  echo "  $0 triple [--primary DP-3|DP-4|DP-2]"
  echo "  $0 quad   [--primary DP-3|DP-4|DP-2|DP-1]"
  echo "  $0 reset [triple|quad]      # alles aus, dann Standardlayout"
  echo "  $0 status"
  exit 2
}

case "${1-}" in
  single)
    case "${2-}" in
      dp1) only DP-1 ;;
      dp4|aoc-left)  only DP-4 ;;
      dp3|aoc-mid)   only DP-3 ;;
      dp2|aoc-right) only DP-2 ;;
      *) usage ;;
    esac
    ;;
  triple)
    p="DP-3"; [[ "${2-}" == "--primary" && "${3-}" =~ ^DP-(1|2|3|4)$ ]] && p="${3}"
    layout_triple "$p"
    ;;
  quad)
    p="DP-3"; [[ "${2-}" == "--primary" && "${3-}" =~ ^DP-(1|2|3|4)$ ]] && p="${3}"
    layout_quad "$p"
    ;;
  reset)
    case "${2-}" in
      quad)   layout_quad ;;
      triple|"" ) layout_triple ;;
      *) usage ;;
    esac
    ;;
  status) status ;;
  *) usage ;;
esac
