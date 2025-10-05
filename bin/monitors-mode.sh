#!/usr/bin/env bash
set -euo pipefail

# monitors-mode.sh - unified controller for monitor-profiles
# Modes:
#   single <terra|aoc-left|aoc-mid|aoc-right>
#   triple [--primary DP-4|DP-3|DP-2]
#
# KS_BIN override for dry-run:
#   KS_BIN=echo ~/.local/bin/monitors-mode.sh single terra

KS_BIN="${KS_BIN:-kscreen-doctor}"

usage() {
	cat <<EOF
Usage: $(basename "$0") <single|triple> [args]

Modes:
	single <terra|aoc-left|aoc-mid|aoc-right>
	triple [--primary DP-4|DP-3|DP-2]

Environment:
	KS_BIN=...  Override kscreen-doctor for dry-run (e.g. KS_BIN=echo)
EOF
}

if [ $# -lt 1 ]; then
	usage
	exit 2
fi

MODE="$1"; shift

# Terra recovery (always try re-enable DP-1 first; do not fail if it errors)
# Exact required recovery command:
"$KS_BIN" output.DP-1.enable output.DP-1.mode.1920x1080@60 output.DP-1.rotation.normal output.DP-1.scale.1 || true

# helper: run a single kscreen-doctor call built from an array of args
run_seq() {
	local -a SEQ=("$@")
	echo "Executing: $KS_BIN ${SEQ[*]}"
	"$KS_BIN" "${SEQ[@]}"
}

case "$MODE" in
	single)
		if [ $# -lt 1 ]; then
			echo "single requires an argument (terra|aoc-left|aoc-mid|aoc-right)" >&2
			exit 2
		fi
		SUB="$1"; shift
		case "$SUB" in
			terra)
				# SINGLE terra (one single kscreen-doctor call)
				SEQ=(output.DP-1.enable output.DP-1.mode.1920x1080@60 output.DP-1.rotation.normal output.DP-1.scale.1 output.DP-1.position.0,0 output.DP-1.primary
						 output.DP-3.disable output.DP-2.disable output.DP-4.disable)
				;;
			aoc-left)
				SEQ=(output.DP-4.enable output.DP-4.mode.1920x1080@60 output.DP-4.rotation.normal output.DP-4.scale.1 output.DP-4.position.1920,260
						 output.DP-1.disable output.DP-3.disable output.DP-2.disable)
				;;
			aoc-mid)
				SEQ=(output.DP-3.enable output.DP-3.mode.1920x1080@75 output.DP-3.rotation.normal output.DP-3.scale.1 output.DP-3.position.3840,260
						 output.DP-1.disable output.DP-4.disable output.DP-2.disable)
				;;
			aoc-right)
				SEQ=(output.DP-2.enable output.DP-2.mode.1920x1080@75 output.DP-2.rotation.left output.DP-2.scale.1 output.DP-2.position.5760,0
						 output.DP-1.disable output.DP-4.disable output.DP-3.disable)
				;;
			*)
				echo "Unknown single submode: $SUB" >&2
				exit 2
				;;
		esac

		run_seq "${SEQ[@]}"
		;;

	triple)
		PRIMARY=""
		if [ $# -gt 0 ]; then
			case "$1" in
				--primary)
					shift
					PRIMARY="${1:-}"
					shift || true
					;;
				*)
					;;
			esac
		fi

		SEQ=(output.DP-4.enable output.DP-4.mode.1920x1080@60 output.DP-4.rotation.normal output.DP-4.scale.1 output.DP-4.position.1920,260
				 output.DP-3.enable output.DP-3.mode.1920x1080@75 output.DP-3.rotation.normal output.DP-3.scale.1 output.DP-3.position.3840,260
				 output.DP-2.enable output.DP-2.mode.1920x1080@75 output.DP-2.rotation.left output.DP-2.scale.1 output.DP-2.position.5760,0
				 output.DP-1.disable)

		case "$PRIMARY" in
			DP-4|DP-3|DP-2)
				SEQ+=(output."$PRIMARY".primary)
				;;
			'')
				;;
			*)
				echo "Invalid --primary value: $PRIMARY" >&2
				exit 2
				;;
		esac

		run_seq "${SEQ[@]}"
		;;

	*)
		echo "Unknown mode: $MODE" >&2
		usage
		exit 2
		;;
esac

exit 0
