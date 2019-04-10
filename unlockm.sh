#!/bin/bash

# maximum count of successful invocations, after this the computer unlocks
MAXIMUM=5
# at this number of invocations, screen wakes. Should be < $MAXIMUM
POKE_SCREEN=1
# program basename
BASENAME=$(basename $0)

# temp file for watching the invocation counts
FILE=$HOME/tmp/${BASENAME}-count.lock

### do not expect device to be physically connected
## match all from vendor - same device presents different IDs depending on task
#DEVICE_ID="04e8:"
#
## device is connected
#HAS_DEVICE=$(lsusb -d "${DEVICE_ID}" | wc -l)
#if [[ "${HAS_DEVICE}" -lt 1 ]]; then
#	exit 2
#fi

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
if [[ "$COUNTER" -eq "$POKE_SCREEN" ]]; then
	# (xscreensaver-command -deactivate || true) &
	xdotool mousemove_relative --polar 0 1; xdotool mousemove_relative --polar 180 1
	sleep 2
	xset -display :0 dpms force on
	xdotool mousemove_relative --polar 0 1; xdotool mousemove_relative --polar 180 1
fi
if [[ "$COUNTER" -gt "$MAXIMUM" ]]; then
	xset -display :0 dpms force on
	loginctl unlock-session
	xdotool mousemove_relative --polar 0 1; xdotool mousemove_relative --polar 180 1
	qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play
	rm "$FILE"
	sleep 1
	xset -display :0 dpms force on
	xdotool mousemove_relative --polar 0 1; xdotool mousemove_relative --polar 180 1
fi
