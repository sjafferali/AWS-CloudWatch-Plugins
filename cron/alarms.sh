#!/bin/bash

source /opt/aws-scripts-mon/cron/.config
rm -fr /var/tmp/aws-mon
sleep 60
ec2_host=$(aws ec2 describe-tags --filter "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"  "Name=key,Values=Name" | grep Value | awk -F'"' '{print$4}')
if [[ ! -z $(echo $ec2_host | grep RAND) ]]
then
	GEN_NUM=$(echo $[ 1 + $[ RANDOM % 100 ]])
	ec2_host=$(echo $ec2_host | sed "s/RAND/$GEN_NUM/")
	aws ec2 create-tags --resources $(curl -s http://169.254.169.254/latest/meta-data/instance-id) --tags Key=Name,Value=$ec2_host
fi
current_host=$(uname -n)

if [[ -z $ec2_host ]]
then
	exit 1
fi

if [[ $ec2_host != $current_host ]]
then
	hostnamectl set-hostname $ec2_host
fi

/opt/aws-scripts-mon/removealarms.sh
echo '#!/bin/bash' > /opt/aws-scripts-mon/removealarms.sh

HOST_NAME=$(uname -n)

if [[ -f /var/tmp/aws-mon/instance-id ]]
then
	INSTANCE=$(cat /var/tmp/aws-mon/instance-id)
else
	INSTANCE=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
fi

find /opt/aws-scripts-mon/plugins/ -type f -name \*.alarms | while read line
do
	plugin=$(echo $line | awk -F/ '{print$5}' | awk -F'.' '{print$1}')
	if [[ $(eval "echo \$$plugin") -eq 1 ]]
	then
		source $line
	fi
done

echo '> /opt/aws-scripts-mon/removealarms.sh' >> /opt/aws-scripts-mon/removealarms.sh
