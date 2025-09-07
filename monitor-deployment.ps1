# Deployment Status Monitor for Azure Container Apps
# This script continuously monitors the status of the Container Apps deployment

# Configuration
$RESOURCE_GROUP="rg-fullstackauth-west"  # Updated for new region
$FRONTEND_APP_NAME="frontend-auth"
$BACKEND_APP_NAME="backend-auth"
$CONTAINER_APP_ENV="frontend-auth-env"
$REFRESH_INTERVAL=30  # seconds

function Show-Banner {
    Write-Host "=================================================="
    Write-Host "  Azure Container Apps Deployment Monitor" -ForegroundColor Cyan
    Write-Host "=================================================="
    Write-Host ""
}

function Check-Deployment-Status {
    # Get resource group status
    $rgExists = $false
    try {
        $rg = az group show --name $RESOURCE_GROUP --query "properties.provisioningState" -o tsv 2>$null
        if ($LASTEXITCODE -eq 0) {
            $rgExists = $true
            Write-Host "Resource Group: $RESOURCE_GROUP - Status: " -NoNewline
            Write-Host "$rg" -ForegroundColor Green
        }
    } catch {
        Write-Host "Resource Group: $RESOURCE_GROUP - " -NoNewline
        Write-Host "Not Found" -ForegroundColor Red
    }

    if (-not $rgExists) {
        return
    }

    # Container App Environment
    try {
        $envStatus = az containerapp env show --name $CONTAINER_APP_ENV --resource-group $RESOURCE_GROUP --query "properties.provisioningState" -o tsv 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Container App Environment: $CONTAINER_APP_ENV - Status: " -NoNewline
            if ($envStatus -eq "Succeeded") {
                Write-Host "$envStatus" -ForegroundColor Green
            } else {
                Write-Host "$envStatus" -ForegroundColor Yellow
            }
        } else {
            Write-Host "Container App Environment: $CONTAINER_APP_ENV - " -NoNewline
            Write-Host "Not Found" -ForegroundColor Red
        }
    } catch {
        Write-Host "Container App Environment: $CONTAINER_APP_ENV - " -NoNewline
        Write-Host "Error" -ForegroundColor Red
    }

    # Backend Container App
    try {
        $backendStatus = az containerapp show --name $BACKEND_APP_NAME --resource-group $RESOURCE_GROUP --query "properties.provisioningState" -o tsv 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Backend Container App: $BACKEND_APP_NAME - Status: " -NoNewline
            if ($backendStatus -eq "Succeeded") {
                $backendFqdn = az containerapp show --name $BACKEND_APP_NAME --resource-group $RESOURCE_GROUP --query "properties.configuration.ingress.fqdn" -o tsv
                Write-Host "$backendStatus" -ForegroundColor Green
                Write-Host "  URL: https://$backendFqdn" -ForegroundColor Cyan
            } else {
                Write-Host "$backendStatus" -ForegroundColor Yellow
            }
        } else {
            Write-Host "Backend Container App: $BACKEND_APP_NAME - " -NoNewline
            Write-Host "Not Found" -ForegroundColor Red
        }
    } catch {
        Write-Host "Backend Container App: $BACKEND_APP_NAME - " -NoNewline
        Write-Host "Error" -ForegroundColor Red
    }

    # Frontend Container App
    try {
        $frontendStatus = az containerapp show --name $FRONTEND_APP_NAME --resource-group $RESOURCE_GROUP --query "properties.provisioningState" -o tsv 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Frontend Container App: $FRONTEND_APP_NAME - Status: " -NoNewline
            if ($frontendStatus -eq "Succeeded") {
                $frontendFqdn = az containerapp show --name $FRONTEND_APP_NAME --resource-group $RESOURCE_GROUP --query "properties.configuration.ingress.fqdn" -o tsv
                Write-Host "$frontendStatus" -ForegroundColor Green
                Write-Host "  URL: https://$frontendFqdn" -ForegroundColor Cyan
            } else {
                Write-Host "$frontendStatus" -ForegroundColor Yellow
            }
        } else {
            Write-Host "Frontend Container App: $FRONTEND_APP_NAME - " -NoNewline
            Write-Host "Not Found" -ForegroundColor Red
        }
    } catch {
        Write-Host "Frontend Container App: $FRONTEND_APP_NAME - " -NoNewline
        Write-Host "Error" -ForegroundColor Red
    }

    # Recent Deployment Operations
    Write-Host ""
    Write-Host "Recent Deployment Operations:"
    az deployment group list -g $RESOURCE_GROUP --query "reverse(sort_by([?properties.provisioningState != null].{Name:name, State:properties.provisioningState, Timestamp:properties.timestamp}, &Timestamp))[:5]" -o table

    # Get detailed status for in-progress deployments
    $inProgressDeployments = az deployment group list -g $RESOURCE_GROUP --query "[?properties.provisioningState=='Running'].name" -o tsv
    if ($inProgressDeployments) {
        foreach ($deployment in $inProgressDeployments.Split("`n")) {
            if ($deployment) {
                Write-Host ""
                Write-Host "In-progress Deployment: $deployment" -ForegroundColor Yellow
                az deployment group show -g $RESOURCE_GROUP -n $deployment --query "properties.error"
            }
        }
    }
}

Show-Banner

# Main monitoring loop
try {
    while ($true) {
        $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Host "Checking deployment status at $now..." -ForegroundColor Yellow
        Write-Host ""
        
        Check-Deployment-Status
        
        Write-Host ""
        Write-Host "Next update in $REFRESH_INTERVAL seconds... (Press Ctrl+C to exit)" -ForegroundColor DarkGray
        Start-Sleep -Seconds $REFRESH_INTERVAL
        Clear-Host
        Show-Banner
    }
} finally {
    Write-Host ""
    Write-Host "Monitoring stopped." -ForegroundColor Yellow
}
