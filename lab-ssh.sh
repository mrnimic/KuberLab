#!/bin/bash

JenkinsHost=
Worker1Host=
Worker2Host=

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
