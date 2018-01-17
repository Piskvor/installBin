#!/bin/bash

RESULTTEXT=$($* 2>&1)
R=$?
if [ $R -eq 0 ]; then
	echo $RESULTTEXT
fi
exit $R
