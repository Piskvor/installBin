#!/bin/bash

# maximum count of successful invocations, after this the computer unlocks
MAXIMUM=3
# at this number of invocations, screen wakes. Should be < $MAXIMUM
POKE_SCREEN=1
# program basename
BASENAME="$(basename "$0")"

wiggle_mouse() {
  xdotool mousemove_relative --polar 0 1
  xdotool mousemove_relative --polar 180 1
}

display_on() {
  xset -display :0 dpms force on
}

# temp file for watching the invocation counts
INVOCATION_COUNT_FILE=$HOME/tmp/${BASENAME}-count.lock

### do not expect device to be physically connected
## match all from vendor - same device presents different IDs depending on task
#DEVICE_ID="04e8:"
#
## device is connected
#HAS_DEVICE=$(lsusb -d "${DEVICE_ID}" | wc -l)
#if [[ "${HAS_DEVICE}" -lt 1 ]]; then
#	exit 2
#fi

if [[ ! -f "$INVOCATION_COUNT_FILE" ]]; then
  # create file
  touch "$INVOCATION_COUNT_FILE"
else
  # delete file if not touched for a moment
  # you need to invoke the script within this time again
  find "$INVOCATION_COUNT_FILE" -not -newermt '-2seconds' -print -delete
  touch "$INVOCATION_COUNT_FILE"
fi

COUNTER=0
# load the temp file
# shellcheck disable=SC1090
. "$INVOCATION_COUNT_FILE"
# increment the counter
COUNTER=$((COUNTER + 1))
# save back to temp file
echo "COUNTER=$COUNTER" >"$INVOCATION_COUNT_FILE"

# unlock if maximum invocations reached
if [[ "$COUNTER" -eq "$POKE_SCREEN" ]]; then
  # (xscreensaver-command -deactivate || true) &
  wiggle_mouse
  sleep 2
  display_on
  wiggle_mouse
fi
if [[ "$COUNTER" -gt "$MAXIMUM" ]]; then
  xset -display :0 dpms force on
  loginctl unlock-session
  wiggle_mouse
  rm "$INVOCATION_COUNT_FILE"
  display_on
  wiggle_mouse
  sleep 5
  qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play
fi
