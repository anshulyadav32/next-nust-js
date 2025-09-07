# Azure Container Apps Deployment Script for Fullstack Auth App
# This script deploys the frontend and backend container apps to Azure

# Configuration - Update these values as needed
$RESOURCE_GROUP="rg-dev"  # Using existing resource group with Container App Environment
$LOCATION="eastus"  # Using existing location
$CONTAINER_APP_ENV="az-cae-onox3m7mozzm2"  # Using existing Container App Environment
$LOG_ANALYTICS_WORKSPACE="log-fullstackauth-east"  # Log Analytics in East region
$REGISTRY_NAME="acronox3m7mozzm2"  # Using existing Container Registry in rg-dev
$FRONTEND_APP_NAME="frontend-auth"
$BACKEND_APP_NAME="backend-auth"
$SUBSCRIPTION_ID="d0ae77fd-6582-4109-870a-949613871b52"
$FRONTEND_IMAGE="fullstack-auth-frontend:latest"
$BACKEND_IMAGE="fullstack-auth-backend:latest"

# Display banner
Write-Host "=================================================="
Write-Host "  Azure Container Apps Deployment for Fullstack Auth" -ForegroundColor Cyan
Write-Host "=================================================="
Write-Host ""

# Login check
Write-Host "🔑 Checking Azure CLI login status..." -ForegroundColor Yellow
$loginStatus = az account show 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️ Not logged into Azure CLI. Please login first." -ForegroundColor Red
    az login
}

# Set subscription
Write-Host "📌 Setting subscription..." -ForegroundColor Yellow
az account set --subscription $SUBSCRIPTION_ID

# Using existing resource group
Write-Host "🔍 Checking if resource group exists..." -ForegroundColor Yellow
$rgExists = az group show -n $RESOURCE_GROUP 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Resource group '$RESOURCE_GROUP' not found." -ForegroundColor Red
    Write-Host "Available resource groups:" -ForegroundColor Yellow
    az group list --query "[].{name:name, location:location}" --output table
    exit 1
}
Write-Host "✅ Using existing resource group: $RESOURCE_GROUP" -ForegroundColor Green

# Create Log Analytics workspace if it doesn't exist
Write-Host "📊 Creating Log Analytics workspace..." -ForegroundColor Yellow
$logAnalyticsExists = az monitor log-analytics workspace show --resource-group $RESOURCE_GROUP --workspace-name $LOG_ANALYTICS_WORKSPACE 2>&1
if ($LASTEXITCODE -ne 0) {
    az monitor log-analytics workspace create `
        --resource-group $RESOURCE_GROUP `
        --workspace-name $LOG_ANALYTICS_WORKSPACE
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to create Log Analytics workspace." -ForegroundColor Red
        exit 1
    }
}

# Get Log Analytics Client ID and Client Secret
$LOG_ANALYTICS_CLIENT_ID = az monitor log-analytics workspace show `
    --resource-group $RESOURCE_GROUP `
    --workspace-name $LOG_ANALYTICS_WORKSPACE `
    --query customerId -o tsv

$LOG_ANALYTICS_CLIENT_SECRET = az monitor log-analytics workspace get-shared-keys `
    --resource-group $RESOURCE_GROUP `
    --workspace-name $LOG_ANALYTICS_WORKSPACE `
    --query primarySharedKey -o tsv

# Using existing Container Registry
Write-Host "🏭 Using existing Container Registry..." -ForegroundColor Yellow
$acrExists = az acr show --name $REGISTRY_NAME --resource-group $RESOURCE_GROUP 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Container Registry '$REGISTRY_NAME' not found in resource group '$RESOURCE_GROUP'." -ForegroundColor Red
    Write-Host "Available registries:" -ForegroundColor Yellow
    az acr list --query "[].{name:name, resourceGroup:resourceGroup, location:location}" --output table
    exit 1
}
Write-Host "✅ Using Container Registry: $REGISTRY_NAME" -ForegroundColor Green

# Get ACR credentials
$ACR_USERNAME = az acr credential show --name $REGISTRY_NAME --query username -o tsv
$ACR_PASSWORD = az acr credential show --name $REGISTRY_NAME --query "passwords[0].value" -o tsv
$ACR_LOGIN_SERVER = az acr show --name $REGISTRY_NAME --query loginServer -o tsv

# Tag and push images to ACR
Write-Host "📦 Tagging and pushing Docker images to ACR..." -ForegroundColor Yellow

# Check if local frontend image exists
$frontendImageExists = docker image inspect $FRONTEND_IMAGE 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Local frontend image not found. Make sure to build it first." -ForegroundColor Red
    exit 1
}

# Check if local backend image exists
$backendImageExists = docker image inspect $BACKEND_IMAGE 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Local backend image not found. Make sure to build it first." -ForegroundColor Red
    exit 1
}

# Tag and push frontend image
$FRONTEND_ACR_IMAGE = "$ACR_LOGIN_SERVER/fullstack-auth-frontend:latest"
docker tag $FRONTEND_IMAGE $FRONTEND_ACR_IMAGE
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to tag frontend image." -ForegroundColor Red
    exit 1
}

# Login to ACR
Write-Host "🔑 Logging into Container Registry..." -ForegroundColor Yellow
az acr login --name $REGISTRY_NAME
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to login to ACR." -ForegroundColor Red
    exit 1
}

# Push frontend image
Write-Host "⬆️ Pushing frontend image to ACR..." -ForegroundColor Yellow
docker push $FRONTEND_ACR_IMAGE
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to push frontend image to ACR." -ForegroundColor Red
    exit 1
}

# Tag and push backend image
$BACKEND_ACR_IMAGE = "$ACR_LOGIN_SERVER/fullstack-auth-backend:latest"
docker tag $BACKEND_IMAGE $BACKEND_ACR_IMAGE
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to tag backend image." -ForegroundColor Red
    exit 1
}

# Push backend image
Write-Host "⬆️ Pushing backend image to ACR..." -ForegroundColor Yellow
docker push $BACKEND_ACR_IMAGE
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to push backend image to ACR." -ForegroundColor Red
    exit 1
}

# Using existing Container App Environment
Write-Host "🌍 Using existing Container App Environment..." -ForegroundColor Yellow
$envExists = az containerapp env show --name $CONTAINER_APP_ENV --resource-group $RESOURCE_GROUP 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Existing Container App Environment not found." -ForegroundColor Red
    Write-Host "Please check your subscription for available environments:" -ForegroundColor Yellow
    Write-Host "az containerapp env list --output table" -ForegroundColor DarkGray
    exit 1
}
Write-Host "✅ Using Container App Environment: $CONTAINER_APP_ENV" -ForegroundColor Green

# Create Backend Container App
Write-Host "🔧 Creating Backend Container App..." -ForegroundColor Yellow
az containerapp create `
    --name $BACKEND_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --environment $CONTAINER_APP_ENV `
    --image $BACKEND_ACR_IMAGE `
    --registry-server $ACR_LOGIN_SERVER `
    --registry-username $ACR_USERNAME `
    --registry-password $ACR_PASSWORD `
    --target-port 3001 `
    --ingress external `
    --query properties.configuration.ingress.fqdn `
    --cpu 0.5 `
    --memory 1.0Gi

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create Backend Container App." -ForegroundColor Red
    exit 1
}

# Get backend URL for configuring frontend
$BACKEND_URL = az containerapp show `
    --name $BACKEND_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --query properties.configuration.ingress.fqdn -o tsv

# Create Frontend Container App
Write-Host "🖥️ Creating Frontend Container App..." -ForegroundColor Yellow
az containerapp create `
    --name $FRONTEND_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --environment $CONTAINER_APP_ENV `
    --image $FRONTEND_ACR_IMAGE `
    --registry-server $ACR_LOGIN_SERVER `
    --registry-username $ACR_USERNAME `
    --registry-password $ACR_PASSWORD `
    --target-port 3000 `
    --ingress external `
    --env-vars "BACKEND_URL=https://$BACKEND_URL" `
    --query properties.configuration.ingress.fqdn `
    --cpu 0.5 `
    --memory 1.0Gi

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create Frontend Container App." -ForegroundColor Red
    exit 1
}

# Get URLs for the deployed apps
$FRONTEND_URL = az containerapp show `
    --name $FRONTEND_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --query properties.configuration.ingress.fqdn -o tsv

# Display success message and URLs
Write-Host "🎉 Deployment completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📱 Frontend URL: https://$FRONTEND_URL" -ForegroundColor Cyan
Write-Host "🔌 Backend URL: https://$BACKEND_URL" -ForegroundColor Cyan
Write-Host ""
Write-Host "NOTE: It might take a few minutes for the services to be fully available."
