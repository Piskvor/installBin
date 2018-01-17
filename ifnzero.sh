#!/bin/bash

RESULTTEXT=$($* 2>&1)
R=$?
if [ $R -ne 0 ]; then
	echo $RESULTTEXT
fi
exit $R
