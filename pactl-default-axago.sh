#!/bin/bash

DEFAULT_SOURCE=$(pactl list short sources | grep input | grep 'C-Media_USB' | cut -f1)
if [ $? -gt 0 ]; then
	exit 1
fi
DEFAULT_SINK=$(pactl list short sinks |grep output | grep 'C-Media_USB' | cut -f1)
if [ $? -gt 0 ]; then
	exit 1
fi

if [ "${DEFAULT_SOURCE}" -ge 0 ]; then
	pactl set-default-source $DEFAULT_SOURCE
fi
if [ "${DEFAULT_SINK}" -ge 0 ]; then
	pactl set-default-sink $DEFAULT_SINK
fi
