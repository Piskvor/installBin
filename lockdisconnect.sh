#!/bin/bash

# maximum count of successful invocations, after this the computer locks
MAXIMUM=5
# program basename
BASENAME=$(basename $0)
# match all from vendor - same device presents different IDs depending on task
DEVICE_ID="04e8:"

# temp file for watching the invocation counts
FILE=$HOME/tmp/${BASENAME}-count.lock
echo $FILE

while [ 1 ]; do
	sleep 3
# device is connected
HAS_DEVICE=$(lsusb -d "${DEVICE_ID}" | wc -l)
if [ "$HAS_DEVICE" -gt 0 ]; then
	if [ ! -f "$FILE" ]; then
		echo '' > "$FILE"
	fi
	echo "is connected"
	continue;
fi

if [ ! -f "$FILE" ]; then
	# create file
	echo "no file"
	continue
fi

COUNTER=0
# load the temp file
. "$FILE"
# increment the counter
COUNTER=$(($COUNTER + 1))
# save back to temp file
echo $COUNTER
echo "COUNTER=$COUNTER">"$FILE"

# unlock if maximum invocations reached
if [ "$COUNTER" -gt "$MAXIMUM" ]; then
	loginctl lock-session
	rm "$FILE"
fi
done
