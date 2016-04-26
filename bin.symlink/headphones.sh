#!/bin/bash

# enable headphones (disable speaker):
alsaucm -c ROCKCHIP-I2S set _verb HiFi set _enadev Headphone
# set headphones to half loudness:
amixer set Headphone 35%
