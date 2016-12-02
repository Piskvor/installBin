#!/bin/bash

RESULT="$($* 2>&1)"
if [ $? -gt 0 ]; then
	echo $RESULT
fi
