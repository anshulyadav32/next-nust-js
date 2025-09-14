<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">API Testing Interface</h1>
        <p class="mt-2 text-gray-600">Comprehensive testing for all backend endpoints</p>
      </div>

      <!-- Quick Actions -->
      <div class="bg-white rounded-lg shadow mb-8">
        <div class="px-6 py-4 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">Quick Actions</h2>
        </div>
        <div class="p-6">
          <div class="flex flex-wrap gap-4">
            <button @click="testAllEndpoints" :disabled="testing" class="btn-primary">
              <svg v-if="testing" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ testing ? 'Testing...' : 'Test All Endpoints' }}
            </button>
            <button @click="clearResults" class="btn-secondary">Clear Results</button>
            <button @click="exportResults" :disabled="!testResults.length" class="btn-secondary">Export Results</button>
          </div>
        </div>
      </div>

      <!-- Main Content -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <!-- Endpoints List -->
        <div class="bg-white rounded-lg shadow">
          <div class="px-6 py-4 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <h2 class="text-lg font-medium text-gray-900">API Endpoints</h2>
              <div class="flex items-center space-x-2">
                <select v-model="selectedCategory" class="text-sm border-gray-300 rounded-md">
                  <option value="all">All Categories</option>
                  <option value="auth">Authentication</option>
                  <option value="user">User Management</option>
                  <option value="admin">Admin</option>
                  <option value="system">System</option>
                </select>
              </div>
            </div>
          </div>
          <div class="p-6">
            <div class="space-y-4 max-h-96 overflow-y-auto">
              <div 
                v-for="endpoint in filteredEndpoints" 
                :key="endpoint.id"
                class="border rounded-lg p-4 hover:bg-gray-50 cursor-pointer"
                :class="{ 'ring-2 ring-indigo-500': selectedEndpoint?.id === endpoint.id }"
                @click="selectEndpoint(endpoint)"
              >
                <div class="flex items-center justify-between mb-2">
                  <div class="flex items-center space-x-2">
                    <span :class="getMethodColor(endpoint.method)" class="px-2 py-1 text-xs font-medium rounded">
                      {{ endpoint.method }}
                    </span>
                    <code class="text-sm text-gray-600">{{ endpoint.path }}</code>
                  </div>
                  <div class="flex items-center space-x-2">
                    <span v-if="endpoint.requiresAuth" class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                      🔒 Auth Required
                    </span>
                    <button 
                      @click.stop="testSingleEndpoint(endpoint)" 
                      :disabled="testing"
                      class="btn-primary btn-sm"
                    >
                      Test
                    </button>
                  </div>
                </div>
                <p class="text-sm text-gray-500">{{ endpoint.description }}</p>
                <div v-if="getEndpointResult(endpoint.id)" class="mt-2">
                  <div class="flex items-center space-x-2">
                    <span :class="getEndpointResult(endpoint.id)?.success ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" class="px-2 py-1 text-xs font-medium rounded">
                      {{ getEndpointResult(endpoint.id)?.success ? 'SUCCESS' : 'FAILED' }}
                    </span>
                    <span class="text-xs text-gray-500">{{ getEndpointResult(endpoint.id)?.responseTime }}ms</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Test Configuration & Results -->
        <div class="space-y-6">
          <!-- Test Configuration -->
          <div class="bg-white rounded-lg shadow">
            <div class="px-6 py-4 border-b border-gray-200">
              <h2 class="text-lg font-medium text-gray-900">Test Configuration</h2>
            </div>
            <div class="p-6">
              <div v-if="selectedEndpoint" class="space-y-4">
                <!-- Endpoint Info -->
                <div>
                  <h3 class="text-sm font-medium text-gray-700 mb-2">Selected Endpoint</h3>
                  <div class="flex items-center space-x-2 p-3 bg-gray-50 rounded-lg">
                    <span :class="getMethodColor(selectedEndpoint.method)" class="px-2 py-1 text-xs font-medium rounded">
                      {{ selectedEndpoint.method }}
                    </span>
                    <code class="text-sm text-gray-600">{{ selectedEndpoint.path }}</code>
                  </div>
                </div>

                <!-- Request Body -->
                <div v-if="selectedEndpoint.method !== 'GET'">
                  <label class="block text-sm font-medium text-gray-700 mb-2">
                    Request Body (JSON)
                  </label>
                  <textarea 
                    v-model="requestBody"
                    rows="6"
                    class="w-full border-gray-300 rounded-md font-mono text-sm"
                    placeholder="Enter JSON request body..."
                  ></textarea>
                </div>

                <!-- Custom Headers -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">
                    Custom Headers
                  </label>
                  <div class="space-y-2">
                    <div v-for="(header, index) in customHeaders" :key="index" class="flex space-x-2">
                      <input 
                        v-model="header.key"
                        type="text"
                        placeholder="Header name"
                        class="flex-1 border-gray-300 rounded-md text-sm"
                      >
                      <input 
                        v-model="header.value"
                        type="text"
                        placeholder="Header value"
                        class="flex-1 border-gray-300 rounded-md text-sm"
                      >
                      <button @click="removeHeader(index)" class="btn-secondary btn-sm">
                        Remove
                      </button>
                    </div>
                    <button @click="addHeader" class="btn-secondary btn-sm">
                      Add Header
                    </button>
                  </div>
                </div>

                <!-- Test Button -->
                <div class="pt-4">
                  <button 
                    @click="testSingleEndpoint(selectedEndpoint)" 
                    :disabled="testing"
                    class="btn-primary w-full"
                  >
                    <svg v-if="testing" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    {{ testing ? 'Testing...' : 'Test Endpoint' }}
                  </button>
                </div>
              </div>
              <div v-else class="text-gray-500 text-center py-8">
                <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9l3 3-3 3m5 0h3M5 20h14a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                </svg>
                <p class="mt-2">Select an endpoint to configure test</p>
              </div>
            </div>
          </div>

          <!-- Test Results -->
          <div class="bg-white rounded-lg shadow">
            <div class="px-6 py-4 border-b border-gray-200">
              <h2 class="text-lg font-medium text-gray-900">Test Results</h2>
            </div>
            <div class="p-6">
              <div v-if="currentResult" class="space-y-4">
                <!-- Result Header -->
                <div class="flex items-center justify-between">
                  <div class="flex items-center space-x-2">
                    <span :class="currentResult.success ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" class="px-2 py-1 text-xs font-medium rounded">
                      {{ currentResult.success ? 'SUCCESS' : 'FAILED' }}
                    </span>
                    <span class="text-sm text-gray-600">{{ currentResult.responseTime }}ms</span>
                    <span class="text-sm text-gray-500">{{ new Date(currentResult.timestamp).toLocaleTimeString() }}</span>
                  </div>
                </div>

                <!-- Response Data -->
                <div>
                  <h3 class="text-sm font-medium text-gray-700 mb-2">Response</h3>
                  <pre class="bg-gray-100 p-4 rounded text-sm overflow-auto max-h-96 whitespace-pre-wrap">{{ JSON.stringify(currentResult.data, null, 2) }}</pre>
                </div>

                <!-- Error Details -->
                <div v-if="!currentResult.success && currentResult.error">
                  <h3 class="text-sm font-medium text-gray-700 mb-2">Error Details</h3>
                  <div class="bg-red-50 border border-red-200 rounded-lg p-4">
                    <p class="text-sm text-red-800">{{ currentResult.error }}</p>
                  </div>
                </div>
              </div>
              <div v-else class="text-gray-500 text-center py-8">
                <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                </svg>
                <p class="mt-2">No test results yet</p>
                <p class="text-sm">Run a test to see results here</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Test Summary -->
      <div v-if="testResults.length" class="mt-8 bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">Test Summary</h2>
        </div>
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
            <div class="text-center">
              <div class="text-2xl font-bold text-gray-900">{{ testResults.length }}</div>
              <div class="text-sm text-gray-500">Total Tests</div>
            </div>
            <div class="text-center">
              <div class="text-2xl font-bold text-green-600">{{ successfulTests }}</div>
              <div class="text-sm text-gray-500">Successful</div>
            </div>
            <div class="text-center">
              <div class="text-2xl font-bold text-red-600">{{ failedTests }}</div>
              <div class="text-sm text-gray-500">Failed</div>
            </div>
            <div class="text-center">
              <div class="text-2xl font-bold text-blue-600">{{ averageResponseTime }}ms</div>
              <div class="text-sm text-gray-500">Avg Response</div>
            </div>
          </div>
          
          <!-- Results Table -->
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Endpoint</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Method</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Response Time</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Timestamp</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr v-for="result in testResults" :key="result.id" class="hover:bg-gray-50 cursor-pointer" @click="currentResult = result">
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ result.endpoint }}</td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span :class="getMethodColor(result.method)" class="px-2 py-1 text-xs font-medium rounded">
                      {{ result.method }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span :class="result.success ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'" class="px-2 py-1 text-xs font-medium rounded">
                      {{ result.success ? 'SUCCESS' : 'FAILED' }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ result.responseTime }}ms</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ new Date(result.timestamp).toLocaleTimeString() }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface ApiEndpoint {
  id: string
  method: string
  path: string
  description: string
  category: string
  requiresAuth?: boolean
  sampleData?: any
}

interface TestResult {
  id: string
  endpoint: string
  method: string
  success: boolean
  data: any
  responseTime: number
  timestamp: number
  error?: string
}

interface CustomHeader {
  key: string
  value: string
}

const config = useRuntimeConfig()
const backendUrl = config.public.apiBase || 'http://localhost:3001'

// Reactive state
const selectedCategory = ref('all')
const selectedEndpoint = ref<ApiEndpoint | null>(null)
const requestBody = ref('')
const customHeaders = ref<CustomHeader[]>([{ key: '', value: '' }])
const testing = ref(false)
const testResults = ref<TestResult[]>([])
const currentResult = ref<TestResult | null>(null)

// API endpoints configuration
const apiEndpoints = ref<ApiEndpoint[]>([
  // Authentication endpoints
  {
    id: 'auth-register',
    method: 'POST',
    path: '/api/auth/register',
    description: 'User registration',
    category: 'auth',
    sampleData: { name: 'Test User', email: 'test@example.com', password: 'password123' }
  },
  {
    id: 'auth-login',
    method: 'POST',
    path: '/api/auth/login',
    description: 'User login',
    category: 'auth',
    sampleData: { email: 'demo@example.com', password: 'password' }
  },
  {
    id: 'auth-change-username',
    method: 'POST',
    path: '/api/auth/change-username',
    description: 'Change username',
    category: 'auth',
    requiresAuth: true,
    sampleData: { username: 'newusername' }
  },
  
  // User management endpoints
  {
    id: 'profile-get',
    method: 'GET',
    path: '/api/profile',
    description: 'Get user profile',
    category: 'user',
    requiresAuth: true
  },
  {
    id: 'profile-update',
    method: 'PUT',
    path: '/api/profile',
    description: 'Update user profile',
    category: 'user',
    requiresAuth: true,
    sampleData: { name: 'Updated Name', bio: 'Updated bio' }
  },
  {
    id: 'profile-picture',
    method: 'POST',
    path: '/api/profile/picture',
    description: 'Upload profile picture',
    category: 'user',
    requiresAuth: true
  },
  {
    id: 'user-by-id',
    method: 'GET',
    path: '/api/user/1',
    description: 'Get user by ID',
    category: 'user',
    requiresAuth: true
  },
  
  // Admin endpoints
  {
    id: 'admin-dashboard',
    method: 'GET',
    path: '/api/admin/dashboard',
    description: 'Admin dashboard data',
    category: 'admin',
    requiresAuth: true
  },
  
  // System endpoints
  {
    id: 'health-check',
    method: 'GET',
    path: '/api/health',
    description: 'Health check endpoint',
    category: 'system'
  },
  {
    id: 'system-status',
    method: 'GET',
    path: '/api/status',
    description: 'Comprehensive system status',
    category: 'system'
  }
])

// Computed properties
const filteredEndpoints = computed(() => {
  if (selectedCategory.value === 'all') {
    return apiEndpoints.value
  }
  return apiEndpoints.value.filter(endpoint => endpoint.category === selectedCategory.value)
})

const successfulTests = computed(() => {
  return testResults.value.filter(result => result.success).length
})

const failedTests = computed(() => {
  return testResults.value.filter(result => !result.success).length
})

const averageResponseTime = computed(() => {
  if (testResults.value.length === 0) return 0
  const total = testResults.value.reduce((sum, result) => sum + result.responseTime, 0)
  return Math.round(total / testResults.value.length)
})

// Methods
const selectEndpoint = (endpoint: ApiEndpoint) => {
  selectedEndpoint.value = endpoint
  requestBody.value = endpoint.sampleData ? JSON.stringify(endpoint.sampleData, null, 2) : ''
}

const addHeader = () => {
  customHeaders.value.push({ key: '', value: '' })
}

const removeHeader = (index: number) => {
  customHeaders.value.splice(index, 1)
}

const getMethodColor = (method: string) => {
  switch (method) {
    case 'GET': return 'bg-green-100 text-green-800'
    case 'POST': return 'bg-blue-100 text-blue-800'
    case 'PUT': return 'bg-yellow-100 text-yellow-800'
    case 'DELETE': return 'bg-red-100 text-red-800'
    default: return 'bg-gray-100 text-gray-800'
  }
}

const getEndpointResult = (endpointId: string) => {
  return testResults.value.find(result => result.id === endpointId)
}

const testSingleEndpoint = async (endpoint: ApiEndpoint) => {
  testing.value = true
  
  const startTime = Date.now()
  try {
    let response
    const url = `${backendUrl}${endpoint.path}`
    
    // Prepare headers
    const headers: Record<string, string> = {
      'Content-Type': 'application/json'
    }
    
    // Add custom headers
    customHeaders.value.forEach(header => {
      if (header.key && header.value) {
        headers[header.key] = header.value
      }
    })
    
    // Make request
    if (endpoint.method === 'GET') {
      response = await $fetch(url, {
        credentials: 'include',
        mode: 'cors',
        headers
      })
    } else {
      let body
      try {
        body = requestBody.value ? JSON.parse(requestBody.value) : endpoint.sampleData || {}
      } catch (e) {
        body = endpoint.sampleData || {}
      }
      
      response = await $fetch(url, {
        method: endpoint.method,
        body,
        credentials: 'include',
        mode: 'cors',
        headers
      })
    }
    
    const endTime = Date.now()
    
    const result: TestResult = {
      id: endpoint.id,
      endpoint: endpoint.path,
      method: endpoint.method,
      success: true,
      data: response,
      responseTime: endTime - startTime,
      timestamp: Date.now()
    }
    
    // Update or add result
    const existingIndex = testResults.value.findIndex(r => r.id === endpoint.id)
    if (existingIndex >= 0) {
      testResults.value[existingIndex] = result
    } else {
      testResults.value.push(result)
    }
    
    currentResult.value = result
    
  } catch (error: any) {
    const endTime = Date.now()
    
    const result: TestResult = {
      id: endpoint.id,
      endpoint: endpoint.path,
      method: endpoint.method,
      success: false,
      data: error.data || error.message,
      responseTime: endTime - startTime,
      timestamp: Date.now(),
      error: error.message || 'Request failed'
    }
    
    // Update or add result
    const existingIndex = testResults.value.findIndex(r => r.id === endpoint.id)
    if (existingIndex >= 0) {
      testResults.value[existingIndex] = result
    } else {
      testResults.value.push(result)
    }
    
    currentResult.value = result
  } finally {
    testing.value = false
  }
}

const testAllEndpoints = async () => {
  testing.value = true
  
  for (const endpoint of apiEndpoints.value) {
    await testSingleEndpoint(endpoint)
    // Small delay between requests
    await new Promise(resolve => setTimeout(resolve, 100))
  }
  
  testing.value = false
}

const clearResults = () => {
  testResults.value = []
  currentResult.value = null
}

const exportResults = () => {
  const data = {
    timestamp: new Date().toISOString(),
    summary: {
      total: testResults.value.length,
      successful: successfulTests.value,
      failed: failedTests.value,
      averageResponseTime: averageResponseTime.value
    },
    results: testResults.value
  }
  
  const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `api-test-results-${new Date().toISOString().split('T')[0]}.json`
  document.body.appendChild(a)
  a.click()
  document.body.removeChild(a)
  URL.revokeObjectURL(url)
}
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