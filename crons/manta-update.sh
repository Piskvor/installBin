#!/bin/bash

set -uxo pipefail

DIR_NAME="$(realpath "$(dirname $0)")"
BASE_NAME="$(basename $0 | sed 's/\.sh//')"

cd "${DIR_NAME}" && source ./${BASE_NAME}.rc

_IP=$(hostname -I | sed 's/[[:blank:]]\+$//g;s/ \+[^ ]\+//g;s/[[:blank:]]\+//g') || true

if (echo "${_IP}" | grep -F "${NETWORK_MASK}") ; then
    ZZZZ_URL="https://zzzz.io/api/v1/update/${HOSTNAME}/?token=${TOKEN}&ip=${_IP}"
    timeout 60 curl "$ZZZZ_URL" || true
fi
