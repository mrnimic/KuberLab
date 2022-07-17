#!/bin/bash

echo "Is this a new Sandbox?(y/n)"
read yn

if [ "$yn" = y ]; then
  echo Please enter AWS Access Key ID:
  read ACCESSKEYID
  echo Please enter AWS Secret Access Key:
  read SECRETACCESSKEY
  aws configure set aws_access_key_id $ACCESSKEYID
  aws configure set aws_secret_access_key $SECRETACCESSKEY
elif [ "$yn" = n ]; then
  echo "Current account ID and Secret would being used"
else
  echo 'Your answer is not valid. Please set "y" (for YES) and "n" (for NO)'
  exit 1
fi

echo 'Please enter your Stack name:'
read STACKNAME

STACKSTATUS=$(aws cloudformation list-stacks --query "StackSummaries[?StackName == '${STACKNAME}'].StackStatus | [0]")

if [ "$STACKSTATUS" == "null" ]; then
  echo "This is a new Stack. Let's create it ... "
  aws cloudformation create-stack --stack-name $STACKNAME --template-body file://EC2Instance.yml
  echo 'Waiting to create Stack ...'
  aws cloudformation wait stack-update-complete --stack-name $STACKNAME
else
  echo "This Stack has already been deployed. Let's update it ... "
  aws cloudformation update-stack --stack-name $STACKNAME --template-body file://EC2Instance.yml
  echo 'Waiting to update Stack ...'
  aws cloudformation wait stack-update-complete --stack-name $STACKNAME
fi


echo "Done!"
