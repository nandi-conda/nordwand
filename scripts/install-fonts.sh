#!/bin/sh
# Install (or remove) the fonts shipped in this environment into the user's font directory.
# Usage: @NAME@ [--uninstall]
set -eu

FAMILY="@FAMILY@"
GLOB="@GLOB@"
NAME="@NAME@"

case "${1:-}" in
  "") action=install ;;
  --uninstall) action=uninstall ;;
  -h|--help) echo "Usage: $NAME [--uninstall]"; exit 0 ;;
  *) echo "Usage: $NAME [--uninstall]" >&2; exit 2 ;;
esac

# Resolve the environment prefix from this script's real location ($PREFIX/bin/<script>).
self=$(readlink -f "$0" 2>/dev/null || realpath "$0")
prefix=$(cd "$(dirname "$self")/.." && pwd)
src="$prefix/fonts"

case "$(uname -s)" in
  Darwin) dest="$HOME/Library/Fonts" ; mode=copy ;;
  *)      dest="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/$FAMILY" ; mode=link ;;
esac

if [ "$action" = uninstall ]; then
  if [ "$mode" = link ]; then
    rm -rf "$dest"
  else
    for f in "$src"/$GLOB; do rm -f "$dest/$(basename "$f")"; done
  fi
  echo "Removed $FAMILY fonts from $dest"
else
  set -- "$src"/$GLOB
  [ -e "$1" ] || { echo "No fonts matching $GLOB in $src" >&2; exit 1; }
  mkdir -p "$dest"
  for f in "$@"; do
    if [ "$mode" = link ]; then ln -sf "$f" "$dest/"; else cp -f "$f" "$dest/"; fi
  done
  echo "Installed $# $FAMILY fonts into $dest"
fi

if [ "$mode" = link ] && command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$(dirname "$dest")" >/dev/null 2>&1 || true
fi
