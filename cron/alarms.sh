#!/bin/bash

source /opt/aws-scripts-mon/cron/.config
/opt/aws-scripts-mon/removealarms.sh

echo '#!/bin/bash' > /opt/aws-scripts-mon/removealarms.sh

HOST_NAME=$(hostname -s)

find /opt/aws-scripts-mon/plugins/ -type f -name \*.alarms | while read line
do
       	plugin=$(echo $line | awk -F/ '{print$5}' | awk -F'.' '{print$1}')
        INTERVAL=$(eval "echo \$$plugin")
       	if [[ $INTERVAL -ge 1 ]]
       	then
       		source $line
       	fi
done

echo 'touch /opt/aws-scripts-mon/monitor.lockfile' >> /opt/aws-scripts-mon/removealarms.sh
echo '> /opt/aws-scripts-mon/removealarms.sh' >> /opt/aws-scripts-mon/removealarms.sh
rm -f /opt/aws-scripts-mon/monitor.lockfile
