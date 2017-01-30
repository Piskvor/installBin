#!/bin/bash

ionice -c3 nice -n15 php -S localhost:8080 -t $HOME/prog/ &
disown -a
