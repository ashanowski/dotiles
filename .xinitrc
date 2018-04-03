xmodmap ~/.Xmodmap &
xrdb -merge ~/.Xresources &
xsetroot -cursor_name left_ptr &
synergyc 192.168.1.105 &
xset -b &
start-pulseaudio-x11 &
dunst &
setxkbmap -option 'caps:ctrl_modifier' -layout pl &
xcape -e 'Caps_Lock=Escape' &
feh --bg-scale /home/gonz/usr/.wallpaper/wallpaper.png &
compton -f &
mpd &
/home/gonz/bin/devmon-d &
notify-send "Welcome to the Void, gonz"
sxhkd &
exec bspwm
