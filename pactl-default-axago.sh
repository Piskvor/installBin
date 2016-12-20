#!/bin/bash

DEFAULT_SOURCE=$(pactl list short sources | grep 'C-Media_USB' | cut -f1)
DEFAULT_SINK=$(pactl list short sinks | grep 'C-Media_USB' | cut -f1)

if [ "$DEFAULT_SOURCE" -gt 0 ]; then
	pactl set-default-source $DEFAULT_SOURCE
fi
if [ "$DEFAULT_SINK" -gt 0 ]; then
	pactl set-default-sink $DEFAULT_SINK
fi
