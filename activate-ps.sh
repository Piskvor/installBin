#!/bin/bash

WIN_ID=$(xdotool search --name "TeamSpeak 3")
WIN_CURRENT=$(xdotool getactivewindow)
echo $WIN_ID
echo $WIN_CURRENT
if [ "$WIN_ID" != "$WIN_CURRENT" ]; then
	if [ "$WIN_ID" = "" ] ; then
		teamspeak
	else
		xdotool windowactivate "$WIN_ID"
	fi
fi
