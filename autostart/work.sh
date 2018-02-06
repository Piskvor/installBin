#!/bin/bash

set -euxo pipefail

/usr/bin/udisksctl mount -b /dev/sdb2 --no-user-interaction || true
echo ''>$HOME/.project/.php_cs.cache

cd /home/honza/bin/autostart/dockerized && \
    docker-compose up -d &

(
/home/honza/.project_dev/watcher-in-the-water.sh --watch --symbols 3
/home/honza/.project_dev/watcher-in-the-water.sh --watch 7 --no-parse
) &
