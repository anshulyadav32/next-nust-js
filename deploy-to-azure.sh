#!/bin/bash

# Azure Container Apps Deployment Script for Fullstack Auth App
# This script deploys the frontend and backend container apps to Azure

# Configuration - Update these values as needed
RESOURCE_GROUP="rg-fullstackauth-west"  # New resource group for West US region
LOCATION="westus"  # Changed from eastus to westus due to environment limits
CONTAINER_APP_ENV="frontend-auth-env"
LOG_ANALYTICS_WORKSPACE="log-fullstackauth-west"  # Updated for new region
REGISTRY_NAME="acrfullstackwest"  # Updated for new region
FRONTEND_APP_NAME="frontend-auth"
BACKEND_APP_NAME="backend-auth"
SUBSCRIPTION_ID="d0ae77fd-6582-4109-870a-949613871b52"
FRONTEND_IMAGE="fullstack-auth-frontend:latest"
BACKEND_IMAGE="fullstack-auth-backend:latest"

# Display banner
echo "=================================================="
echo "  Azure Container Apps Deployment for Fullstack Auth"
echo "=================================================="
echo ""

# Login check
echo "🔑 Checking Azure CLI login status..."
az account show &>/dev/null
if [ $? -ne 0 ]; then
    echo "⚠️ Not logged into Azure CLI. Please login first."
    az login
fi

# Set subscription
echo "📌 Setting subscription..."
az account set --subscription "$SUBSCRIPTION_ID"

# Create resource group if it doesn't exist
echo "🔍 Checking if resource group exists..."
az group show -n "$RESOURCE_GROUP" &>/dev/null
if [ $? -ne 0 ]; then
    echo "📝 Creating resource group '$RESOURCE_GROUP' in location '$LOCATION'..."
    az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create resource group."
        exit 1
    fi
    echo "✅ Resource group created."
else
    echo "✅ Resource group already exists."
fi

# Create Log Analytics workspace if it doesn't exist
echo "📊 Creating Log Analytics workspace..."
az monitor log-analytics workspace show --resource-group "$RESOURCE_GROUP" --workspace-name "$LOG_ANALYTICS_WORKSPACE" &>/dev/null
if [ $? -ne 0 ]; then
    az monitor log-analytics workspace create \
        --resource-group "$RESOURCE_GROUP" \
        --workspace-name "$LOG_ANALYTICS_WORKSPACE"
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create Log Analytics workspace."
        exit 1
    fi
fi

# Get Log Analytics Client ID and Client Secret
LOG_ANALYTICS_CLIENT_ID=$(az monitor log-analytics workspace show \
    --resource-group "$RESOURCE_GROUP" \
    --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
    --query customerId -o tsv)

LOG_ANALYTICS_CLIENT_SECRET=$(az monitor log-analytics workspace get-shared-keys \
    --resource-group "$RESOURCE_GROUP" \
    --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
    --query primarySharedKey -o tsv)

# Create Container Registry if it doesn't exist
echo "🏭 Creating Container Registry..."
az acr show --name "$REGISTRY_NAME" --resource-group "$RESOURCE_GROUP" &>/dev/null
if [ $? -ne 0 ]; then
    az acr create \
        --resource-group "$RESOURCE_GROUP" \
        --name "$REGISTRY_NAME" \
        --sku Basic \
        --admin-enabled true
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create Azure Container Registry."
        exit 1
    fi
fi

# Get ACR credentials
ACR_USERNAME=$(az acr credential show --name "$REGISTRY_NAME" --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name "$REGISTRY_NAME" --query "passwords[0].value" -o tsv)
ACR_LOGIN_SERVER=$(az acr show --name "$REGISTRY_NAME" --query loginServer -o tsv)

# Tag and push images to ACR
echo "📦 Tagging and pushing Docker images to ACR..."

# Check if local frontend image exists
docker image inspect "$FRONTEND_IMAGE" &>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Local frontend image not found. Make sure to build it first."
    exit 1
fi

# Check if local backend image exists
docker image inspect "$BACKEND_IMAGE" &>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ Local backend image not found. Make sure to build it first."
    exit 1
fi

# Tag and push frontend image
FRONTEND_ACR_IMAGE="$ACR_LOGIN_SERVER/fullstack-auth-frontend:latest"
docker tag "$FRONTEND_IMAGE" "$FRONTEND_ACR_IMAGE"
if [ $? -ne 0 ]; then
    echo "❌ Failed to tag frontend image."
    exit 1
fi

# Login to ACR
echo "🔑 Logging into Container Registry..."
az acr login --name "$REGISTRY_NAME"
if [ $? -ne 0 ]; then
    echo "❌ Failed to login to ACR."
    exit 1
fi

# Push frontend image
echo "⬆️ Pushing frontend image to ACR..."
docker push "$FRONTEND_ACR_IMAGE"
if [ $? -ne 0 ]; then
    echo "❌ Failed to push frontend image to ACR."
    exit 1
fi

# Tag and push backend image
BACKEND_ACR_IMAGE="$ACR_LOGIN_SERVER/fullstack-auth-backend:latest"
docker tag "$BACKEND_IMAGE" "$BACKEND_ACR_IMAGE"
if [ $? -ne 0 ]; then
    echo "❌ Failed to tag backend image."
    exit 1
fi

# Push backend image
echo "⬆️ Pushing backend image to ACR..."
docker push "$BACKEND_ACR_IMAGE"
if [ $? -ne 0 ]; then
    echo "❌ Failed to push backend image to ACR."
    exit 1
fi

# Create Container App Environment if it doesn't exist
echo "🌍 Creating Container App Environment..."
az containerapp env show --name "$CONTAINER_APP_ENV" --resource-group "$RESOURCE_GROUP" &>/dev/null
if [ $? -ne 0 ]; then
    az containerapp env create \
        --name "$CONTAINER_APP_ENV" \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --logs-workspace-id "$LOG_ANALYTICS_CLIENT_ID" \
        --logs-workspace-key "$LOG_ANALYTICS_CLIENT_SECRET"
    if [ $? -ne 0 ]; then
        echo "❌ Failed to create Container App Environment."
        exit 1
    fi
fi

# Create Backend Container App
echo "🔧 Creating Backend Container App..."
az containerapp create \
    --name "$BACKEND_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --environment "$CONTAINER_APP_ENV" \
    --image "$BACKEND_ACR_IMAGE" \
    --registry-server "$ACR_LOGIN_SERVER" \
    --registry-username "$ACR_USERNAME" \
    --registry-password "$ACR_PASSWORD" \
    --target-port 3001 \
    --ingress external \
    --query properties.configuration.ingress.fqdn \
    --cpu 0.5 \
    --memory 1.0Gi

if [ $? -ne 0 ]; then
    echo "❌ Failed to create Backend Container App."
    exit 1
fi

# Get backend URL for configuring frontend
BACKEND_URL=$(az containerapp show \
    --name "$BACKEND_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query properties.configuration.ingress.fqdn -o tsv)

# Create Frontend Container App
echo "🖥️ Creating Frontend Container App..."
az containerapp create \
    --name "$FRONTEND_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --environment "$CONTAINER_APP_ENV" \
    --image "$FRONTEND_ACR_IMAGE" \
    --registry-server "$ACR_LOGIN_SERVER" \
    --registry-username "$ACR_USERNAME" \
    --registry-password "$ACR_PASSWORD" \
    --target-port 3000 \
    --ingress external \
    --env-vars "BACKEND_URL=https://$BACKEND_URL" \
    --query properties.configuration.ingress.fqdn \
    --cpu 0.5 \
    --memory 1.0Gi

if [ $? -ne 0 ]; then
    echo "❌ Failed to create Frontend Container App."
    exit 1
fi

# Get URLs for the deployed apps
FRONTEND_URL=$(az containerapp show \
    --name "$FRONTEND_APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query properties.configuration.ingress.fqdn -o tsv)

# Display success message and URLs
echo "🎉 Deployment completed successfully!"
echo ""
echo "📱 Frontend URL: https://$FRONTEND_URL"
echo "🔌 Backend URL: https://$BACKEND_URL"
echo ""
echo "NOTE: It might take a few minutes for the services to be fully available."
