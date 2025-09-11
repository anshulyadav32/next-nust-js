#!/bin/bash
# Start the full-stack application using Docker Compose

echo "🚀 Starting Full-Stack Authentication System with Docker..."
echo "📊 This will start:"
echo "- 🎨 Frontend: http://localhost:3002 (Nuxt.js)"
echo "- 🔧 Backend:  http://localhost:3001 (Next.js API)"

# Start services
docker compose up --build

echo "✅ To stop the services, press Ctrl+C or run: docker compose down"