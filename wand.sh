#!/bin/bash

#HOMEDIR=$(echo $HOME)

# echo Please enter AWS Access Key ID:
# read ACCESSKEYID
read -s -p "Please enter AWS Access Key ID: " ACCESSKEYID

# echo Please enter AWS Secret Access Key:
# read SECRETACCESSKEY
echo "\n"
read -s -p "Please enter AWS Secret Access Key: " SECRETACCESSKEY

aws configure set aws_access_key_id $ACCESSKEYID
aws configure set aws_secret_access_key $SECRETACCESSKEY

cd ./Terraform/
rm -f terraform.tfstate
export TF_VAR_alb-source-ip=$(curl icanhazip.com)"/32"
terraform apply -auto-approve
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --vault-password-file ../ansible/vault-pass.txt -i ../ansible/hosts.cfg ../ansible/playbook.yml


