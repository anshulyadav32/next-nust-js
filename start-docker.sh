#!/bin/bash

echo "🐳 Starting Fullstack Auth App with Docker..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Build and start containers
echo "🔨 Building Docker images..."
docker-compose -f docker-compose.dev.yml build

echo "🚀 Starting containers..."
docker-compose -f docker-compose.dev.yml up -d

echo "✅ Application started!"
echo ""
echo "🌐 Frontend: http://localhost:3002"
echo "🔧 Backend API: http://localhost:3001"
echo ""
echo "📊 To view logs: docker-compose -f docker-compose.dev.yml logs -f"
echo "🛑 To stop: docker-compose -f docker-compose.dev.yml down"
