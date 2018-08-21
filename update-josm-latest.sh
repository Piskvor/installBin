#!/bin/bash

set -euo pipefail

LATEST_NAME="josm-latest.jar"
CURRENT_NAME="josm-tested.jar"
V7_NAME="josm-snapshot-10526.jar"
V6_NAME="josm-snapshot-7000.jar"
CANONICAL_BASE_URL="https://josm.openstreetmap.de/download"
LOCAL_BASE_URL="https://inst.piskvor.org/josm"
BASE_URL=${LOCAL_BASE_URL}

WGET_OPTIONS="--timestamping --no-verbose"

if [ "$(hostname)" = "tulen" ]; then
    BASE_URL=${CANONICAL_BASE_URL}
fi

if [ ! -x "$(which java)" ]; then
    function java() {
        echo "no java $*"
    }
fi

ALL=0
if [ "${1:-}" = "--all" ]; then
	ALL=1
fi

CURRENT_PWD=$(dirname $0)
cd ${CURRENT_PWD}
./josm-latest --version || true
echo "${BASE_URL}/${LATEST_NAME}" "${LOCAL_BASE_URL}/josm" "${LOCAL_BASE_URL}/josm-options.local"  "${LOCAL_BASE_URL}/java-proxy-options.sh"   "${LOCAL_BASE_URL}/update-josm-latest.sh" \
    | tr " " '\n'\
	| wget ${WGET_OPTIONS} -i -
RESULT=$?
if [ "${RESULT:-1}" -eq 0 ]; then
	./josm-latest --version || true
fi
if [ "$ALL" -gt 0 ]; then
    for i in  "${CURRENT_NAME}" "${V7_NAME}" "${V6_NAME}" ; do
	    echo "${BASE_URL}/${i}"
    done \
    | tr " " '\n'\
	| wget ${WGET_OPTIONS} -i - && \
	./josm --version || true
fi
exit ${RESULT}

