# Docker Build Script for Fullstack Auth App

Write-Host "=================================================="
Write-Host "  Docker Build for Fullstack Auth" -ForegroundColor Cyan
Write-Host "=================================================="
Write-Host ""

# Check Docker is running
Write-Host "🔍 Checking if Docker Desktop is running..." -ForegroundColor Yellow
try {
    $dockerInfo = docker info 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker is not running." -ForegroundColor Red
        Write-Host "Please start Docker Desktop manually before continuing." -ForegroundColor Yellow
        Write-Host "Once Docker Desktop is running, press any key to continue..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        
        # Check again
        $dockerInfo = docker info 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Docker is still not running. Please start Docker Desktop and try again." -ForegroundColor Red
            exit 1
        }
    }
    Write-Host "✅ Docker is running." -ForegroundColor Green
}
catch {
    Write-Host "❌ Error checking Docker status: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please ensure Docker Desktop is installed and running." -ForegroundColor Yellow
    exit 1
}

# Function to build a Docker image with progress and retry
function Build-DockerImage {
    param(
        [string]$imageName,
        [string]$context,
        [int]$maxRetries = 3
    )
    
    $attempt = 1
    $success = $false
    
    while (-not $success -and $attempt -le $maxRetries) {
        Write-Host "🏗️ Building $imageName image (Attempt $attempt of $maxRetries)..." -ForegroundColor Yellow
        
        docker build -t $imageName $context
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ $imageName image built successfully." -ForegroundColor Green
            $success = $true
        }
        else {
            if ($attempt -lt $maxRetries) {
                Write-Host "⚠️ Failed to build $imageName image. Retrying..." -ForegroundColor Yellow
                Start-Sleep -Seconds 3
            }
            else {
                Write-Host "❌ Failed to build $imageName image after $maxRetries attempts." -ForegroundColor Red
                return $false
            }
        }
        
        $attempt++
    }
    
    return $success
}

# Build frontend image
$frontendSuccess = Build-DockerImage -imageName "fullstack-auth-frontend:latest" -context "./frontend"
if (-not $frontendSuccess) {
    exit 1
}

# Build backend image
$backendSuccess = Build-DockerImage -imageName "fullstack-auth-backend:latest" -context "./backend"
if (-not $backendSuccess) {
    exit 1
}

Write-Host ""
Write-Host "🎉 Both Docker images have been built successfully!" -ForegroundColor Green
Write-Host "   - fullstack-auth-frontend:latest"
Write-Host "   - fullstack-auth-backend:latest"
Write-Host ""
Write-Host "To deploy to Azure, run: ./deploy-to-azure.ps1" -ForegroundColor Cyan
