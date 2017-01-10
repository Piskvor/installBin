#!/bin/sh

for i in 1 2 3; do
	sleep 3
	/usr/bin/dropbox start
done

google-drive-ocamlfuse $HOME/google-drive/ &
