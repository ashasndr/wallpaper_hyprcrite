#!/usr/bin/env bash
#
# wallpaper hyprcrite. hyprpaper wallpaper switcher according to the time of day
# file names follow HHMM-HHMM format, examples:
#   0651-1230.png
#   1230-1745.jpg
#   1745-2245.webp
#   2245-0651.jpeg
# plus optional default wallpaper (default.png|jpg|webp, etc.)
#
# files to be put in ~/Pictures/wallpaper_hyprcrite
#
# usage:
# wphypercrite.sh [--dir PATH] [--monitor NAME] [--interval SECONDS]
#
# huge shoutout to shellchecker

set -euo pipefail

###############################
###### consts & defaults
#
SUPPORTED_EXTS=("png" "jpg" "jpeg" "webp")
wpdir="$HOME/Pictures/wallpaper_hyprcrite"
monitor="eDP-1"
interval=1600

###############################
###### argument parsing
#

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dir)
            wpdir="$2"; shift 2;;
        --monitor)
            monitor="$2"; shift 2;;
        --interval)
            interval="$2"; shift 2;;
        --help|-h)
            display_help
            exit 0;;
        *)
            echo "unknown arg $1. check --help if you're lost." >&2; exit 1;;
    esac
done

#####################
##### functions
#

display_help() {
    cat <<EOF
    usage: $0 [--dir PATH_TO_WALLPAPERS] [--monitor NAME] [--interval SECONDS]
    example:
    $0 --dir ~/Pictures/my_cute_waifu_wallpapers --monitor eDP-1 --interval 600

    to configure times, just name the files accordingly, in the right dir. 1012-1843.png will display that wp from 10:12am to 18:43.
    default dir is ~/Pictures/wallpaper_hyprcrite

    tip, to display monitors and their names, use hyprctl monitors
EOF
}

# convert HHMM to integer amount of minutes since midnight local time
to_minutes() {
    local hhmm="$1"
    local hour="${hhmm:0:2}"
    local mint="${hhmm:2:2}"
    echo $((10#$hour * 60 + 10#$mint)) # values converted to octal
}

choose_wallpaper() {
    local now_hhmm now_min start_min end_min
    now_hhmm=$(date +%H%M)
    now_min=$(to_minutes "$now_hhmm")

    local chosen=""
    local file base ext start end

    # don't pass empty *.ext in for loops
    shopt -s nullglob

    readarray -t files < <(find "$wpdir" -maxdepth 1 -type f)

    for file in "${files[@]}"; do
        base=$(basename "$file")
        if [[ "$base" =~ ^([0-9]{4})-([0-9]{4})\.([a-zA-Z0-9]+)$ ]]; then
            # capture groups:  grp 1, grp 2,     grp 3
            start="${BASH_REMATCH[1]}"
            end="${BASH_REMATCH[2]}"
            ext="${BASH_REMATCH[3],,}" # ,, to lower

            [[ " ${SUPPORTED_EXTS[*]} " =~ " $ext " ]] || continue

            start_min=$(to_minutes "$start")
            end_min=$(to_minutes "$end")

            # normal
            if (( start_min < end_min )); then
                if (( now_min >= start_min && now_min < end_min )); then
                    chosen="$file"
                    break
                fi
            else
                # overnight (EVERNIGHT??? STAR RAIL REFERENCE???)
                if (( now_min >= start_min || now_min < end_min )); then
                    chosen="$file"
                    break
                fi
            fi
        fi
    done

    # if nothing matched, use default.*
    if [[ -z "$chosen" ]]; then
        for ext in "${SUPPORTED_EXTS[@]}"; do
            if [[ -f "$wpdir/default.$ext" ]]; then
                chosen="$wpdir/default.$ext"
                break
            fi
        done
    fi

    echo "$chosen"
}

set_wallpaper() {
    local wall="$1"
    if [[ -z "$wall" ]]; then
        echo "[wphyprcrite] no wallpaper found for current time." >&2
        return
    fi

    if ! pgrep -x hyprpaper >/dev/null; then
        hyprpaper &
        sleep 1
    fi

    # idk if this works in old versions of hyprland but deal with it if you have to WorksOnMyMachineTM
    hyprctl hyprpaper preload "$wall" >/dev/null
    hyprctl hyprpaper wallpaper "$monitor,$wall" >/dev/null
}

###############################
####### main loop
#

while true; do
    wall=$(choose_wallpaper)
    set_wallpaper "$wall"
    sleep "$interval"
done
