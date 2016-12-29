#!/bin/bash

ALL=0
if [ "$1" = "--all" ]; then
	ALL=1
fi

cd `dirname $0`
wget --timestamping https://josm.openstreetmap.de/josm-latest.jar
if [ "$ALL" -gt 0 ]; then
	wget --timestamping https://josm.openstreetmap.de/josm-tested.jar
fi
exit $?

