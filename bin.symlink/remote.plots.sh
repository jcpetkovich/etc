#!/bin/bash

mkdir -p /tmp/compute1
sshfs compute1:/home/jcp/projects/pilots/GM-data/loading-GM-data/ /tmp/compute1
o /tmp/compute1/Rplots.pdf

mkdir -p /tmp/workhorse
sshfs workhorse:/home/jcp/graphics /tmp/workhorse
o /tmp/workhorse/Rplots.pdf
