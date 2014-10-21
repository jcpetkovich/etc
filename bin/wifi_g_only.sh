#!/usr/bin/env bash

sudo /etc/init.d/net.wl* stop

sleep 1

sudo modprobe -r iwlmvm
sudo modprobe -r iwlwifi
sudo modprobe iwlwifi 11n_disable=1

sleep 1

sudo /etc/init.d/net.wl* start
