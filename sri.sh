#!/bin/bash

set -euxo pipefail

HASH=$(openssl dgst -sha384 -binary "$1" | openssl base64 -A)

echo -n '<script src="'
echo -n $(basename $1)
echo -n '" integrity="sha384-'
echo -n ${HASH}
echo '" crossorigin="anonymous"></script>'
