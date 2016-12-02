#!/bin/bash

cd `dirname $0`
wget --timestamping https://josm.openstreetmap.de/josm-latest.jar
exit $?

