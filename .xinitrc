# Run programs at startup
xset dpms 0 0 0
xset s off
clipmenud &
mpd &
unclutter &
sxhkd &
dunst &
flameshot &

while true; do xsetroot -name "$(date -u +'%I:%M%p %Z') | $(date +'%I:%M%p %Z')"; sleep 60; done &

# Start dwm
exec dwm
