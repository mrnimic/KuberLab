#!/bin/bash

rm -f ./AnsibleInventory

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
MYIP=$(curl icanhazip.com)
echo "Your public IP address is $MYIP . This address would being used as the only permitted source IP for SSH."
ssh-keygen -b 2048 -t rsa -f ./awskey -q -N ""
SSHKEY=$(cat ./awskey.pub)
echo "New SSH key has been created. This key would being used as your ssh key to login instances."

STACKSTATUS=$(aws cloudformation list-stacks --query "StackSummaries[?StackName == '${STACKNAME}'].StackStatus | [0]")

if [ "$STACKSTATUS" == "null" ] || [ "$STACKSTATUS" == "CREATE_FAILED"]; then
  echo "This is a new Stack. Let's create it ... "
  echo 'Waiting to create Stack ...'
  aws cloudformation create-stack --stack-name $STACKNAME --template-body file://EC2Instance.yml --parameters ParameterKey=SshKeyPair,ParameterValue=$SSHKEY ParameterKey=SshSourceIp,ParameterValue=$MYIP && aws cloudformation wait stack-create-complete --stack-name $STACKNAME
elif [ "$STACKSTATUS" == "UPDATE_ROLLBACK_COMPLETE" ] || [ "$STACKSTATUS" == "CREATE_COMPLETE" ] || [ "$STACKSTATUS" == "UPDATE_COMPLETE" ] || [ "$STACKSTATUS" == "UPDATE_FAILED" ]; then
  echo "This Stack has already been deployed. Let's update it ... "
  echo 'Waiting to update Stack ...'
  aws cloudformation update-stack --stack-name $STACKNAME --template-body file://EC2Instance.yml --parameters ParameterKey=SshKeyPair,ParameterValue=$SSHKEY ParameterKey=SshSourceIp,ParameterValue=$MYIP && aws cloudformation wait stack-update-complete --stack-name $STACKNAME
else
  echo "Stack status is $STACKSTATUS"
  exit 1
fi

echo "Resource creation is done!"

echo "[Bastion]" > ./AnsibleInventory
aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'BastionPublicIP'].OutputValue" --output text >> ./AnsibleInventory
echo "[Jenkins]" >> ./AnsibleInventory
aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'BastionPublicIP'].OutputValue" --output text >> ./AnsibleInventory
echo "[k8s-ControlPlane]" >> ./AnsibleInventory
aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'BastionPublicIP'].OutputValue" --output text >> ./AnsibleInventory
echo "[k8s-workers]" >> ./AnsibleInventory
aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'BastionPublicIP'].OutputValue" --output text >> ./AnsibleInventory
aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'BastionPublicIP'].OutputValue" --output text >> ./AnsibleInventory
