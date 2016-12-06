#!/bin/bash

WATCHFILE=/run/shm/pluggedKB
#touch $WATCHFILE

INOTIFYWAIT=$(which inotifywait)
RUN_COMMAND=$HOME/bin/evr-start
if [ ! -x "$INOTIFYWAIT" ]; then
	echo "No inotifywait!"
	exit 2
fi

while [ -f "$WATCHFILE" ]; do
	${RUN_COMMAND} $*
	# wait for stuff to happen
	${INOTIFYWAIT} -e open "$WATCHFILE"
	sleep 1
done
