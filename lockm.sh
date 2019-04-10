#!/bin/bash

~/bin/blurry/screenshot.sh || true
qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause &

loginctl lock-session
