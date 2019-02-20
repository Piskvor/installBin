#!/bin/bash

# maximum count of successful invocations, after this the computer unlocks
MAXIMUM=5
# program basename
BASENAME=$(basename $0)
# match all from vendor - same device presents different IDs depending on task
DEVICE_ID="04e8:"

# temp file for watching the invocation counts
FILE=$HOME/tmp/${BASENAME}-count.lock

# device is connected
HAS_DEVICE=$(lsusb -d "${DEVICE_ID}" | wc -l)
if [[ "$DEVICE_ID" -lt 1 ]]; then
	exit 2
fi

if [[ ! -f "$FILE" ]]; then
	# create file
	touch "$FILE"
else
	# delete file if not touched for a moment
	# you need to invoke the script within this time again
	find "$FILE" -not -newermt '-2seconds' -print -delete
	touch "$FILE"
fi

COUNTER=0
# load the temp file
. "$FILE"
# increment the counter
COUNTER=$(($COUNTER + 1))
# save back to temp file
echo "COUNTER=$COUNTER">"$FILE"

# unlock if maximum invocations reached
if [[ "$COUNTER" -gt "$MAXIMUM" ]]; then
	# (xscreensaver-command -deactivate || true) &
	loginctl unlock-session
	sleep 2
	xset -display :0 dpms force on
	qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play
	rm "$FILE"
	sleep 1
	xset -display :0 dpms force on
	xdotool mousemove_relative --polar 0 1; xdotool mousemove_relative --polar 180 1
fi
