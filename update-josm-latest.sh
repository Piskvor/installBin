#!/bin/bash

ALL=0
if [ "$1" = "--all" ]; then
	ALL=1
fi

PWD=$(dirname $0)
cd $PWD
java -jar $PWD/josm-latest.jar --version
wget --timestamping https://josm.openstreetmap.de/josm-latest.jar
RESULT=$?
if [ "$RESULT" -eq 0 ]; then
	java -jar $PWD/josm-latest.jar --version 
fi
if [ "$ALL" -gt 0 ]; then
	wget --timestamping https://josm.openstreetmap.de/josm-tested.jar
fi
exit $RESULT

