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
echo "📱 Mobile Access (use these on your phone):"
NETWORK_IP=$(hostname -I | awk '{print $1}')
FRONTEND_URL="http://$NETWORK_IP:3002"
BACKEND_URL="http://$NETWORK_IP:3001"
echo "   - Frontend: $FRONTEND_URL"
echo "   - Backend: $BACKEND_URL"

# Check container health
echo ""
echo "🩺 Checking container health..."
if curl -s "$FRONTEND_URL/api/health" > /dev/null 2>&1; then
    echo "   ✅ Frontend is responding"
else 
    echo "   ❌ Frontend health check failed"
fi

if curl -s "$BACKEND_URL/api/health" > /dev/null 2>&1; then
    echo "   ✅ Backend is responding"
else
    echo "   ❌ Backend health check failed"
fi

echo ""
echo "📊 View logs:"
echo "   docker-compose -f docker-compose.dev.yml logs -f"
echo "   docker-compose -f docker-compose.dev.yml logs -f frontend"
echo "   docker-compose -f docker-compose.dev.yml logs -f backend"
echo ""
echo "� Troubleshooting:"
echo "   docker exec -it fullstack-auth_backend_1 sh  # Shell into backend container"
echo "   docker exec -it fullstack-auth_frontend_1 sh  # Shell into frontend container"
echo ""
echo "🛑 Stop containers:"
echo "   docker-compose -f docker-compose.dev.yml down"
echo "   docker-compose -f docker-compose.dev.yml down --volumes  # Remove volumes too"
