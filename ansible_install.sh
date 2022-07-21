#!/bin/bash

sudo apt update && sudo apt install -y ansible
sudo touch /etc/ansible/hosts

echo "> Testing connection ..."
ansible all -m ping -i ./AnsibleInventory -u ubuntu --private-key ./awskey