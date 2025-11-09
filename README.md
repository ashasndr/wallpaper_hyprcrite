# wallpaper hyprcrite

A tool that periodically changes wallpaper on hyprland via hyprpaper. Add to exec_once in your hyprland.conf.
### Usage:
`wphyprcrite.sh [--dir PATH_TO_WALLPAPERS] [--monitor NAME] [--interval SECONDS]`
### Example:
`wphyprcrite.sh --dir ~/Pictures/my_cute_waifu_wallpapers --monitor eDP-1 --interval 600`
### Defaults:
```
wpdir="$HOME/Pictures/wallpaper_hyprcrite"
monitor="eDP-1"
interval=3600
```

Name your files like this:

![config example with multiple images named number1-number2.ext](./illust.png "config example with multiple images")
