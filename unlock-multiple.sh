#!/bin/bash

MAXIMUM=5
BASENAME=$(basename $0)

FILE=$HOME/tmp/${BASENAME}-count.lock


if [ ! -f "$FILE" ]; then
	touch "$FILE"
else
	# delete if older
	find "$FILE" -not -newermt '-22seconds' -print -delete
	touch "$FILE"
fi

COUNTER=0
. "$FILE"
COUNTER=$(($COUNTER + 1))
echo "COUNTER=$COUNTER">"$FILE"

if [ "$COUNTER" -gt "$MAXIMUM" ]; then
	loginctl unlock-session
	rm "$FILE"
fi
