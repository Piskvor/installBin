#!/bin/bash

set -euxo pipefail

cd "$HOME/tmp" && mkdir -m 700 -p desktop && cd desktop && mkdir -m700 -p blurry

TEMP_SCREENSHOT="$(pwd)/sharp.png"
TEMP_SCREENSHOT_TEMPLATE="$(pwd)/blurry/sharp"
FINAL_SCREENSHOT_TEMPLATE="$(pwd)/blurry/out"
SCREENSHOT_POSTFIX=".png"

rm ${TEMP_SCREENSHOT_TEMPLATE}* ${FINAL_SCREENSHOT_TEMPLATE}*

import -window root "${TEMP_SCREENSHOT}"

if (identify "${TEMP_SCREENSHOT}" | grep 3000x1920) ; then
    convert "${TEMP_SCREENSHOT}" -gravity East -chop 1920x0 "${TEMP_SCREENSHOT_TEMPLATE}-1${SCREENSHOT_POSTFIX}"
    convert "${TEMP_SCREENSHOT}" -gravity SouthWest -chop 1080x1080 "${TEMP_SCREENSHOT_TEMPLATE}-2${SCREENSHOT_POSTFIX}"
fi
for i in ${TEMP_SCREENSHOT_TEMPLATE}* ; do
    j="$(echo ${i} | sed 's/sharp/out/')"
    convert "${i}" -blur 0x5 "$j"
done
#shred -u "${TEMP_SCREENSHOT}"
