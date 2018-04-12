#!/bin/bash

set -euxo pipefail

setxkbmap -option grp:alt_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp,altwin:meta_win,caps:escape || true

for i in sdb2 sdc1 sdc2 ; do
	mount "/dev/$i" || true
done
echo ''>$HOME/.project/.php_cs.cache || true

#docker swarm init --advertise-addr 10.31.4.1 || true
cd /home/honza/bin/autostart/dockerized/autossh && \
 docker build . --tag piskvor-docker-autossh || true

/home/honza/.project_dev/log-console/watchmen.sh &

vboxmanage startvm {cdbd2f92-00f2-4fa7-b2d2-9d1f5e107244} &

cd /home/honza/bin/autostart/dockerized && \
    docker-compose up -d &
