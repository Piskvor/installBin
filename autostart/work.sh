#!/bin/bash

set -euxo pipefail

setxkbmap -option grp:alt_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp,altwin:meta_win,caps:escape || true

for i in sdb2 sdc1 sdc2 ; do
	/usr/bin/udisksctl mount -b /dev/$i --no-user-interaction || true
done
echo ''>$HOME/.project/.php_cs.cache || true

#docker swarm init --advertise-addr 10.31.4.1 || true
cd /home/honza/bin/autostart/dockerized/autossh && \
 docker build . --tag piskvor-docker-autossh || true

(
/home/honza/.project_dev/watcher-in-the-water.sh --watch --symbols 3 &
/home/honza/.project_dev/watcher-in-the-water.sh --watch 7 --no-parse &
/home/honza/.project_dev/missing_translations.sh
) &

vboxmanage startvm {cdbd2f92-00f2-4fa7-b2d2-9d1f5e107244} &

cd /home/honza/bin/autostart/dockerized && \
    docker-compose up -d &
