#!/bin/bash
sleep 5

#killall gpg-agent
#eval $(gpg-agent --enable-ssh-support --daemon)
export SSH_ASKPASS=/usr/bin/ksshaskpass
ssh-add </dev/null

SSH_FS=$HOME/bin/autostart/sshfs.sh

if [[ -x "$SSH_FS" ]]; then
	exec "$SSH_FS"
fi
