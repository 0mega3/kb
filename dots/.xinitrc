### urxvt ###
#
# locale category to select encoding
export LC_CTYPE=C.UTF-8

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

### System settings ###
#
# Reset keyboard options and switch layout from Win+Space to Ctrl+Shift
setxkbmap -option
setxkbmap -layout us,ru -option grp:ctrl_shift_toggle

### wm ###
#
exec i3
