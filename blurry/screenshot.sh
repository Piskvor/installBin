#!/bin/bash

set -euxo pipefail

cd "$HOME/tmp" && mkdir -m 700 -p desktop && cd desktop && mkdir -m700 -p blurry

TEMP_SCREENSHOT="$(pwd)/sharp.png"
FINAL_SCREENSHOT="$(pwd)/blurry/out.png"

import -window root "${TEMP_SCREENSHOT}"
#-crop 1920x1080+1081+0
convert "${TEMP_SCREENSHOT}" -blur 0x5 "${FINAL_SCREENSHOT}"
shred -u "${TEMP_SCREENSHOT}"
