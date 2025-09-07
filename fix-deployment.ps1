# Fix Current Deployment Script
# This script fixes the failed deployment by building and pushing images, then updating container apps

Write-Host "=================================================="
Write-Host "  Fixing Current Deployment" -ForegroundColor Cyan
Write-Host "=================================================="
Write-Host ""

# Configuration (from the current deployment)
$RESOURCE_GROUP="rg-fullstack-auth-fresh"
$CONTAINER_APP_ENV="cae-fullstack-auth"
$REGISTRY_NAME="acrfullstackfresh5919"
$FRONTEND_APP_NAME="frontend-auth"
$BACKEND_APP_NAME="backend-auth"
$FRONTEND_IMAGE="fullstack-auth-frontend:latest"
$BACKEND_IMAGE="fullstack-auth-backend:latest"

# Build Docker images if they don't exist
Write-Host "🏗️ Building Docker images..." -ForegroundColor Yellow

Write-Host "   Building frontend image..." -ForegroundColor Yellow
docker build -t $FRONTEND_IMAGE ./frontend
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to build frontend image." -ForegroundColor Red
    exit 1
}

Write-Host "   Building backend image..." -ForegroundColor Yellow
docker build -t $BACKEND_IMAGE ./backend
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to build backend image." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Docker images built successfully." -ForegroundColor Green

# Get ACR details
$ACR_LOGIN_SERVER = az acr show --name $REGISTRY_NAME --query loginServer -o tsv
$ACR_USERNAME = az acr credential show --name $REGISTRY_NAME --query username -o tsv
$ACR_PASSWORD = az acr credential show --name $REGISTRY_NAME --query "passwords[0].value" -o tsv

# Login to ACR
Write-Host "🔑 Logging into Container Registry..." -ForegroundColor Yellow
az acr login --name $REGISTRY_NAME
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to login to Container Registry." -ForegroundColor Red
    exit 1
}

# Tag and push images
Write-Host "📦 Tagging and pushing images to ACR..." -ForegroundColor Yellow

$FRONTEND_ACR_IMAGE = "$ACR_LOGIN_SERVER/fullstack-auth-frontend:latest"
$BACKEND_ACR_IMAGE = "$ACR_LOGIN_SERVER/fullstack-auth-backend:latest"

# Tag and push frontend
Write-Host "   Tagging frontend image..." -ForegroundColor Yellow
docker tag $FRONTEND_IMAGE $FRONTEND_ACR_IMAGE
Write-Host "   Pushing frontend image..." -ForegroundColor Yellow
docker push $FRONTEND_ACR_IMAGE
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to push frontend image." -ForegroundColor Red
    exit 1
}

# Tag and push backend
Write-Host "   Tagging backend image..." -ForegroundColor Yellow
docker tag $BACKEND_IMAGE $BACKEND_ACR_IMAGE
Write-Host "   Pushing backend image..." -ForegroundColor Yellow
docker push $BACKEND_ACR_IMAGE
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to push backend image." -ForegroundColor Red
    exit 1
}

Write-Host "✅ Images pushed successfully." -ForegroundColor Green

# Delete existing container apps if they exist (they might be in failed state)
Write-Host "🗑️ Cleaning up failed container apps..." -ForegroundColor Yellow
az containerapp delete --name $BACKEND_APP_NAME --resource-group $RESOURCE_GROUP --yes 2>$null
az containerapp delete --name $FRONTEND_APP_NAME --resource-group $RESOURCE_GROUP --yes 2>$null

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
    --env-vars "NODE_ENV=production" "PORT=3001" "NEXTAUTH_SECRET=production_secret_change_me" "NEXTAUTH_URL=https://placeholder-will-update"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create Backend Container App." -ForegroundColor Red
    exit 1
}

# Get backend URL
$BACKEND_URL = az containerapp show `
    --name $BACKEND_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --query properties.configuration.ingress.fqdn -o tsv

Write-Host "✅ Backend created: https://$BACKEND_URL" -ForegroundColor Green

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

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create Frontend Container App." -ForegroundColor Red
    exit 1
}

# Get frontend URL
$FRONTEND_URL = az containerapp show `
    --name $FRONTEND_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --query properties.configuration.ingress.fqdn -o tsv

# Update backend with correct NEXTAUTH_URL
Write-Host "🔄 Updating backend with correct NEXTAUTH_URL..." -ForegroundColor Yellow
az containerapp update `
    --name $BACKEND_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --set-env-vars "NEXTAUTH_URL=https://$BACKEND_URL"

# Display results
Write-Host ""
Write-Host "🎉 Deployment fixed and completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📱 Application URLs:" -ForegroundColor Cyan
Write-Host "   Frontend: https://$FRONTEND_URL" -ForegroundColor Green
Write-Host "   Backend:  https://$BACKEND_URL" -ForegroundColor Green
Write-Host ""
Write-Host "🔍 Test your deployment:" -ForegroundColor Yellow
Write-Host "   curl https://$BACKEND_URL/api/health" -ForegroundColor DarkGray
Write-Host "   curl https://$FRONTEND_URL/api/health" -ForegroundColor DarkGray
Write-Host ""
Write-Host "📊 Monitor logs:" -ForegroundColor Yellow
Write-Host "   az containerapp logs show --name $BACKEND_APP_NAME --resource-group $RESOURCE_GROUP --follow" -ForegroundColor DarkGray
Write-Host "   az containerapp logs show --name $FRONTEND_APP_NAME --resource-group $RESOURCE_GROUP --follow" -ForegroundColor DarkGray
