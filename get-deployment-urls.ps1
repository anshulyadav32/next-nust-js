# Deployment Final URL Checker
# This script will check for the final deployment URLs and display them when ready

# Configuration
$RESOURCE_GROUP="rg-fullstackauth-west"  # Updated for new region
$FRONTEND_APP_NAME="frontend-auth"
$BACKEND_APP_NAME="backend-auth"
$CHECK_INTERVAL=60  # seconds
$MAX_CHECKS=30      # Maximum number of checks (30 minutes)

function Show-Banner {
    Write-Host "=================================================="
    Write-Host "  Deployment Final URL Checker" -ForegroundColor Cyan
    Write-Host "=================================================="
    Write-Host ""
}

function Check-URLs {
    $frontendFound = $false
    $backendFound = $false
    $frontendURL = ""
    $backendURL = ""
    
    # Check Frontend URL
    try {
        $frontendFqdn = az containerapp show --name $FRONTEND_APP_NAME --resource-group $RESOURCE_GROUP --query "properties.configuration.ingress.fqdn" -o tsv 2>$null
        if ($LASTEXITCODE -eq 0 -and $frontendFqdn) {
            $frontendFound = $true
            $frontendURL = "https://$frontendFqdn"
        }
    }
    catch {
        # Frontend not ready yet
    }
    
    # Check Backend URL
    try {
        $backendFqdn = az containerapp show --name $BACKEND_APP_NAME --resource-group $RESOURCE_GROUP --query "properties.configuration.ingress.fqdn" -o tsv 2>$null
        if ($LASTEXITCODE -eq 0 -and $backendFqdn) {
            $backendFound = $true
            $backendURL = "https://$backendFqdn"
        }
    }
    catch {
        # Backend not ready yet
    }
    
    return @{
        FrontendFound = $frontendFound
        BackendFound = $backendFound
        FrontendURL = $frontendURL
        BackendURL = $backendURL
    }
}

Show-Banner

# Main loop
$checkCount = 0
$foundURLs = $false

while (-not $foundURLs -and $checkCount -lt $MAX_CHECKS) {
    $checkCount++
    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "Check $checkCount of $MAX_CHECKS at $now..." -ForegroundColor Yellow
    
    $result = Check-URLs
    
    if ($result.FrontendFound -and $result.BackendFound) {
        Write-Host ""
        Write-Host "🎉 Deployment Complete! Application URLs:" -ForegroundColor Green
        Write-Host "📱 Frontend URL: $($result.FrontendURL)" -ForegroundColor Cyan
        Write-Host "🔌 Backend URL: $($result.BackendURL)" -ForegroundColor Cyan
        
        # Save URLs to a file for easy reference
        @"
# Fullstack Auth Application URLs

## Frontend
$($result.FrontendURL)

## Backend
$($result.BackendURL)

## Documentation
See ACCESSING-DEPLOYED-APP.md for details on how to use these endpoints.
"@ | Out-File -FilePath "DEPLOYMENT-URLS.md" -Encoding utf8
        
        Write-Host ""
        Write-Host "URLs have been saved to DEPLOYMENT-URLS.md for future reference." -ForegroundColor Green
        $foundURLs = $true
    }
    else {
        Write-Host "Frontend URL: " -NoNewline
        if ($result.FrontendFound) {
            Write-Host "✅ Ready - $($result.FrontendURL)" -ForegroundColor Green
        } else {
            Write-Host "❌ Not Ready" -ForegroundColor Red
        }
        
        Write-Host "Backend URL: " -NoNewline
        if ($result.BackendFound) {
            Write-Host "✅ Ready - $($result.BackendURL)" -ForegroundColor Green
        } else {
            Write-Host "❌ Not Ready" -ForegroundColor Red
        }
        
        if (-not $foundURLs -and $checkCount -lt $MAX_CHECKS) {
            Write-Host ""
            Write-Host "Will check again in $CHECK_INTERVAL seconds... (Press Ctrl+C to exit)" -ForegroundColor DarkGray
            Start-Sleep -Seconds $CHECK_INTERVAL
        }
    }
}

if (-not $foundURLs) {
    Write-Host ""
    Write-Host "❌ Timeout reached. URLs not available after $MAX_CHECKS checks." -ForegroundColor Red
    Write-Host "Please run 'az containerapp list -g $RESOURCE_GROUP -o table' manually to check status." -ForegroundColor Yellow
}

Write-Host ""
