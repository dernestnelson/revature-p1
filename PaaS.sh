#!/bin/bash

groupName=$1
servicePlanName=$2
appName=$3


# Create a resource group.
az group create --location southcentralus --name $groupName

# Create an App Service plan in `FREE` tier.
az appservice plan create --name $servicePlanName --resource-group $groupName --sku B1 --location southcentralus --is-linux  --number-of-workers 3

# Create a web app.
az webapp create --resource-group $groupName --plan $servicePlanName --name $appName -r "node|10.14"

# Configure continuous deployment from GitHub. 
# --git-token parameter is required only once per Azure account (Azure remembers token).
az webapp deployment source config --name $appName --resource-group $groupName \
--repo-url 'https://github.com/dernestnelson/revature-p1 ' --branch master 

