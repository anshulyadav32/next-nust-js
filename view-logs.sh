#!/bin/bash

# Docker Logs Viewer Helper Script

show_help() {
    echo "📊 Docker Logs Viewer"
    echo ""
    echo "Usage: ./view-logs.sh [service]"
    echo ""
    echo "Options:"
    echo "  frontend    View frontend container logs"
    echo "  backend     View backend container logs"
    echo "  all         View all container logs (default)"
    echo ""
    echo "Examples:"
    echo "  ./view-logs.sh frontend"
    echo "  ./view-logs.sh backend"
    echo "  ./view-logs.sh"
    echo ""
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
    exit 0
fi

SERVICE="${1:-all}"

case "$SERVICE" in
    frontend)
        echo "📊 Viewing Frontend Logs (press Ctrl+C to exit)"
        docker-compose -f docker-compose.dev.yml logs -f frontend
        ;;
    backend)
        echo "📊 Viewing Backend Logs (press Ctrl+C to exit)"
        docker-compose -f docker-compose.dev.yml logs -f backend
        ;;
    all)
        echo "📊 Viewing All Logs (press Ctrl+C to exit)"
        docker-compose -f docker-compose.dev.yml logs -f
        ;;
    *)
        echo "❌ Unknown service: $SERVICE"
        show_help
        exit 1
        ;;
esac
