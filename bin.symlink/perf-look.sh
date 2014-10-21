#!/bin/bash

if [[ -z $1 ]]; then
    echo "Missing first argument, this should be the data file you want to use"
    exit 1
fi

PERF_DATA=$1
shift

if [[ ${1: -8} == ".tar.bz2" ]]; then
    PERF_CONTEXT_INFO=$1
    if [[ ! -d ~/.debug ]]; then
        mkdir ~/.debug
    fi
    tar xjvf $PERF_CONTEXT_INFO -C ~/.debug
    shift
fi

perf report $@ -i $PERF_DATA
