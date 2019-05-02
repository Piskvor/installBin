#!/bin/bash

set -euxo pipefail

TEMP_FILE="$HOME/tmp/weather/temperature.txt"

if [[ ! -f "${TEMP_FILE}" ]]; then
    echo -n ""
    exit
fi
cd "$(dirname "$0")"

source ./config.getTemperature.rc

cd "$(dirname ${TEMP_FILE})"
wget --quiet --timestamping \
    https://${USER}:${PASSWORD}@dl.piskvor.org/pocasi/history.sqlite

sqlite3 history.sqlite 'SELECT celsius FROM temperature ORDER BY id DESC LIMIT 1' > ${TEMP_FILE}

sqlite3 history.sqlite 'SELECT update_rounded,celsius FROM (SELECT id,update_rounded,celsius FROM temperature ORDER BY id DESC LIMIT 48) ORDER BY id ASC' | jq --slurp --raw-input --raw-output 'split("\n") | .[:-1] | map(split("|")) | map({"datetime": .[0], "celsius": .[1]})' > temperature.json

echo -n 'var temperatures = ' > temperatures.js
cat temperature.json >> temperatures.js
echo -n ';' >> temperatures.js

cat "${TEMP_FILE}"
