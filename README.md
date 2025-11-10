# wallpaper hyprcrite

A tool that periodically changes wallpaper on hyprland via hyprpaper. Add to exec_once in your hyprland.conf.

No clue why I named it this way, i just liked the little word play.

### Usage:

`wphyprcrite.sh [--dir PATH_TO_WALLPAPERS] [--monitor NAME] [--interval SECONDS]`

### Example:

`wphyprcrite.sh --dir ~/Pictures/my_cute_waifu_wallpapers --monitor eDP-1 --interval 600`

### Defaults:

```
wpdir="$HOME/Pictures/wallpaper_hyprcrite"
monitor=" "
interval=1600
```

Name your files like this:

![config example with multiple images named number1-number2.ext](./illust.png "config example with multiple images")

(HHMM-HHMM) or default
