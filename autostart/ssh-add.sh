#!/bin/sh
sleep 5
export SSH_ASKPASS=/usr/bin/ksshaskpass
ssh-add </dev/null

SSHFS=$HOME/bin/autostart/sshfs.sh

if [ -x "$SSHFS" ]; then
	$SSHFS
fi
