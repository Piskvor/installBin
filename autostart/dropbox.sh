#!/bin/sh

for i in 1 2 3; do
	sleep 3
	nice -n 10 /usr/bin/dropbox start
done

nice -n 10 google-drive-ocamlfuse $HOME/google-drive/ &
