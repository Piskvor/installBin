#!/bin/bash

if [ $(pgrep -c vlc) -lt 1 ] ; then
	vlc &
fi
qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause &
