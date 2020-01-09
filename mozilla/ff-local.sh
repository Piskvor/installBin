#!/bin/bash

set -euo pipefail
set -x

export DISPLAY=:0
firefox --new-tab "$@"
