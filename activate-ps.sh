#!/bin/bash

source $HOME/.project_dev/.env_vars

WIN_ID=$(xdotool search "${PROJECT}.*PhpStorm" )
WIN_CURRENT=$(xdotool getactivewindow)
echo $WIN_ID
echo $WIN_CURRENT
if [ "$WIN_ID" != "$WIN_CURRENT" ]; then
	if [ "$WIN_ID" = "" ] ; then
		phpstorm
	else
		xdotool windowactivate "$WIN_ID"
	fi
fi
