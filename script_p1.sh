#!/bin/bash

rg=$1
vm_name=$2
disk=$3

## creating disk and VM
diskCheck=$( az disk show -n $disk -g $rg --query name | sed 's/"//g' )
if [ -z $diskCheck ]; then
echo making disk
az disk create -g $rg --name $disk --os-type Linux --size 30
fi

vmCheck=$( az vm show -n $vm_name -g $rg --query name | sed 's/"//g' )
if [ -z $vmCheck ]; then
echo making VM
az vm create -g $rg -n $vm_name --custom-data './cloud_config.txt' --image UbuntuLTS --size Standard_B1s 
az vm disk attach -g $rg -n $disk --vm-name $vm_name
az vm open-port -g $rg -n $vm_name --port 8000
fi


snapshot(){
    snapshotname=$1
    newdisk=$2
    az vm disk detach -g $rg -n $disk --vm-name $vm_name
    az snapshot create -n $snapshotname -g $rg --source $disk 
    az disk create -g $rg -n $newdisk --source $snapshotname
}

image(){
    imagename=$1
    newVM=$2
    MyVmss=$3
    ##sudo waagent -deprovision+user
    
    az vm disk detach -g $rg -n $disk --vm-name $vm_name
    az vm stop -g $rg -n $vm_name 
    az vm deallocate -g $rg -n $vm_name 
    az vm generalize -g $rg -n $vm_name
    az image create -n $imagename --source $vm_name -g $rg
    az vmss create -n $MyVmss -g $rg --instance-count 3 --image $imagename
}

command=$4
if [ $command != 'snapshot' ] && [ $command != 'image' ]; then
    echo "not a command"
    exit 1
fi

$command $5 $6 $7

