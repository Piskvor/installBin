#!/bin/bash

if [ "$1" = "" ]; then
	echo 612 > /proc/$$/oom_score_adj
	for i in $(find $HOME/.config/autostart-nice/ -name '*.desktop'); do
		ionice -c2 -n7 nice -n5 $0 ${i} &
	done
	disown -a
else
	echo 613 > /proc/$$/oom_score_adj
	COMMAND=$(grep Exec "$1" | sed 's/Exec=//g;s/%U//g;s/%u//g')
	echo ${COMMAND}
	eval ${COMMAND} &
    CHILD_PID=$!
    sleep 1
	echo 614 > /proc/${CHILD_PID}/oom_score_adj
	disown -a
fi

