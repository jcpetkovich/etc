#!/bin/sh
# if non-named tmux sessions exist that are not attached, attach to them, otherwise create a new one
(tmux ls | awk -F: '$1 ~ /[[:digit:]]+/ {print $0}' | grep -vq attached && tmux at) || tmux 
