#!/bin/bash

sudo /usr/bin/systemd-run --slice user-slack.slice --scope nice ionice /home/jmartinec/user-slack
