#!/bin/bash
aws cloudwatch delete-alarms --alarm-names RAM-jump.revmax.com
aws cloudwatch delete-alarms --alarm-names Disk-jump.revmax.com-/
aws cloudwatch delete-alarms --alarm-names CPU-jump.revmax.com
aws cloudwatch delete-alarms --alarm-names Load-jump.revmax.com
aws cloudwatch delete-alarms --alarm-names IOWait-jump.revmax.com
aws cloudwatch delete-alarms --alarm-names StatusCheckFailed_Instance-jump.revmax.com
aws cloudwatch delete-alarms --alarm-names StatusCheckFailed_System-jump.revmax.com
> /opt/aws-scripts-mon/removealarms.sh
