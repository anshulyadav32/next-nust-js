# Fresh Azure Container Apps Deployment Script
# This script creates all necessary resources and deploys the fullstack auth app

# Configuration
$RESOURCE_GROUP="rg-fullstack-auth-fresh"
$LOCATION="eastus"
$CONTAINER_APP_ENV="cae-fullstack-auth"
$LOG_ANALYTICS_WORKSPACE="log-fullstack-auth"
$REGISTRY_NAME="acrfullstackfresh$(Get-Random -Minimum 1000 -Maximum 9999)"
$FRONTEND_APP_NAME="frontend-auth"
$BACKEND_APP_NAME="backend-auth"
$SUBSCRIPTION_ID="d0ae77fd-6582-4109-870a-949613871b52"
$FRONTEND_IMAGE="fullstack-auth-frontend:latest"
$BACKEND_IMAGE="fullstack-auth-backend:latest"

Write-Host "=================================================="
Write-Host "  Fresh Azure Container Apps Deployment" -ForegroundColor Cyan
Write-Host "=================================================="
Write-Host ""
Write-Host "🎯 Deployment Configuration:" -ForegroundColor Yellow
Write-Host "   Resource Group: $RESOURCE_GROUP" -ForegroundColor Cyan
Write-Host "   Location: $LOCATION" -ForegroundColor Cyan
Write-Host "   Container Registry: $REGISTRY_NAME" -ForegroundColor Cyan
Write-Host ""

# Check if Docker images exist
Write-Host "🔍 Checking Docker images..." -ForegroundColor Yellow
$frontendImageExists = docker image inspect $FRONTEND_IMAGE 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend image not found. Building images first..." -ForegroundColor Red
    .\build-docker-images.ps1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to build Docker images." -ForegroundColor Red
        exit 1
    }
}

$backendImageExists = docker image inspect $BACKEND_IMAGE 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend image not found. Building images first..." -ForegroundColor Red
    .\build-docker-images.ps1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to build Docker images." -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ Docker images are ready." -ForegroundColor Green

# Set subscription
Write-Host "📌 Setting subscription..." -ForegroundColor Yellow
az account set --subscription $SUBSCRIPTION_ID

# Create resource group
Write-Host "📁 Creating resource group..." -ForegroundColor Yellow
az group create --name $RESOURCE_GROUP --location $LOCATION
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create resource group." -ForegroundColor Red
    exit 1
}

# Create Log Analytics workspace
Write-Host "📊 Creating Log Analytics workspace..." -ForegroundColor Yellow
az monitor log-analytics workspace create `
    --resource-group $RESOURCE_GROUP `
    --workspace-name $LOG_ANALYTICS_WORKSPACE `
    --location $LOCATION

$LOG_ANALYTICS_CLIENT_ID = az monitor log-analytics workspace show `
    --resource-group $RESOURCE_GROUP `
    --workspace-name $LOG_ANALYTICS_WORKSPACE `
    --query customerId -o tsv

$LOG_ANALYTICS_CLIENT_SECRET = az monitor log-analytics workspace get-shared-keys `
    --resource-group $RESOURCE_GROUP `
    --workspace-name $LOG_ANALYTICS_WORKSPACE `
    --query primarySharedKey -o tsv

# Create Container Registry
Write-Host "🏭 Creating Container Registry..." -ForegroundColor Yellow
az acr create `
    --resource-group $RESOURCE_GROUP `
    --name $REGISTRY_NAME `
    --sku Basic `
    --admin-enabled true `
    --location $LOCATION

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create Container Registry." -ForegroundColor Red
    exit 1
}

# Get ACR credentials
$ACR_USERNAME = az acr credential show --name $REGISTRY_NAME --query username -o tsv
$ACR_PASSWORD = az acr credential show --name $REGISTRY_NAME --query "passwords[0].value" -o tsv
$ACR_LOGIN_SERVER = az acr show --name $REGISTRY_NAME --query loginServer -o tsv

# Login to ACR
Write-Host "🔑 Logging into Container Registry..." -ForegroundColor Yellow
az acr login --name $REGISTRY_NAME

# Tag and push images
Write-Host "📦 Tagging and pushing images..." -ForegroundColor Yellow
$FRONTEND_ACR_IMAGE = "$ACR_LOGIN_SERVER/fullstack-auth-frontend:latest"
$BACKEND_ACR_IMAGE = "$ACR_LOGIN_SERVER/fullstack-auth-backend:latest"

docker tag $FRONTEND_IMAGE $FRONTEND_ACR_IMAGE
docker push $FRONTEND_ACR_IMAGE

docker tag $BACKEND_IMAGE $BACKEND_ACR_IMAGE
docker push $BACKEND_ACR_IMAGE

# Create Container App Environment
Write-Host "🌍 Creating Container App Environment..." -ForegroundColor Yellow
az containerapp env create `
    --name $CONTAINER_APP_ENV `
    --resource-group $RESOURCE_GROUP `
    --location $LOCATION `
    --logs-workspace-id $LOG_ANALYTICS_CLIENT_ID `
    --logs-workspace-key $LOG_ANALYTICS_CLIENT_SECRET

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create Container App Environment." -ForegroundColor Red
    exit 1
}

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
    --cpu 0.5 `
    --memory 1.0Gi `
    --env-vars "NODE_ENV=production" "PORT=3001" "NEXTAUTH_SECRET=production_secret_change_me"

# Get backend URL
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
    --target-port 3002 `
    --ingress external `
    --cpu 0.5 `
    --memory 1.0Gi `
    --env-vars "NODE_ENV=production" "PORT=3002" "BACKEND_URL=https://$BACKEND_URL"

# Get frontend URL
$FRONTEND_URL = az containerapp show `
    --name $FRONTEND_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --query properties.configuration.ingress.fqdn -o tsv

# Display results
Write-Host ""
Write-Host "🎉 Deployment completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📱 Application URLs:" -ForegroundColor Cyan
Write-Host "   Frontend: https://$FRONTEND_URL" -ForegroundColor Green
Write-Host "   Backend:  https://$BACKEND_URL" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Resource Information:" -ForegroundColor Cyan
Write-Host "   Resource Group: $RESOURCE_GROUP" -ForegroundColor DarkGray
Write-Host "   Container Registry: $REGISTRY_NAME" -ForegroundColor DarkGray
Write-Host "   Location: $LOCATION" -ForegroundColor DarkGray
Write-Host ""
Write-Host "🔍 Monitor your deployment:" -ForegroundColor Yellow
Write-Host "   az containerapp logs show --name $FRONTEND_APP_NAME --resource-group $RESOURCE_GROUP --follow" -ForegroundColor DarkGray
Write-Host "   az containerapp logs show --name $BACKEND_APP_NAME --resource-group $RESOURCE_GROUP --follow" -ForegroundColor DarkGray
