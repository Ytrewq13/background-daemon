#!/bin/sh

LIBDIR="$HOME/Pictures/desktop-backgrounds"
CURBGFILE="$HOME/.fehbg"

current=$(sed "1d; s/'//g; 2q" "$CURBGFILE" | awk '{print $NF}')
new=$(find "$LIBDIR" -type f -name "*.png" | awk -F'.' '{for (i=0;i<$(NF-1);i++){print}}' | grep -v "$current" | shuf -n 1)

echo "$new"
