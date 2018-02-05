#!/bin/bash

set -euxo pipefail

/usr/bin/udisksctl mount -b /dev/sdb2 --no-user-interaction || true
echo ''>$HOME/.project/.php_cs.cache

cd /home/honza/bin/autostart/dockerized && \
    docker-compose up


