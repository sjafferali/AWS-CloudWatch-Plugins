#!/bin/bash

if [[ -f /var/tmp/aws-mon/instance-id ]]
then
       	INSTANCE=$(cat /var/tmp/aws-mon/instance-id)
else
       	INSTANCE=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
fi

source /opt/aws-scripts-mon/cron/.config
touch /opt/aws-scripts-mon/removealarms.sh
chmod 700 /opt/aws-scripts-mon/removealarms.sh

/opt/aws-scripts-mon/removealarms.sh

echo '#!/bin/bash' > /opt/aws-scripts-mon/removealarms.sh

HOST_NAME=$(uname -n)

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

