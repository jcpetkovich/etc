#!/bin/bash

if [ -f ~/bin/xinitrc.systemspecific ]; then
  source ~/bin/xinitrc.systemspecific
fi

# restore theme
if which wal > /dev/null ; then
    wal -R
    ~/etc/pywal/post-wal-hook.py
fi

# set pointer theme
xsetroot -cursor_name left_ptr

# setup keyboard
xset r rate 250 &
~/bin/functions/keymaps/colemak3

# setup keychain
source /etc/X11/xinit/xinitrc.d/80-dbus
export `gnome-keyring-daemon -s`

# share x11 info
exportXinfo

# load Xresources
xrdb -merge ~/.Xresources

# start compositing
compton -b

# start gpaste-client
pidof gpaste-client >/dev/null || gpaste-client &

# music!
mpd

# start x
exec ck-launch-session bspwm
