# Cleanup Extra Files Script
# This script removes redundant and unnecessary files

Write-Host "=================================================="
Write-Host "  Cleaning Up Extra Files" -ForegroundColor Cyan
Write-Host "=================================================="
Write-Host ""

# Files to remove (redundant documentation and scripts)
$filesToRemove = @(
    # Redundant documentation files
    "ACCESSING-DEPLOYED-APP.md",
    "AZURE-TROUBLESHOOTING.md", 
    "DEPLOYMENT-FIX.md",
    "DEPLOYMENT-SUMMARY.md",
    "LINKS.md",
    "PROJECT-SUMMARY.md",
    "REGION-CHANGE-NOTE.md",
    "TOOLS.md",
    
    # Redundant or old deployment scripts
    "deploy-to-azure.sh",        # We have PowerShell version
    "check-azure-status.sh",     # We have PowerShell version  
    "start-docker.sh",           # We have PowerShell version
    "view-logs.sh",              # We have PowerShell version
    
    # Old/redundant PowerShell scripts
    "check-azure-status.ps1",    # Functionality covered by other scripts
    "get-deployment-urls.ps1",   # Simple functionality, not needed
    "monitor-deployment.ps1",    # Overly complex for basic monitoring
    "view-logs.ps1"              # Simple az command, not needed as script
    
    # Keep only essential scripts:
    # - build-docker-images.ps1 (essential for building)
    # - deploy-fresh.ps1 (main deployment script)
    # - fix-deployment.ps1 (for fixing issues)  
    # - verify-azure-resources.ps1 (for verification)
    # - start-docker.ps1 (for local development)
)

Write-Host "🗑️ Files to be removed:" -ForegroundColor Yellow
foreach ($file in $filesToRemove) {
    if (Test-Path $file) {
        Write-Host "   - $file" -ForegroundColor Red
    } else {
        Write-Host "   - $file (not found)" -ForegroundColor DarkGray
    }
}

Write-Host ""
$confirm = Read-Host "Do you want to proceed with removing these files? (y/N)"

if ($confirm -eq "y" -or $confirm -eq "Y") {
    Write-Host ""
    Write-Host "🗑️ Removing files..." -ForegroundColor Yellow
    
    foreach ($file in $filesToRemove) {
        if (Test-Path $file) {
            Remove-Item $file -Force
            Write-Host "   ✅ Removed: $file" -ForegroundColor Green
        }
    }
    
    Write-Host ""
    Write-Host "✅ Cleanup completed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📁 Remaining essential files:" -ForegroundColor Cyan
    Write-Host "   - README.md (main documentation)" -ForegroundColor Green
    Write-Host "   - DEPLOYMENT-FIX-SUMMARY.md (deployment guide)" -ForegroundColor Green  
    Write-Host "   - build-docker-images.ps1 (build automation)" -ForegroundColor Green
    Write-Host "   - deploy-fresh.ps1 (main deployment)" -ForegroundColor Green
    Write-Host "   - fix-deployment.ps1 (deployment fixes)" -ForegroundColor Green
    Write-Host "   - verify-azure-resources.ps1 (resource verification)" -ForegroundColor Green
    Write-Host "   - start-docker.ps1 (local development)" -ForegroundColor Green
    
} else {
    Write-Host ""
    Write-Host "❌ Cleanup cancelled." -ForegroundColor Yellow
}
