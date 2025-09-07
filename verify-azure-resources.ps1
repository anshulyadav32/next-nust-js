# Azure Resources Verification Script
# This script verifies that all required Azure resources exist before deployment

Write-Host "=================================================="
Write-Host "  Azure Resources Verification" -ForegroundColor Cyan
Write-Host "=================================================="
Write-Host ""

# Configuration
$RESOURCE_GROUP="rg-dev"
$CONTAINER_APP_ENV="az-cae-onox3m7mozzm2"
$REGISTRY_NAME="acronox3m7mozzm2"
$SUBSCRIPTION_ID="d0ae77fd-6582-4109-870a-949613871b52"

# Set subscription
Write-Host "📌 Setting subscription..." -ForegroundColor Yellow
az account set --subscription $SUBSCRIPTION_ID

# Check Resource Group
Write-Host "🔍 Checking Resource Group..." -ForegroundColor Yellow
$rgExists = az group show -n $RESOURCE_GROUP 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Resource Group '$RESOURCE_GROUP' exists" -ForegroundColor Green
} else {
    Write-Host "❌ Resource Group '$RESOURCE_GROUP' not found" -ForegroundColor Red
}

# Check Container App Environment
Write-Host "🌍 Checking Container App Environment..." -ForegroundColor Yellow
$envExists = az containerapp env show --name $CONTAINER_APP_ENV --resource-group $RESOURCE_GROUP 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Container App Environment '$CONTAINER_APP_ENV' exists" -ForegroundColor Green
} else {
    Write-Host "❌ Container App Environment '$CONTAINER_APP_ENV' not found" -ForegroundColor Red
}

# Check Container Registry
Write-Host "🏭 Checking Container Registry..." -ForegroundColor Yellow
$acrExists = az acr show --name $REGISTRY_NAME --resource-group $RESOURCE_GROUP 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Container Registry '$REGISTRY_NAME' exists" -ForegroundColor Green
    
    # Get ACR details
    $acrLoginServer = az acr show --name $REGISTRY_NAME --query loginServer -o tsv
    Write-Host "   Login Server: $acrLoginServer" -ForegroundColor Cyan
} else {
    Write-Host "❌ Container Registry '$REGISTRY_NAME' not found" -ForegroundColor Red
}

# Check existing Container Apps
Write-Host "📱 Checking existing Container Apps..." -ForegroundColor Yellow
$containerApps = az containerapp list --resource-group $RESOURCE_GROUP --query "[].{name:name, environment:managedEnvironmentId}" --output tsv
if ($containerApps) {
    Write-Host "   Existing Container Apps:" -ForegroundColor Cyan
    $containerApps | ForEach-Object {
        if ($_ -ne "") {
            Write-Host "   - $_" -ForegroundColor DarkGray
        }
    }
} else {
    Write-Host "   No existing Container Apps found" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎯 Summary:" -ForegroundColor Yellow
Write-Host "   Resource Group: rg-dev (East US)" -ForegroundColor Cyan
Write-Host "   Container App Environment: az-cae-onox3m7mozzm2" -ForegroundColor Cyan
Write-Host "   Container Registry: acronox3m7mozzm2" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Verification completed. If all resources show as existing, you can proceed with deployment." -ForegroundColor Green
