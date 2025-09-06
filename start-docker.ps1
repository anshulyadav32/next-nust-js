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
Write-Host "📊 To view logs: docker-compose -f docker-compose.dev.yml logs -f" -ForegroundColor Gray
Write-Host "🛑 To stop: docker-compose -f docker-compose.dev.yml down" -ForegroundColor Gray
