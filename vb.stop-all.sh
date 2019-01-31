#!/bin/bash
set -euxo pipefail

NO_SNAPSHOT=${1:-}

LIST="$(vboxmanage list runningvms | cut '-d ' -f2)"
DATE="$(date)"
if [[ "$LIST" != "" ]]; then
    for UUID in $LIST ; do
        vboxmanage controlvm "$UUID" savestate
        if [[ "$NO_SNAPSHOT" != "--no-snapshot" ]]; then
            vboxmanage snapshot "$UUID" take "$DATE"
        fi
    done
fi

