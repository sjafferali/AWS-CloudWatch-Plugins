#!/bin/bash

if [[ -f /opt/aws-scripts-mon/monitor.lockfile ]]
then
	exit 1
fi

source /opt/aws-scripts-mon/cron/.config
HOST_NAME=$(hostname -s)

find /opt/aws-scripts-mon/plugins/ -type f ! -name \*.alarms | while read line
do
	plugin=$(echo $line | awk -F/ '{print$5}')
        INTERVAL=$(eval "echo \$$plugin")
	if [[ $INTERVAL -ge 1 ]]
	then
		if [[ ! -f /opt/aws-scripts-mon/.schedule/$plugin || $(stat --format=%Y /opt/aws-scripts-mon/.schedule/$plugin) -le $(( $(date +%s) - $INTERVAL )) ]]
		then
			source $line
			touch /opt/aws-scripts-mon/.schedule/$plugin
		fi
	fi
done
