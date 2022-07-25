#!/bin/bash

chmod +x ./ansible_install.sh
rm -f ./AnsibleInventory
HOMEDIR=$(echo $HOME)

#Installing awscli V2 on this machine
if [[ $(command -v aws) ]]; then
  echo ">awscli is already installed."
else
  echo ">awscli is not installed. Installing ..."
  sudo apt update && sudo apt install -y curl unzip
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOMEDIR/awscliv2.zip"
  unzip $HOMEDIR/awscliv2.zip -d $HOMEDIR
  sudo $HOMEDIR/aws/install -b /usr/local/bin
  sudo echo "complete -C '/usr/local/bin/aws_completer' aws" >> $HOMEDIR/.bashrc
  source $HOMEDIR/.bashrc
  aws configure set default.region us-east-1
fi

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
echo ">Your public IP address is $MYIP . This address will be used as the only permitted source IP for SSH."
SSHKEY=$(cat ./awskey.pub)
echo ">New SSH key has been created. This key will be used as your ssh key to login instances."
IPLEN=$(curl -s icanhazip.com | wc -c | tr -d ' ')

STACKSTATUS=$(aws cloudformation list-stacks --query "StackSummaries[?StackName == '${STACKNAME}'].StackStatus | [0]")

if [[ "$STACKSTATUS" == '"ROLLBACK_COMPLETE"' ]];then
  echo ">This Stack name has been created before, and has \"ROLLBACK_COMPLETE\" status. Please choose a different Stack name."
  exit 1
fi

if [[ "$STACKSTATUS" == "null" ]] || [[ "$STACKSTATUS" == '"CREATE_FAILED"' ]] || [[ "$STACKSTATUS" == '"DELETE_COMPLETE"' ]]; then
  echo ">This is a new Stack. Let's create it ... "
  if [ "$IPLEN" -gt 17 ];then
    echo ">Your IP address is IPV6. Please change your IP address or internet provider."
    exit 1
  else
    echo ">Your IP address is IPV4. Waiting to create Stack ..."
    rm -f ./awskey*
    ssh-keygen -b 2048 -t rsa -f ./awskey -q -N ""
    SSHKEY=$(cat ./awskey.pub)
    aws cloudformation create-stack --stack-name $STACKNAME --template-body file://cf-kuberlab.yml --parameters ParameterKey=SshKeyPair,ParameterValue="$SSHKEY" ParameterKey=SshSourceIpV4,ParameterValue="$MYIP/32" && aws cloudformation wait stack-create-complete --stack-name $STACKNAME
  fi
elif [[ "$STACKSTATUS" == '"UPDATE_ROLLBACK_COMPLETE"' ]] || [[ "$STACKSTATUS" == '"CREATE_COMPLETE"' ]] || [[ "$STACKSTATUS" == '"UPDATE_COMPLETE"' ]] || [[ "$STACKSTATUS" == '"UPDATE_FAILED"' ]]; then
  echo ">This Stack has already been deployed. Let's update it ... "
  echo '>Waiting to update Stack ...'
  if [ "$IPLEN" -gt 17 ];then
    echo ">Your IP address is IPV6. Please change your IP address or internet provider."
    exit 1
  else
    echo ">Your IP address is IPV4. Waiting to create Stack ..."
    rm -f ./awskey*
    ssh-keygen -b 2048 -t rsa -f ./awskey -q -N ""
    SSHKEY=$(cat ./awskey.pub)
    aws cloudformation update-stack --stack-name $STACKNAME --template-body file://cf-kuberlab.yml --parameters ParameterKey=SshKeyPair,ParameterValue="$SSHKEY" ParameterKey=SshSourceIpV4,ParameterValue="$MYIP/32" && aws cloudformation wait stack-update-complete --stack-name $STACKNAME
  fi
else
  echo \>Stack status is "$STACKSTATUS"
  exit 1
fi

JENKINS_PUBIP=$(aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'JenkinsPublicIP'].OutputValue" --output text)
JENKINS_PRIVIP=$(aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'JenkinsPrivateIP'].OutputValue" --output text)
WORKER1_PUBIP=$(aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'Worker1PublicIP'].OutputValue" --output text)
WORKER1_PRIVIP=$(aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'Worker1PrivateIP'].OutputValue" --output text)
WORKER2_PUBIP=$(aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'Worker2PublicIP'].OutputValue" --output text)
WORKER2_PRIVIP=$(aws cloudformation describe-stacks --stack-name $STACKNAME --query "Stacks[0].Outputs[?OutputKey == 'Worker2PrivateIP'].OutputValue" --output text)


echo "[k8sControlPlane-Jenkins]" >> ./AnsibleInventory
echo "Jenkins ansible_host=$JENKINS_PUBIP" >> ./AnsibleInventory
echo "[k8sWorkers]" >> ./AnsibleInventory
echo "Worker1 ansible_host=$WORKER1_PUBIP" >> ./AnsibleInventory
echo "Worker2 ansible_host=$WORKER2_PUBIP" >> ./AnsibleInventory
echo "[all:vars]" >> ./AnsibleInventory
echo "jenkins_private_ip=$JENKINS_PRIVIP" >> ./AnsibleInventory
echo "worker1_private_ip=$WORKER1_PRIVIP" >> ./AnsibleInventory
echo "worker2_private_ip=$WORKER2_PRIVIP" >> ./AnsibleInventory

echo ">Installing Ansible ..."
sh ./ansible_install.sh

ansible-playbook -i ./AnsibleInventory --private-key ./awskey  playbook.yml


