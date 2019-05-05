#!/bin/bash

groupName=$1
location=southcentralus
servicePlanName=$2
appName=$3
gitrepo=https://github.com/dernestnelson/test
token=5cb9f16a1a731dcd756e393efb15a7686999f255

# Create a resource group.
az group create --location $location --name $groupName

# Create an App Service plan in `FREE` tier.
az appservice plan create --name $servicePlanName --resource-group $groupName --sku B1 --location $location --is-linux

# Create a web app.
az webapp create --resource-group $groupName --plan $servicePlanName --name $appName -r "node|10.14"

# Configure continuous deployment from GitHub. 
# --git-token parameter is required only once per Azure account (Azure remembers token).
az webapp deployment source config --name $appName --resource-group $groupName \
--repo-url $gitrepo --branch master --git-token $token

# add instances 
az appservice plan update -g $groupName -n $servicePlanName --number-of-workers 3