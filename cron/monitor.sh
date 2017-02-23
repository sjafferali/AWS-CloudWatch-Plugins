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
	if [[ $(eval "echo \$$plugin") -eq 1 ]]
	then
		source $line
	fi
done
