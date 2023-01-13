#!/bin/bash


MASTER=$(cat ./ansible/hosts.cfg | grep masternode | cut -d'=' -f2)

ssh ubuntu@$MASTER
