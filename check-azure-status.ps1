# Azure Deployment Status Checker
# This script checks the status of deployments in the specified resource group

# Configuration
$RESOURCE_GROUP = "rg-fullstackauth-west"  # Updated for new region
$SUBSCRIPTION_ID = "d0ae77fd-6582-4109-870a-949613871b52"

Write-Host "🔍 Checking Azure Deployment Status"
Write-Host "Resource Group: $RESOURCE_GROUP"
Write-Host "Subscription ID: $SUBSCRIPTION_ID"
Write-Host ""

# Check if Azure CLI is logged in
Write-Host "🔑 Checking Azure CLI login status..."
$loginStatus = az account show 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️ Not logged into Azure CLI. Please login first with 'az login'" -ForegroundColor Yellow
    exit 1
}

# Set subscription
Write-Host "📌 Setting subscription..."
az account set --subscription "$SUBSCRIPTION_ID" | Out-Null

# Check if resource group exists
Write-Host "🔍 Checking if resource group exists..."
$rgExists = az group show -n "$RESOURCE_GROUP" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Resource group '$RESOURCE_GROUP' does not exist." -ForegroundColor Red
    $response = Read-Host "Would you like to create it? (y/n)"
    if ($response -match "^[yY]") {
        Write-Host "📝 Creating resource group '$RESOURCE_GROUP'..." -ForegroundColor Yellow
        az group create --name "$RESOURCE_GROUP" --location "eastus" | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Failed to create resource group." -ForegroundColor Red
            exit 1
        }
        Write-Host "✅ Resource group created." -ForegroundColor Green
    }
    else {
        Write-Host "❌ Exiting without creating resource group." -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "✅ Resource group exists." -ForegroundColor Green
}

# List deployments
Write-Host ""
Write-Host "📊 Recent Deployments:" -ForegroundColor Cyan
az deployment group list -g "$RESOURCE_GROUP" --query "[].{Name:name, Timestamp:properties.timestamp, ProvisioningState:properties.provisioningState}" -o table

# List resources
Write-Host ""
Write-Host "📊 Resources in Group:" -ForegroundColor Cyan
az resource list -g "$RESOURCE_GROUP" --query "[].{Name:name, Type:type, Location:location, ProvisioningState:provisioningState}" -o table

# List Container Apps if they exist
Write-Host ""
Write-Host "📦 Container Apps:" -ForegroundColor Cyan
$containerAppsResult = az containerapp list -g "$RESOURCE_GROUP" --query "[].{Name:name, FQDN:properties.configuration.ingress.fqdn, Status:properties.provisioningState}" -o table 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host $containerAppsResult
}
else {
    Write-Host "No container apps found."
}

# List Container Registry if they exist
Write-Host ""
Write-Host "🏢 Container Registry:" -ForegroundColor Cyan
$containerRegistryResult = az acr list -g "$RESOURCE_GROUP" --query "[].{Name:name, LoginServer:loginServer, Status:provisioningState}" -o table 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host $containerRegistryResult
}
else {
    Write-Host "No container registry found."
}

Write-Host ""
Write-Host "✅ Deployment status check completed." -ForegroundColor Green
