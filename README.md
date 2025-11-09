# hyprpaperoclock

a tool that periodically changes wallpaper on hyprland via hyprpaper. to add to exec_once in your hyprland.conf
someone probably already made something like this, but i felt like doing one myself for the thrill of it.
named it this way because o'clock is such a whimsical little word.

### usage: 
`hyprpaperoclock.sh [--dir PATH_TO_WALLPAPERS] [--monitor NAME] [--conf PATH] [--interval SECONDS]`
### example:
`hyprpaperoclock.sh --dir ~/Pictures/my_cute_waifu_wallpapers --monitor eDP-1 --interval 7200`
### Defaults:
```
WPDIR="$HOME/Pictures/hyprpaperoclock"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
MONITOR="eDP-1"
INTERVAL=3600
```

name your files like this: 
![config example with multiple images named number1-number2.ext](./illust.png "config example with multiple images")

please note that rn this script is in a fairly early stage so there aren't necessarily all imaginable cases in terms of error checking and all that.
if you don't do anything silly in your config it should work.
