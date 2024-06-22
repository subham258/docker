#!/bin/bash
set -e
 
 
REGION=$1
APP=$2
ENVIRONMENT=$3
 
INSTANCE_LIST=$(/usr/local/bin/aws ec2 describe-instances --region $REGION --filters "Name=tag:Owner,Values=$APP" "Name=tag:Environment,Values=$ENVIRONMENT" --query "Reservations[].Instances[].[join('-', [Tags[?Key=='Name'].Value | [0],State.Name,PrivateIpAddress])]" --output text)
 
 
# Loop through the instances and print them in the desired pattern
while IFS= read -r instance; do
        echo "$instance"
done <<< "$INSTANCE_LIST"
