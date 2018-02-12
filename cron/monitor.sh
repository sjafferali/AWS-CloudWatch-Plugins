#!/bin/bash

# This is for https://bugzilla.redhat.com/show_bug.cgi?id=1044666
NSS_SDB_USE_CACHE=YES

if [[ -f /opt/aws-scripts-mon/monitor.lockfile ]]
then
	exit 1
fi

source /opt/aws-scripts-mon/cron/.config
HOST_NAME=$(uname -n)

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
