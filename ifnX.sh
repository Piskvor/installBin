#!/bin/bash

# cleanup function - otherwise SIGINT would just stop the current step in the toolchain and proceed to the next (which would produce bogus data)
cleanup() {
    echo $RESULTTEXT
    exit 3
}

# trap SIGINT and SIGTERM: call cleanup()
trap cleanup INT TERM

export RESULTTEXT=$($* 2>&1)
R=$?
if [ $R -ne 0 -a $R -ne 1 ]; then
	echo $RESULTTEXT
fi
exit $R
