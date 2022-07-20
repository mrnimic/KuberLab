#!/bin/bash

chmod +x ./ansible_install.sh
rm -f ./AnsibleInventory
rm -f ./awskey*

echo ">Is this a new Sandbox?(y/n)"
read yn

if [ "$yn" = y ]; then
  echo Please enter AWS Access Key ID:
  read ACCESSKEYID
  echo Please enter AWS Secret Access Key:
  read SECRETACCESSKEY
  aws configure set aws_access_key_id $ACCESSKEYID
  aws configure set aws_secret_access_key $SECRETACCESSKEY
elif [ "$yn" = n ]; then
  echo ">Current account ID and Secret would being used"
else
  echo '>Your answer is not valid. Please set "y" (for YES) and "n" (for NO)'
  exit 1
fi

echo '>Please enter your Stack name:'
read STACKNAME
MYIP=$(curl -s icanhazip.com)
echo ">Your public IP address is $MYIP . This address would being used as the only permitted source IP for SSH."
ssh-keygen -b 2048 -t rsa -f ./awskey -q -N ""
SSHKEY=$(cat ./awskey.pub)
echo ">New SSH key has been created. This key would being used as your ssh key to login instances."
IPLEN=$(curl -s icanhazip.com | wc -c | tr -d ' ')

STACKSTATUS=$(aws cloudformation list-stacks --query "StackSummaries[?StackName == '${STACKNAME}'].StackStatus | [0]")

if [[ "$STACKSTATUS" == '"ROLLBACK_COMPLETE"' ]];then
  echo ">This Stack name has been created before, and has \"ROLLBACK_COMPLETE\" status. Please choose a different Stack name."
  exit 1
fi

if [[ "$STACKSTATUS" == "null" ]] || [[ "$STACKSTATUS" == '"CREATE_FAILED"' ]] || [[ "$STACKSTATUS" == '"DELETE_COMPLETE"' ]]; then
  echo ">This is a new Stack. Let's create it ... "
  echo '>Waiting to create Stack ...'
  if [ "$IPLEN" -gt 17 ];then
    echo ">Your IP address is IPV6"
    aws cloudformation create-stack --stack-name $STACKNAME --template-body file://EC2Instance.yml --parameters ParameterKey=SshKeyPair,ParameterValue="$SSHKEY" ParameterKey=SshSourceIpV6,ParameterValue="$MYIP/128" && aws cloudformation wait stack-create-complete --stack-name $STACKNAME
  else
    echo ">Your IP address is IPV4"
    aws cloudformation create-stack --stack-name $STACKNAME --template-body file://EC2Instance.yml --parameters ParameterKey=SshKeyPair,ParameterValue="$SSHKEY" ParameterKey=SshSourceIpV4,ParameterValue="$MYIP/32" && aws cloudformation wait stack-create-complete --stack-name $STACKNAME
  fi
elif [[ "$STACKSTATUS" == '"UPDATE_ROLLBACK_COMPLETE"' ]] || [[ "$STACKSTATUS" == '"CREATE_COMPLETE"' ]] || [[ "$STACKSTATUS" == '"UPDATE_COMPLETE"' ]] || [[ "$STACKSTATUS" == '"UPDATE_FAILED"' ]]; then
  echo ">This Stack has already been deployed. Let's update it ... "
  echo '>Waiting to update Stack ...'
  if [ "$IPLEN" -gt 17 ];then
    aws cloudformation update-stack --stack-name $STACKNAME --template-body file://EC2Instance.yml --parameters ParameterKey=SshKeyPair,ParameterValue="$SSHKEY" ParameterKey=SshSourceIpV6,ParameterValue="$MYIP/128" && aws cloudformation wait stack-update-complete --stack-name $STACKNAME
  else
    aws cloudformation update-stack --stack-name $STACKNAME --template-body file://EC2Instance.yml --parameters ParameterKey=SshKeyPair,ParameterValue="$SSHKEY" ParameterKey=SshSourceIpV4,ParameterValue="$MYIP/32" && aws cloudformation wait stack-update-complete --stack-name $STACKNAME
  fi
else
  echo \>Stack status is "$STACKSTATUS"
  exit 1
fi

echo ">Resource creation is done!"

echo "[k8sControlPlane-Jenkins]" >> ./AnsibleInventory
aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'JenkinsPublicIP'].OutputValue" --output text >> ./AnsibleInventory
echo "[k8sWorkers]" >> ./AnsibleInventory
aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'Worker1PublicIP'].OutputValue" --output text >> ./AnsibleInventory
aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'Worker2PublicIP'].OutputValue" --output text >> ./AnsibleInventory

echo installing Ansible ...
sh ./ansible_install.sh