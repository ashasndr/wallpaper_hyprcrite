#!/bin/bash

# hyprpaperoclock by ashasndr.
# time of day based wallpaper rotator for hyprpaper
# supports time ranges via filenames like:
#   6-12.png, 12-17.jpg, 17-22.webp, 22-6.jpeg, default.jpg
# (too lazy to add more detail, don't need it anyway.)

set -euo pipefail

##########################
###### defaults consts
WPDIR="$HOME/Pictures/hyppaperoclock"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
MONITOR="eDP-1"
INTERVAL=3600r

###############################
###### argument parsing
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dir)
            WPDIR="$2"; shift 2;;
        --monitor)
            MONITOR="$2"; shift 2;;
        --conf)
            HYPRPAPER_CONF="$2"; shift 2;;
        --interval)
            INTERVAL="$2"; shift 2;;
        --help|-h)
            display_help
            exit 0;;
        *)
            echo "unknown arg $1. check --help if you're lost." >&2; exit 1;;
    esac
done

display_help() {
    cat <<EOF
    usage: $0 [--dir PATH_TO_WALLPAPERS] [--monitor NAME] [--conf PATH] [--interval SECONDS]
    example:
    $0 --dir ~/Pictures/my_cute_waifu_wallpapers --monitor eDP-1 --interval 7200

    tip, to display monitors and their names, use hyprctl monitors
    to configure times, just name the files accordingly, in the right dir. 10-18.png will display that wp from 10 am to 18.
EOF
}

####################################
###### CORE logic
set_wallpaper() {
    local HOUR WALL FILE BASENAME START END
    HOUR=$(date +%H)
    WALL=""

    # find default.jpg,png, etc wallpaper
    for ext in png jpg jpeg webp; do
        if [[ -f "$WPDIR/default.$ext" ]]; then
            WALL="$WPDIR/default.$ext"
            break
        fi
    done

    # (try to) match a range file like 6-12.png
    for FILE in "$WPDIR"/*; do
        BASENAME=$(basename "$FILE")
        if [[ "$BASENAME" =~ ^([0-9]+)-([0-9]+)\.(png|jpg|jpeg|webp)$ ]]; then
            START=${BASH_REMATCH[1]}
            END=${BASH_REMATCH[2]}
            START=$((10#$START))
            END=$((10#$END))

            if (( START < END )); then
                # normal range
                if (( HOUR >= START && HOUR < END )); then
                    WALL="$FILE"
                    break
                fi
            else
                # overnight range(like 22–6)
                if (( HOUR >= START || HOUR < END )); then
                    WALL="$FILE"
                    break
                fi
            fi
        fi
    done

    if [[ -z "$WALL" ]]; then
        echo "no wallpapers found, double check your file names in your $WPDIR" >&2
        return
    fi

    # writing to conf
    echo "preload = $WALL" > "$HYPRPAPER_CONF"
    echo "wallpaper = $MONITOR,$WALL" >> "$HYPRPAPER_CONF"

    if pgrep -x hyprpaper >/dev/null; then
        pkill -USR1 hyprpaper
	sleep 1
	hyprpaper &
	sleep 1
    else
        hyprpaper &
        sleep 1
    fi
}

while true; do
    set_wallpaper
    sleep "$INTERVAL"
done
