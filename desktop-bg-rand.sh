#!/bin/sh

LIBDIR="${LIBDIR-$HOME/Pictures/desktop-backgrounds}"
CURRENT_BG_FILE="${CURRENT_BG_FILE-$HOME/.cache/current-desktop-background}"

new=$(find "$LIBDIR" -type f -name "*.jpg" | awk -F'.' '{for (i=0;i<$(NF-1);i++){print}}' | shuf -n 1)
[ -f "$CURRENT_BG_FILE" ] && new=$(find "$LIBDIR" -type f -name "*.jpg" | grep -vf "$CURRENT_BG_FILE" | awk -F'.' '{for (i=0;i<$(NF-1);i++){print}}' | shuf -n 1)

echo "$new"
