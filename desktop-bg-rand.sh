#!/bin/sh

RATING_COEFFICIENT=1

while :; do
    case $1 in
        --print-rating)
            PRINT_RATING=1
            shift
            ;;
        --multiply-rating)
            RATING_COEFFICIENT=$2
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

LIBDIR="${LIBDIR-$HOME/Pictures/desktop-backgrounds}"
CURRENT_BG_FILE="${CURRENT_BG_FILE-$HOME/.cache/current-desktop-background}"

new=$(find "$LIBDIR" -type f -name "*.jpg" | awk -F'.' '{for (i=0;i<$(NF-1);i++){print}}' | shuf -n 1)
[ -f "$CURRENT_BG_FILE" ] && new=$(find "$LIBDIR" -type f -name "*.jpg" | grep -vf "$CURRENT_BG_FILE" | awk -F'.' '{for (i=0;i<$(NF-1);i++){print}}' | shuf -n 1)

echo "$new"

if (( $PRINT_RATING )); then
    echo "$new" | awk -F'.' "{print \$(NF-1)*$RATING_COEFFICIENT}"
fi
