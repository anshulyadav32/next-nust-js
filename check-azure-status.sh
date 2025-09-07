#!/bin/bash

# Azure Deployment Status Checker
# This script checks the status of deployments in the specified resource group

# Configuration
RESOURCE_GROUP="rg-fullstackauth-west"  # Updated for new region
SUBSCRIPTION_ID="d0ae77fd-6582-4109-870a-949613871b52"

echo "🔍 Checking Azure Deployment Status"
echo "Resource Group: $RESOURCE_GROUP"
echo "Subscription ID: $SUBSCRIPTION_ID"
echo ""

# Check if Azure CLI is logged in
echo "🔑 Checking Azure CLI login status..."
az account show &>/dev/null
if [ $? -ne 0 ]; then
    echo "⚠️ Not logged into Azure CLI. Please login first with 'az login'"
    exit 1
fi

# Set subscription
echo "📌 Setting subscription..."
az account set --subscription "$SUBSCRIPTION_ID" &>/dev/null

# Check if resource group exists
echo "🔍 Checking if resource group exists..."
az group show -n "$RESOURCE_GROUP" &>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Resource group '$RESOURCE_GROUP' does not exist."
    echo "Would you like to create it? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "📝 Creating resource group '$RESOURCE_GROUP'..."
        az group create --name "$RESOURCE_GROUP" --location "eastus" &>/dev/null
        if [ $? -ne 0 ]; then
            echo "❌ Failed to create resource group."
            exit 1
        fi
        echo "✅ Resource group created."
    else
        echo "❌ Exiting without creating resource group."
        exit 1
    fi
else
    echo "✅ Resource group exists."
fi

# List deployments
echo ""
echo "📊 Recent Deployments:"
az deployment group list -g "$RESOURCE_GROUP" --query "[].{Name:name, Timestamp:properties.timestamp, ProvisioningState:properties.provisioningState}" -o table

# List resources
echo ""
echo "📊 Resources in Group:"
az resource list -g "$RESOURCE_GROUP" --query "[].{Name:name, Type:type, Location:location, ProvisioningState:provisioningState}" -o table

# List Container Apps if they exist
echo ""
echo "📦 Container Apps:"
CONTAINER_APPS=$(az containerapp list -g "$RESOURCE_GROUP" --query "[].{Name:name, FQDN:properties.configuration.ingress.fqdn, Status:properties.provisioningState}" -o table 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "$CONTAINER_APPS"
else
    echo "No container apps found."
fi

# List Container Registry if they exist
echo ""
echo "🏢 Container Registry:"
CONTAINER_REGISTRY=$(az acr list -g "$RESOURCE_GROUP" --query "[].{Name:name, LoginServer:loginServer, Status:provisioningState}" -o table 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "$CONTAINER_REGISTRY"
else
    echo "No container registry found."
fi

echo ""
echo "✅ Deployment status check completed."
