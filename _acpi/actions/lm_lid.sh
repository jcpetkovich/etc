#! /bin/sh

test -f /lib/udev/lmt-udev || exit 0

group=${1%%/*}
action=${1#*/}
device=$2
id=$3
value=$4

case "$group" in
	button)
		case "$action" in
			lid)
				case "$id" in
					close) /usr/share/laptop-mode-tools/module-helpers/pm-suspend;;
					open) :;;
					*) log_unhandled $*;;
				esac
				;;
			*) log_unhandled $*;;
		esac
		;;
	*) log_unhandled $*;;
esac

# lid button pressed/released event handler
/lib/udev/lmt-udev
