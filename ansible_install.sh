#!/bin/bash

sudo apt update && sudo apt install -y ansible
sudo touch /etc/ansible/hosts
sudo sed -i 's/^#host_key_checking.*/host_key_checking = False/g' /etc/ansible/ansible.cfg

echo "> Testing connection ..."
ansible all -m ping -i ./AnsibleInventory -u ubuntu --private-key ./awskey