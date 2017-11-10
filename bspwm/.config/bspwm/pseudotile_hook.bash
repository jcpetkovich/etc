#!/usr/bin/env bash

for desk in $PSEUDOTILE_DESKTOPS ; do
    desk_id=$(bspc query -D -d $desk)
    PSEUDOTILE_DESKTOP_IDS="$PSEUDOTILE_DESKTOP_IDS $desk_id"
done

bspc subscribe node_manage | while read -a msg ; do
    desk_id=${msg[2]}
    wid=${msg[3]}

    for pdid in $PSEUDOTILE_DESKTOP_IDS ; do
        [ "$pdid" = "$desk_id" ] && bspc node "$wid" -t pseudo_tiled
    done
done
