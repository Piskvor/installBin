#!/bin/bash

set -euo pipefail

TEMP_FILE="$HOME/tmp/temperature.txt"

if [[ ! -f "${TEMP_FILE}" ]]; then
    echo -n ""
    exit
fi
cd "$(dirname "$0")"

source ./config.getTemperature.rc

cd "$(dirname ${TEMP_FILE})"
wget --quiet --timestamping https://${USER}:${PASSWORD}@dl.piskvor.org/pocasi/temperature.txt

cat "${TEMP_FILE}"
