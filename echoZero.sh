#!/bin/bash

RESULT="$($* 2>&1)"
if [ $? -eq 0 ]; then
	echo $RESULT
fi
