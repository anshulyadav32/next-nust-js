# Docker Logs Viewer Helper Script

function Show-Help {
    Write-Host "📊 Docker Logs Viewer"
    Write-Host ""
    Write-Host "Usage: .\view-logs.ps1 [service]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  frontend    View frontend container logs"
    Write-Host "  backend     View backend container logs"
    Write-Host "  all         View all container logs (default)"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\view-logs.ps1 frontend"
    Write-Host "  .\view-logs.ps1 backend"
    Write-Host "  .\view-logs.ps1"
    Write-Host ""
}

if ($args[0] -eq "--help" -or $args[0] -eq "-h") {
    Show-Help
    exit 0
}

$SERVICE = if ($args.Count -gt 0) { $args[0] } else { "all" }

switch ($SERVICE) {
    "frontend" {
        Write-Host "📊 Viewing Frontend Logs (press Ctrl+C to exit)"
        docker-compose -f docker-compose.dev.yml logs -f frontend
    }
    "backend" {
        Write-Host "📊 Viewing Backend Logs (press Ctrl+C to exit)"
        docker-compose -f docker-compose.dev.yml logs -f backend
    }
    "all" {
        Write-Host "📊 Viewing All Logs (press Ctrl+C to exit)"
        docker-compose -f docker-compose.dev.yml logs -f
    }
    default {
        Write-Host "❌ Unknown service: $SERVICE" -ForegroundColor Red
        Show-Help
        exit 1
    }
}
