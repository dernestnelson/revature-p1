#!/bin/bash

rg=$1
MyVmss=$2
dns=$3
IPname=$4
lbname=$5
vnet=$6


az group create -n $rg -l southcentralus

######

az sql server create -l southcentralus -g $rg -n myserver -u sqladmin -p Password123

az sql db create -g $rg -s myserver -n mydb 

#####

blobStorageAccount=<blob_storage_account>

az storage account create --name $blobStorageAccount \
--location southcentralus --resource-group $rg \
--sku Standard_LRS --kind blobstorage --access-tier hot

blobStorageAccountKey=$(az storage account keys list -g myResourceGroup \
-n $blobStorageAccount --query [0].value --output tsv)

az storage container create -n images --account-name $blobStorageAccount \
--account-key $blobStorageAccountKey --public-access off

az storage container create -n thumbnails --account-name $blobStorageAccount \
--account-key $blobStorageAccountKey --public-access container

echo "Make a note of your Blob storage account key..."
echo $blobStorageAccountKey

#####

az network public-ip create -g $rg -n $IPname --dns-name $dns --allocation-method Static --sku Standard

az network lb create --name $lbname -g $rg --public-ip-address $IPname --sku Standard --public-ip-address-allocation Static --backend-pool-name myBackendPool --frontend-ip-name myFrontEndPool

az network lb probe create \
    --resource-group $rg \
    --lb-name $lbname \
    --name myHealthProbe \
    --protocol tcp \
    --port 80

az network lb rule create \
    --resource-group $rg \
    --lb-name $lbname \
    --name myHTTPRule \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name myFrontEndPool \
    --backend-pool-name myBackEndPool \
    --probe-name myHealthProbe


#az network lb address-pool create --lb-name $lbname -n MyaddressPool -g $rg

az network vnet create --name $vnet -g $rg --subnet-name MySubnet -l southcentralus

az network nsg create --name MyNSG -g $rg

#  az network lb inbound-nat-pool create -g $rg --lb-name $lbname \
#                        -n MyNatPool --protocol Tcp --frontend-port-range-start 80 --frontend-port-range-end 89 \
#                       --backend-port 8080 

az network nsg rule create --name NSGRule --nsg-name MyNSG --priority 200 -g $rg --protocol tcp --destination-port-ranges 80 --source-port-ranges '*' --source-address-prefixes '*' --destination-address-prefixes '*' --direction inbound --access allow 

for i in `seq 1 2`; do
  az network nic create \
    --resource-group $rg \
    --name myNic$i \
    --vnet-name $vnet \
    --subnet mySubnet \
    --network-security-group MyNSG \
    --lb-name $lbname \
    --lb-address-pools myBackEndPool
done

az vm availability-set create \
   --resource-group $rg \
   --name myAvailabilitySet

#az network lb inbound-nat-rule create --backend-port 8080 --frontend-port 80 --lb-name $lbname --protocol Tcp -n inboundnatrule -g $rg

#az network lb rule create --backend-port 8080 --frontend-port 80 --protocol Tcp --lb-name $lbname -n lbrule -g $rg --backend-pool-name MyaddressPool 

#az vmss create -n $MyVmss -g $rg --instance-count 3 --nsg MyNSG --vnet-name $vnet --subnet MySubnet --image UbuntuLTS --location southcentralus --load-balancer $lbname --custom-data './cloud_config.txt' --public-ip-address $IPname  

for i in `seq 1 2`; do
 az vm create \
   --resource-group $rg \
   --name myVM$i \
   --availability-set myAvailabilitySet \
   --nics myNic$i \
   --image UbuntuLTS \
   --custom-data './cloud_config.txt'
   done
