<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Server Status Dashboard</h1>
        <p class="mt-2 text-gray-600">Real-time monitoring, API testing, and system information</p>
      </div>

      <!-- Status Cards -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Server Status -->
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <div :class="serverStatus.online ? 'bg-green-100' : 'bg-red-100'" class="w-8 h-8 rounded-full flex items-center justify-center">
                <div :class="serverStatus.online ? 'bg-green-500' : 'bg-red-500'" class="w-3 h-3 rounded-full"></div>
              </div>
            </div>
            <div class="ml-4">
              <h3 class="text-lg font-medium text-gray-900">Server Status</h3>
              <p :class="serverStatus.online ? 'text-green-600' : 'text-red-600'" class="text-sm font-medium">
                {{ serverStatus.online ? 'Online' : 'Offline' }}
              </p>
            </div>
          </div>
        </div>

        <!-- Response Time -->
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg class="w-8 h-8 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <div class="ml-4">
              <h3 class="text-lg font-medium text-gray-900">Response Time</h3>
              <p class="text-sm font-medium text-gray-600">{{ responseTime }}ms</p>
            </div>
          </div>
        </div>

        <!-- API Endpoints -->
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg class="w-8 h-8 text-purple-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9l3 3-3 3m5 0h3M5 20h14a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
            <div class="ml-4">
              <h3 class="text-lg font-medium text-gray-900">API Endpoints</h3>
              <p class="text-sm font-medium text-gray-600">{{ apiEndpoints.length }} Available</p>
            </div>
          </div>
        </div>

        <!-- Last Updated -->
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg class="w-8 h-8 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
              </svg>
            </div>
            <div class="ml-4">
              <h3 class="text-lg font-medium text-gray-900">Last Updated</h3>
              <p class="text-sm font-medium text-gray-600">{{ lastUpdated }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- API Testing Section -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <!-- API Endpoints List -->
        <div class="bg-white rounded-lg shadow">
          <div class="px-6 py-4 border-b border-gray-200">
            <h2 class="text-lg font-medium text-gray-900">API Endpoints</h2>
          </div>
          <div class="p-6">
            <div class="space-y-4">
              <div v-for="endpoint in apiEndpoints" :key="endpoint.path" class="border rounded-lg p-4">
                <div class="flex items-center justify-between mb-2">
                  <div class="flex items-center space-x-2">
                    <span :class="getMethodColor(endpoint.method)" class="px-2 py-1 text-xs font-medium rounded">
                      {{ endpoint.method }}
                    </span>
                    <code class="text-sm text-gray-600">{{ endpoint.path }}</code>
                  </div>
                  <button 
                    @click="testEndpoint(endpoint)" 
                    :disabled="testing"
                    class="btn-primary btn-sm"
                  >
                    Test
                  </button>
                </div>
                <p class="text-sm text-gray-500">{{ endpoint.description }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Test Results -->
        <div class="bg-white rounded-lg shadow">
          <div class="px-6 py-4 border-b border-gray-200">
            <h2 class="text-lg font-medium text-gray-900">Test Results</h2>
          </div>
          <div class="p-6">
            <div v-if="testResult" class="space-y-4">
              <div class="flex items-center space-x-2">
                <span :class="testResult.success ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" class="px-2 py-1 text-xs font-medium rounded">
                  {{ testResult.success ? 'SUCCESS' : 'ERROR' }}
                </span>
                <span class="text-sm text-gray-600">{{ testResult.responseTime }}ms</span>
              </div>
              <pre class="bg-gray-100 p-4 rounded text-sm overflow-auto max-h-96">{{ JSON.stringify(testResult.data, null, 2) }}</pre>
            </div>
            <div v-else class="text-gray-500 text-center py-8">
              Select an endpoint to test
            </div>
          </div>
        </div>
      </div>

      <!-- System Information -->
      <div class="bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">System Information</h2>
        </div>
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Backend Server</h3>
              <p class="mt-1 text-sm text-gray-900">{{ backendUrl }}</p>
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Frontend</h3>
              <p class="mt-1 text-sm text-gray-900">Nuxt.js 3 + Vue.js 3</p>
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Environment</h3>
              <p class="mt-1 text-sm text-gray-900">Development</p>
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">CORS Origins</h3>
              <p class="mt-1 text-sm text-gray-900">localhost:3000, localhost:3001</p>
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Authentication</h3>
              <p class="mt-1 text-sm text-gray-900">Cookie-based Sessions</p>
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Database</h3>
              <p class="mt-1 text-sm text-gray-900">PostgreSQL + Prisma ORM</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface ApiEndpoint {
  method: string
  path: string
  description: string
  requiresAuth?: boolean
}

interface TestResult {
  success: boolean
  data: any
  responseTime: number
  error?: string
}

const config = useRuntimeConfig()
const backendUrl = config.public.apiBase || 'http://localhost:3001'

// Reactive state
const serverStatus = ref({ online: false })
const responseTime = ref(0)
const lastUpdated = ref('')
const testing = ref(false)
const testResult = ref<TestResult | null>(null)

// API endpoints from the backend
const apiEndpoints = ref<ApiEndpoint[]>([
  { method: 'GET', path: '/api/health', description: 'Health check endpoint' },
  { method: 'GET', path: '/api/status', description: 'Comprehensive system status' },
  { method: 'POST', path: '/api/auth/register', description: 'User registration' },
  { method: 'POST', path: '/api/auth/login', description: 'User login' },
  { method: 'POST', path: '/api/auth/change-username', description: 'Change username' },
  { method: 'GET', path: '/api/profile', description: 'Get user profile', requiresAuth: true },
  { method: 'PUT', path: '/api/profile', description: 'Update user profile', requiresAuth: true },
  { method: 'POST', path: '/api/profile/picture', description: 'Upload profile picture', requiresAuth: true },
  { method: 'GET', path: '/api/user/[id]', description: 'Get user by ID', requiresAuth: true },
  { method: 'GET', path: '/api/admin/dashboard', description: 'Admin dashboard data', requiresAuth: true }
])

// Check server status
const checkServerStatus = async () => {
  const startTime = Date.now()
  try {
    const response = await $fetch(`${backendUrl}/api/health`)
    const endTime = Date.now()
    
    serverStatus.value.online = true
    responseTime.value = endTime - startTime
    lastUpdated.value = new Date().toLocaleTimeString()
  } catch (error) {
    serverStatus.value.online = false
    responseTime.value = 0
    lastUpdated.value = new Date().toLocaleTimeString()
  }
}

// Test specific endpoint
const testEndpoint = async (endpoint: ApiEndpoint) => {
  testing.value = true
  testResult.value = null
  
  const startTime = Date.now()
  try {
    let response
    const url = `${backendUrl}${endpoint.path.replace('[id]', '1')}`
    
    if (endpoint.method === 'GET') {
      response = await $fetch(url)
    } else {
      // For POST/PUT requests, provide sample data
      const sampleData = getSampleData(endpoint.path)
      response = await $fetch(url, {
        method: endpoint.method,
        body: sampleData
      })
    }
    
    const endTime = Date.now()
    
    testResult.value = {
      success: true,
      data: response,
      responseTime: endTime - startTime
    }
  } catch (error: any) {
    const endTime = Date.now()
    
    testResult.value = {
      success: false,
      data: error.data || error.message,
      responseTime: endTime - startTime,
      error: error.message
    }
  } finally {
    testing.value = false
  }
}

// Get sample data for testing
const getSampleData = (path: string) => {
  switch (path) {
    case '/api/auth/register':
      return { name: 'Test User', email: 'test@example.com', password: 'password123' }
    case '/api/auth/login':
      return { email: 'demo@example.com', password: 'password' }
    case '/api/auth/change-username':
      return { username: 'newusername' }
    case '/api/profile':
      return { name: 'Updated Name', bio: 'Updated bio' }
    case '/api/profile/picture':
      return { imageData: 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAABAAEDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAX/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCdABmX/9k=' }
    default:
      return {}
  }
}

// Get method color class
const getMethodColor = (method: string) => {
  switch (method) {
    case 'GET': return 'bg-green-100 text-green-800'
    case 'POST': return 'bg-blue-100 text-blue-800'
    case 'PUT': return 'bg-yellow-100 text-yellow-800'
    case 'DELETE': return 'bg-red-100 text-red-800'
    default: return 'bg-gray-100 text-gray-800'
  }
}

// Auto-refresh server status
let statusInterval: NodeJS.Timeout

onMounted(() => {
  checkServerStatus()
  statusInterval = setInterval(checkServerStatus, 30000) // Check every 30 seconds
})

onUnmounted(() => {
  if (statusInterval) {
    clearInterval(statusInterval)
  }
})
</script>

<style scoped>
.btn-primary {
  @apply bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed;
}

.btn-secondary {
  @apply bg-gray-600 text-white px-4 py-2 rounded-md hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed;
}

.btn-sm {
  @apply px-3 py-1 text-sm;
}
</style>