export default defineEventHandler((event) => {
  // Add CORS headers
  setHeader(event, 'Access-Control-Allow-Origin', '*')
  setHeader(event, 'Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  setHeader(event, 'Access-Control-Allow-Headers', 'Content-Type, Authorization')
  
  return {
    status: 'ok',
    timestamp: new Date().toISOString()
  }
})
