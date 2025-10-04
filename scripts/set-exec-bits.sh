#!/usr/bin/env bash
set -euo pipefail
# set-exec-bits.sh
# Make sure the monitor scripts in bin/ are marked executable in git index.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

files=( \
  bin/monitors_*.sh \
  bin/monitors_lib.sh \
  bin/monitors_menu_launcher.sh \
)

found=()
for f in "${files[@]}"; do
  for match in $f; do
    if [ -e "$match" ]; then
      found+=("$match")
    fi
  done
done

if [ ${#found[@]} -eq 0 ]; then
  echo "Keine relevanten Dateien gefunden. Pfad: $REPO_ROOT/bin"
  exit 1
fi

echo "Setze executable-Bit im Git-Index für:" 
for f in "${found[@]}"; do
  echo "  $f"
  # make executable on filesystem first
  chmod +x "$f" 2>/dev/null || true
  git update-index --chmod=+x "$f"
done

echo "Optional: commit the permission changes? (y/N)"
read -r ans || true
if [[ "$ans" =~ ^[Yy]$ ]]; then
  git add --update
  git commit -m "Set executable bits for monitor scripts"
  echo "Committed."
else
   echo "Changes staged in index only. Run 'git add -A && git commit -m \"...\"' to commit if desired." 
fi

echo "Fertig."
