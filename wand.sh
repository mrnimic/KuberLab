#!/bin/bash

#HOMEDIR=$(echo $HOME)

echo Please enter AWS Access Key ID:
read ACCESSKEYID
echo Please enter AWS Secret Access Key:
read SECRETACCESSKEY
aws configure set aws_access_key_id $ACCESSKEYID
aws configure set aws_secret_access_key $SECRETACCESSKEY

cd ./Terraform/
rm -f terraform.tfstate
terraform apply -auto-approve
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/hosts.cfg ../ansible/playbook.yml


