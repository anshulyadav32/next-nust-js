# PowerShell script for Windows
Write-Host "🐳 Starting Fullstack Auth App with Docker..." -ForegroundColor Cyan

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Build and start containers
Write-Host "🔨 Building Docker images..." -ForegroundColor Yellow
docker-compose -f docker-compose.dev.yml build

Write-Host "🚀 Starting containers..." -ForegroundColor Yellow
docker-compose -f docker-compose.dev.yml up -d

Write-Host "✅ Application started!" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Frontend: http://localhost:3002" -ForegroundColor Cyan
Write-Host "🔧 Backend API: http://localhost:3001" -ForegroundColor Cyan
Write-Host ""
Write-Host "📱 Mobile Access:" -ForegroundColor Magenta
$NetworkIP = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and ($_.PrefixOrigin -eq 'Dhcp' -or $_.PrefixOrigin -eq 'Manual') }).IPAddress | Select-Object -First 1
if ($NetworkIP) {
    $frontendUrl = "http://$NetworkIP:3002"
    $backendUrl = "http://$NetworkIP:3001"
    
    Write-Host "   - Frontend: $frontendUrl" -ForegroundColor Cyan
    Write-Host "   - Backend: $backendUrl" -ForegroundColor Cyan
    
    # Check container health
    try {
        $frontendHealth = Invoke-RestMethod -Uri "$frontendUrl/api/health" -Method Get -TimeoutSec 2 -ErrorAction SilentlyContinue
        if ($frontendHealth.status -eq "ok") {
            Write-Host "   ✅ Frontend Health: OK" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️ Frontend Status: ${$frontendHealth.status}" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "   ❌ Frontend Health Check Failed" -ForegroundColor Red
    }
    
    try {
        $backendHealth = Invoke-RestMethod -Uri "$backendUrl/api/health" -Method Get -TimeoutSec 2 -ErrorAction SilentlyContinue
        if ($backendHealth.status -eq "ok") {
            Write-Host "   ✅ Backend Health: OK" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️ Backend Status: ${$backendHealth.status}" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "   ❌ Backend Health Check Failed" -ForegroundColor Red
    }
}
Write-Host ""
Write-Host "📊 View logs:" -ForegroundColor Gray
Write-Host "   docker-compose -f docker-compose.dev.yml logs -f" -ForegroundColor Gray
Write-Host "   docker-compose -f docker-compose.dev.yml logs -f frontend" -ForegroundColor Gray
Write-Host "   docker-compose -f docker-compose.dev.yml logs -f backend" -ForegroundColor Gray
Write-Host ""
Write-Host "� Troubleshooting:" -ForegroundColor Yellow
Write-Host "   docker exec -it fullstack-auth_backend_1 sh  # Shell into backend container" -ForegroundColor Gray
Write-Host "   docker exec -it fullstack-auth_frontend_1 sh  # Shell into frontend container" -ForegroundColor Gray
Write-Host ""
Write-Host "🛑 Stop containers:" -ForegroundColor Red
Write-Host "   docker-compose -f docker-compose.dev.yml down" -ForegroundColor Gray
Write-Host "   docker-compose -f docker-compose.dev.yml down --volumes  # Remove volumes too" -ForegroundColor Gray
