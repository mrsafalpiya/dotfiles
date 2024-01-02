# Run programs at startup
xset dpms 0 0 0
xset s off
clipmenud &
unclutter &
sxhkd &
dunst &
flameshot &
fixmouse &
nm-applet &
cbatticon &
sleep 3; mpc update && mpc ls | mpc add &
picom --fade-in-step=1 --fade-out-step=1 --fade-delta=0 &

while true; do xsetroot -name "$(date -u +'%I:%M%p %Z') | $(date +'%I:%M%p %Z')"; sleep 60; done &

hash tmux && st -e tmux new-session -A -s main &
hash ncmpcpp && st -c ncmpcppterm -e ncmpcpp &

xrdb -merge ~/.Xresources

# Start dwm
exec dwm
