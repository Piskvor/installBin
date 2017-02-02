#!/bin/bash

ALL=0
if [ "$1" = "--all" -o "$1" = "-a" ] ; then
	ALL=1
fi

cd $HOME/bin
wget --timestamping https://josm.openstreetmap.de/josm-latest.jar
if [ "$ALL" -gt 0 ]; then
	wget --timestamping https://josm.openstreetmap.de/josm-tested.jar
fi
exit $?

