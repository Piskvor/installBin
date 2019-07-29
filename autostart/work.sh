#!/bin/bash

set -euxo pipefail

#(xscreensaver -nosplash || true) &

systemctl enable --now --user labtunnel@mrog-fwd

mkdir -p $HOME/tmp/weather/ || true
touch $HOME/tmp/weather/temperature.txt || true

#setxkbmap -layout us,cz_qwerty -option grp:alt_caps_toggle,grp_led:scroll,terminate:ctrl_alt_bksp,altwin:meta_win,caps:escape || true

for i in sdb2 sdc1 sdc2 ; do
	mount "/dev/$i" || true
done
echo ''>$HOME/.project/.php_cs.cache || true

#docker swarm init --advertise-addr 10.31.4.1 || true
cd /home/honza/bin/autostart/dockerized/autossh && \
 docker build . --tag piskvor-docker-autossh || true

cd /home/honza/bin/autostart/dockerized/dropbox && \
 docker build . --tag piskvor-docker-dropbox || true

cd /home/honza/bin/autostart/dockerized && \
    docker-compose up -d &

cd /home/honza/.project && \
    docker-compose up -d postgres rabbitmq redis netflow nginx &

/home/honza/bin/autostart/evrouter-loop.sh &

#(
#    docker run -d -p 9000:9000 \
#       -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer \
#       --no-auth --no-snapshot || true
#) &


# vboxmanage startvm "{cdbd2f92-00f2-4fa7-b2d2-9d1f5e107244}" &

/home/honza/.dev/log-console/watchmen.sh &

#/home/honza/bin/autostart/josm-inotify.sh &

env PLAY_SOUND=no /home/honza/.dev/lints.sh --with-stan

#(ssh -nX hamster -- bash -c 'hamster-indicator; sudo poweroff' &)

vboxmanage startvm "{9e573485-34ab-4cb7-a954-4306fa7508ee}" --type headless &
