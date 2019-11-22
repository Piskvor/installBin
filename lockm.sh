#!/bin/bash
qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause &
"$HOME/bin/blurry/screenshot.sh" || true

loginctl lock-session

ssh -t rpi -oConnectTimeout=5 -- xdotool key Pause
