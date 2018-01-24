#!/bin/bash

set -euxo pipefail 
DEFAULT_SOURCE=$(pactl list short sources | grep input | grep -v 'C-Media_USB' | head -n1 | cut -f1)
AXAGO_SOURCE=$(pactl list short sources | grep input | grep 'C-Media_USB' | head -n1 | cut -f1)
if [ $? -gt 0 ]; then
	exit 1
fi
DEFAULT_SINK=$(pactl list short sinks |grep output | grep -v 'C-Media_USB' | head -n1 | cut -f1)
AXAGO_SINK=$(pactl list short sinks |grep output | grep 'C-Media_USB' | head -n1 | cut -f1)
if [ $? -gt 0 ]; then
	exit 1
fi
if [ "${DEFAULT_SOURCE}" -ge 0 ] || [ "${DEFAULT_SINK}" -ge 0 ]; then
    # wiggle the settings - there seems to be no event dispatched if it's already set to Axago
    if [ "${DEFAULT_SOURCE}" -ge 0 ] ; then
        pactl set-default-source $DEFAULT_SOURCE
    fi
    if [ "${DEFAULT_SINK}" -ge 0 ]; then
        pactl set-default-sink $DEFAULT_SINK
    fi
    sleep 1
fi

if [ "${AXAGO_SOURCE}" -ge 0 ]; then
	pactl set-default-source $AXAGO_SOURCE
fi
if [ "${AXAGO_SINK}" -ge 0 ]; then
	pactl set-default-sink $AXAGO_SINK
fi
