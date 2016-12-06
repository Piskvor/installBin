#!/bin/sh
sleep 5
export SSH_ASKPASS=/usr/bin/ksshaskpass
ssh-add </dev/null
