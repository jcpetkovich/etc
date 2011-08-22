#!/bin/bash

# BEGIN configuration
RUNLEVEL_AC="default"
RUNLEVEL_BATTERY="battery"
# END configuration


if [ ! -d "/etc/runlevels/${RUNLEVEL_AC}" ]
then
    logger "${0}: Runlevel ${RUNLEVEL_AC} does not exist. Aborting."
    exit 1
fi

if [ ! -d "/etc/runlevels/${RUNLEVEL_BATTERY}" ]
then
    logger "${0}: Runlevel ${RUNLEVEL_BATTERY} does not exist. Aborting."
    exit 1
fi

if on_ac_power
then
    if [[ "$(rc-status --nocolor | sed -ne 's/^Runlevel: //p')" != "${RUNLEVEL_AC}" ]]
    then
        logger "Switching to ${RUNLEVEL_AC} runlevel"
         /sbin/rc ${RUNLEVEL_AC}
         echo 500 > /proc/sys/vm/dirty_writeback_centisecs
         echo max_performance > /sys/class/scsi_host/host0/link_power_management_policy
         echo 0 > /proc/sys/vm/laptop_mode
         # echo 15 > /sys/class/backlight/acpi_video0/brightness
         # echo 15 > /sys/devices/virtual/backlight/acpi_video0/brightness

    fi
elif [[ "$(rc-status --nocolor | sed -ne 's/^Runlevel: //p')" != "${RUNLEVEL_BATTERY}" ]]
then
    logger "Switching to ${RUNLEVEL_BATTERY} runlevel"
    /sbin/rc ${RUNLEVEL_BATTERY}
    echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
    echo min_power > /sys/class/scsi_host/host0/link_power_management_policy
    echo 5 > /proc/sys/vm/laptop_mode

    echo auto > /sys/bus/usb/devices/4-2/power/level
    # echo 5 > /sys/class/backlight/acpi_video0/brightness
    # echo 5 > /sys/devices/virtual/backlight/acpi_video0/brightness
fi
