#!/bin/bash

id=$1
key=$2
instance=$3

if AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key aws ec2 describe-instances --instance-id $instance | grep 'running' -q; then
        echo "STATUS: Server is running but is unreachable"
        AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key aws ec2 reboot-instances --instance-id $instance
        echo "ACTION: Restarting Server"

elif AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key aws ec2 describe-instances --instance-id $instance | grep 'stopping\|shutting-down' -q; then
        echo "STATUS: Server is Shutting Down or Stopping"
        echo "ACTION: Waiting before checking again"
        sleep 30
        x=1
        while [ $x -le 3 ]; do
                if AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key aws ec2 describe-instances --instance-id $instance | grep 'stopping\|shutting-down' -q; then
                        echo "STATUS: Server is Still Shutting Down or Stopping"
                        echo "ACTION: Waiting before checking again"
                        x=$((x+1))
                        sleep 30
                elif AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key aws ec2 describe-instances --instance-id $instance | grep 'stopped' -q; then
                        echo "STATUS: Server has stopped and is unreachable"
                        AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key aws ec2 start-instances --instance-id $instance
                        echo "ACTION: Starting Server"
                        break
                else
                        echo "DEBUG: Could not grep a status from describe-instances"
                fi
        done
        if [ $x -lt 3 ]; then
                echo "DEBUG: Stopping check and Startup finished"
        els
                echo "DEBUG: Waiting checks timed out and server was not started"
        fi

elif AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key aws ec2 describe-instances --instance-id $instance | grep 'stopped' -q; then
        echo "STATUS: Server has stopped and is unreachable"
        AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key aws ec2 start-instances --instance-id $instance
        echo "ACTION: Starting Server"

elif AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key aws ec2 describe-instances --instance-id $instance | grep 'pending' -q; then
        echo "DEBUG: Server already starting"

elif AWS_ACCESS_KEY_ID=$id AWS_SECRET_ACCESS_KEY=$key aws ec2 describe-instances --instance-id $instance | grep 'terminated' -q; then
        echo "DEBUG: This instance no longer exists"

else
        echo "DEBUG: Could not grep a status from describe-instances"

fi
echo "Script ended"

