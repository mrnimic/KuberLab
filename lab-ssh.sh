#!/bin/bash

JenkinsHost=44.212.27.44
Worker1Host=18.207.218.21
Worker2Host=54.84.239.96

echo "> Which host you want to login to?"
echo "[1] Jenkins/ContorlPlane"
echo "[2] Worker Node 1"
echo "[3] Worker Node 2"

read NODENUM

if [ "$NODENUM" = 1 ]; then
  ssh ubuntu@$JenkinsHost -i awskey
elif [ "$NODENUM" = 2 ]; then
  ssh ubuntu@$Worker1Host -i awskey
elif [ "$NODENUM" = 3 ]; then
  ssh ubuntu@$Worker2Host -i awskey
else
  echo "> Invalid node number."
  exit 1
fi
