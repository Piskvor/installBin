#!/bin/bash

set -euxo pipefail

for i in sdb2 sdc1 sdc2 ; do
	/usr/bin/udisksctl mount -b /dev/$i --no-user-interaction || true
done
echo ''>$HOME/.project/.php_cs.cache

#docker swarm init --advertise-addr 10.42.0.1 || true
cd /home/honza/bin/autostart/dockerized/autossh && \
 docker build . --tag piskvor-docker-autossh

cd /home/honza/bin/autostart/dockerized && \
    docker-compose up -d &

(
/home/honza/.project_dev/watcher-in-the-water.sh --watch --symbols 3
/home/honza/.project_dev/watcher-in-the-water.sh --watch 7 --no-parse
) &
