#!/usr/bin/env bash

set -euo pipefail

FILE_NAME="josm-latest.jar"
WATCHED_DIR="$HOME/.inst-josm"
WATCHED_FILE="${WATCHED_DIR}/${FILE_NAME}"

INOTIFY_WAIT=$(which inotifywait)
if [ ! -x "$INOTIFY_WAIT" ]; then
        echo "No inotifywait!"
        exit 2
fi

# initial check
FILE_MODIFIED="$FILE_NAME"

while [ 1 ] ; do

    if [[ "$FILE_MODIFIED" = "$FILE_NAME" ]]; then
        CURRENT_VERSION="$(java -jar "${WATCHED_FILE}" --version | grep -F JOSM | sed 's/^.*(//;s/ .*//;s/[^0-9]//')" 2> /dev/null
        PREVIOUS_VERSION="$($HOME/bin/josm-latest --version | grep -F JOSM | sed 's/^.*(//;s/ .*//;s/[^0-9]//')" 2> /dev/null
        if [[ "$CURRENT_VERSION" != "" ]]; then
            if [[ "$PREVIOUS_VERSION" = "" ]] || [[ "$CURRENT_VERSION" -gt "$PREVIOUS_VERSION" ]] ; then
                $HOME/bin/update-josm-latest.sh
            fi
        fi
    fi

	echo "inotifywait for $WATCHED_FILE"
	FILE_MODIFIED="$(${INOTIFY_WAIT} -e create,attrib,close_write,delete "${WATCHED_DIR}/" --format "%f")"

# do not thrash too wildly
sleep 1
done
