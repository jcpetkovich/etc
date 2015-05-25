#!/usr/bin/env bash

usb_ethernet_device="$(ip addr | grep MULTICAST | grep -v UP | grep enp | awk -F: '{print $2}' | sed 's/ //' | head -n 1)"
internet_device="$(ip addr | grep MULTICAST | grep UP | awk -F: '{print $2}' | sed 's/ //' | head -n 1)"
host_ip=192.168.7.1
beagle_ip=192.168.7.2

# Set up host ip
sudo ifconfig $usb_ethernet_device $host_ip

# Enable forwarding
sudo sysctl net.ipv4.ip_forward=1

sudo iptables --table nat --append POSTROUTING --out-interface $internet_device -j MASQUERADE
sudo iptables --append FORWARD --in-interface $usb_ethernet_device -j ACCEPT

ssh root@$beagle_ip route add default gw $host_ip
ssh root@$beagle_ip 'echo "nameserver 8.8.8.8" >> /etc/resolv.conf'
