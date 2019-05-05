#!/bin/bash

rg=$1
MyVmss=$2
webapp=$3

az group create -n $rg -l southcentralus

az vmss create -n $MyVmss -g $rg --instance-count 3 --image UbuntuLTS --custom-data './cloud_config.txt' --public-ip-per-vm 