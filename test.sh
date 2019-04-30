#!/bin/bash

rg=$1
vm_name=$2

IP=$(az vm show -g $rg -n $vm_name -d --query publicIps)
username=$(az vm show -g $rg -n $vm_name --query osProfile.adminUsername)

##signing in to VM
ssh $username@$IP 

sudo mkdir ~/hey