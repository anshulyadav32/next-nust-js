#!/usr/bin/env node

const { spawn } = require('child_process');
const path = require('path');

console.log('🚀 Starting Full-Stack Authentication System...\n');

// Start backend server (Next.js API on port 3001)
console.log('🔧 Starting backend server (Next.js API) on port 3001...');
const backend = spawn('npm', ['run', 'dev'], {
  cwd: path.join(__dirname, 'backend'),
  stdio: 'pipe'
});

backend.stdout.on('data', (data) => {
  console.log(`[Backend] ${data.toString().trim()}`);
});

backend.stderr.on('data', (data) => {
  console.error(`[Backend Error] ${data.toString().trim()}`);
});

// Wait a bit, then start frontend server
setTimeout(() => {
  console.log('🎨 Starting frontend server (Nuxt.js) on port 3000...');
  const frontend = spawn('npm', ['run', 'dev'], {
    cwd: path.join(__dirname, 'frontend'),
    stdio: 'pipe'
  });

  frontend.stdout.on('data', (data) => {
    console.log(`[Frontend] ${data.toString().trim()}`);
  });

  frontend.stderr.on('data', (data) => {
    console.error(`[Frontend Error] ${data.toString().trim()}`);
  });
}, 3000);

console.log(`
📊 Development Servers:
- 🎨 Frontend: http://localhost:3000 (Nuxt.js)
- 🔧 Backend:  http://localhost:3001 (Next.js API)

🎯 Getting Started:
1. Visit http://localhost:3000 to see the frontend
2. Register a new account or sign in
3. Check the terminal for email verification links (development mode)

Press Ctrl+C to stop all servers
`);

// Handle cleanup
process.on('SIGINT', () => {
  console.log('\n🛑 Shutting down servers...');
  backend.kill();
  frontend.kill();
  process.exit();
});
