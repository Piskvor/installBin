#!/bin/bash
qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause &
~/bin/blurry/screenshot.sh || true

loginctl lock-session
