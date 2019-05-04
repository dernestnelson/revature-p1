#!/bin/bash

rg=$1

gitrepo='https://github.com/dernestnelson/revature-p1'
token='511ce07c327ecf9fd1798b28f805e8c6a9af588b'
webappname=davidrulz9g
plan=fuckmatt

# Create a resource group.
az group create --location southcentralus --name $rg

# Create an App Service plan in `FREE` tier.
az appservice plan create --name $plan --resource-group $rg --sku B1 --number-of-workers 3 -l southcentralus

# Create a web app.
az webapp create --name $webappname --resource-group $rg --plan $plan


#az webapp config appsettings set --resource-group $rg --name $webappname --settings WEBSITE_NODE_DEFAULT_VERSION=10.14.1
# Configure continuous deployment from GitHub.
# --git-token parameter is required only once per Azure account (Azure remembers token).
az webapp deployment source config --name $webappname --resource-group $rg \
--repo-url $gitrepo --branch master 


# Copy the result of the following command into a browser to see the web app.
echo http://$webappname.azurewebsites.net