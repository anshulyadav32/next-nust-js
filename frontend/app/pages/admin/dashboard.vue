<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <div class="bg-white shadow">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-6">
          <div>
            <h1 class="text-3xl font-bold text-gray-900">Admin Dashboard</h1>
            <p class="mt-1 text-sm text-gray-500">Manage users, monitor system, and configure settings</p>
          </div>
          <div class="flex items-center space-x-4">
            <span class="text-sm text-gray-500">Last updated: {{ lastUpdated }}</span>
            <button 
              @click="refreshData" 
              :disabled="loading"
              class="btn-primary btn-sm"
            >
              <svg v-if="loading" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ loading ? 'Refreshing...' : 'Refresh' }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Stats Overview -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Total Users -->
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg class="w-8 h-8 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z" />
              </svg>
            </div>
            <div class="ml-4">
              <h3 class="text-lg font-medium text-gray-900">Total Users</h3>
              <p class="text-2xl font-bold text-blue-600">{{ dashboardData?.totalUsers || 0 }}</p>
            </div>
          </div>
        </div>

        <!-- Active Sessions -->
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg class="w-8 h-8 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <div class="ml-4">
              <h3 class="text-lg font-medium text-gray-900">Active Sessions</h3>
              <p class="text-2xl font-bold text-green-600">{{ dashboardData?.activeSessions || 0 }}</p>
            </div>
          </div>
        </div>

        <!-- Admin Users -->
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <svg class="w-8 h-8 text-purple-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
              </svg>
            </div>
            <div class="ml-4">
              <h3 class="text-lg font-medium text-gray-900">Admin Users</h3>
              <p class="text-2xl font-bold text-purple-600">{{ dashboardData?.adminUsers || 0 }}</p>
            </div>
          </div>
        </div>

        <!-- System Status -->
        <div class="bg-white rounded-lg shadow p-6">
          <div class="flex items-center">
            <div class="flex-shrink-0">
              <div :class="systemStatus ? 'bg-green-100' : 'bg-red-100'" class="w-8 h-8 rounded-full flex items-center justify-center">
                <div :class="systemStatus ? 'bg-green-500' : 'bg-red-500'" class="w-3 h-3 rounded-full"></div>
              </div>
            </div>
            <div class="ml-4">
              <h3 class="text-lg font-medium text-gray-900">System Status</h3>
              <p :class="systemStatus ? 'text-green-600' : 'text-red-600'" class="text-sm font-medium">
                {{ systemStatus ? 'Operational' : 'Issues Detected' }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <!-- Recent Users -->
        <div class="bg-white rounded-lg shadow">
          <div class="px-6 py-4 border-b border-gray-200">
            <h2 class="text-lg font-medium text-gray-900">Recent Users</h2>
          </div>
          <div class="p-6">
            <div v-if="dashboardData?.recentUsers?.length" class="space-y-4">
              <div v-for="user in dashboardData.recentUsers" :key="user.id" class="flex items-center space-x-4 p-3 border rounded-lg">
                <div class="flex-shrink-0">
                  <img 
                    :src="user.profileImage || `https://api.dicebear.com/7.x/avataaars/svg?seed=${user.email}`" 
                    :alt="user.name || user.email"
                    class="h-10 w-10 rounded-full"
                  >
                </div>
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-medium text-gray-900 truncate">
                    {{ user.name || user.email }}
                  </p>
                  <p class="text-sm text-gray-500 truncate">{{ user.email }}</p>
                </div>
                <div class="flex-shrink-0">
                  <span :class="user.role === 'ADMIN' ? 'bg-purple-100 text-purple-800' : 'bg-gray-100 text-gray-800'" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium">
                    {{ user.role }}
                  </span>
                </div>
              </div>
            </div>
            <div v-else class="text-gray-500 text-center py-8">
              <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z" />
              </svg>
              <p class="mt-2">No recent users</p>
            </div>
          </div>
        </div>

        <!-- System Metrics -->
        <div class="bg-white rounded-lg shadow">
          <div class="px-6 py-4 border-b border-gray-200">
            <h2 class="text-lg font-medium text-gray-900">System Metrics</h2>
          </div>
          <div class="p-6">
            <div class="space-y-6">
              <!-- Database Status -->
              <div>
                <div class="flex items-center justify-between mb-2">
                  <span class="text-sm font-medium text-gray-700">Database</span>
                  <span :class="dashboardData?.database?.status === 'connected' ? 'text-green-600' : 'text-red-600'" class="text-sm font-medium">
                    {{ dashboardData?.database?.status || 'Unknown' }}
                  </span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                  <div :class="dashboardData?.database?.status === 'connected' ? 'bg-green-600' : 'bg-red-600'" class="h-2 rounded-full" :style="{ width: dashboardData?.database?.status === 'connected' ? '100%' : '0%' }"></div>
                </div>
              </div>

              <!-- Memory Usage -->
              <div>
                <div class="flex items-center justify-between mb-2">
                  <span class="text-sm font-medium text-gray-700">Memory Usage</span>
                  <span class="text-sm font-medium text-gray-600">{{ dashboardData?.memory?.used || 0 }}MB / {{ dashboardData?.memory?.total || 0 }}MB</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                  <div class="bg-blue-600 h-2 rounded-full" :style="{ width: `${dashboardData?.memory?.percentage || 0}%` }"></div>
                </div>
              </div>

              <!-- API Response Time -->
              <div>
                <div class="flex items-center justify-between mb-2">
                  <span class="text-sm font-medium text-gray-700">API Response Time</span>
                  <span class="text-sm font-medium text-gray-600">{{ dashboardData?.apiResponseTime || 0 }}ms</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                  <div :class="getResponseTimeColor(dashboardData?.apiResponseTime || 0)" class="h-2 rounded-full" :style="{ width: `${Math.min((dashboardData?.apiResponseTime || 0) / 10, 100)}%` }"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Actions Panel -->
      <div class="bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">Admin Actions</h2>
        </div>
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <button 
              @click="viewAllUsers" 
              class="btn-secondary flex items-center justify-center space-x-2"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z" />
              </svg>
              <span>View All Users</span>
            </button>
            
            <button 
              @click="viewSystemLogs" 
              class="btn-secondary flex items-center justify-center space-x-2"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              <span>System Logs</span>
            </button>
            
            <button 
              @click="manageSettings" 
              class="btn-secondary flex items-center justify-center space-x-2"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
              <span>Settings</span>
            </button>
            
            <button 
              @click="exportData" 
              class="btn-secondary flex items-center justify-center space-x-2"
            >
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              <span>Export Data</span>
            </button>
          </div>
        </div>
      </div>

      <!-- Error Display -->
      <div v-if="error" class="mt-8 bg-red-50 border border-red-200 rounded-lg p-6">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400 mt-0.5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <div>
            <h3 class="text-sm font-medium text-red-800">Error Loading Dashboard Data</h3>
            <div class="mt-2 text-sm text-red-700">
              <p>{{ error }}</p>
              <p class="mt-2">Please ensure the backend server is running and you have admin privileges.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface DashboardData {
  totalUsers: number
  activeSessions: number
  adminUsers: number
  recentUsers: Array<{
    id: string
    email: string
    name?: string
    role: string
    profileImage?: string
  }>
  database: {
    status: string
  }
  memory: {
    used: number
    total: number
    percentage: number
  }
  apiResponseTime: number
}

// Check if user is admin
definePageMeta({
  middleware: 'auth'
})

const config = useRuntimeConfig()
const backendUrl = config.public.apiBase || 'http://localhost:3001'
const { user } = useAuth()

// Reactive state
const dashboardData = ref<DashboardData | null>(null)
const loading = ref(true)
const error = ref<string | null>(null)
const lastUpdated = ref('')
const systemStatus = ref(true)

// Load dashboard data
const loadDashboardData = async () => {
  loading.value = true
  error.value = null
  
  try {
    const response = await $fetch(`${backendUrl}/api/admin/dashboard`, {
      credentials: 'include',
      mode: 'cors'
    })
    
    dashboardData.value = response.data || response
    systemStatus.value = true
    lastUpdated.value = new Date().toLocaleTimeString()
  } catch (err: any) {
    error.value = err.data?.error || err.message || 'Failed to load dashboard data'
    systemStatus.value = false
    
    // Mock data for development/testing
    dashboardData.value = {
      totalUsers: 156,
      activeSessions: 23,
      adminUsers: 3,
      recentUsers: [
        {
          id: '1',
          email: 'demo@example.com',
          name: 'Demo User',
          role: 'USER'
        },
        {
          id: '2',
          email: 'admin@example.com',
          name: 'Admin User',
          role: 'ADMIN'
        }
      ],
      database: {
        status: 'connected'
      },
      memory: {
        used: 512,
        total: 1024,
        percentage: 50
      },
      apiResponseTime: 145
    }
    lastUpdated.value = new Date().toLocaleTimeString()
  } finally {
    loading.value = false
  }
}

// Refresh data
const refreshData = () => {
  loadDashboardData()
}

// Get response time color
const getResponseTimeColor = (time: number) => {
  if (time < 100) return 'bg-green-600'
  if (time < 300) return 'bg-yellow-600'
  return 'bg-red-600'
}

// Admin actions
const viewAllUsers = () => {
  // Navigate to users management page
  navigateTo('/admin/users')
}

const viewSystemLogs = () => {
  // Navigate to system logs page
  navigateTo('/admin/logs')
}

const manageSettings = () => {
  // Navigate to settings page
  navigateTo('/admin/settings')
}

const exportData = async () => {
  try {
    const response = await $fetch(`${backendUrl}/api/admin/export`, {
      credentials: 'include',
      mode: 'cors'
    })
    
    // Handle export response
    console.log('Export initiated:', response)
  } catch (err) {
    console.error('Export failed:', err)
  }
}

// Check admin access
const checkAdminAccess = () => {
  if (user.value && user.value.role !== 'ADMIN') {
    throw createError({
      statusCode: 403,
      statusMessage: 'Access denied. Admin privileges required.'
    })
  }
}

// Auto-refresh data
let refreshInterval: NodeJS.Timeout

onMounted(() => {
  checkAdminAccess()
  loadDashboardData()
  
  // Auto-refresh every 5 minutes
  refreshInterval = setInterval(loadDashboardData, 5 * 60 * 1000)
})

onUnmounted(() => {
  if (refreshInterval) {
    clearInterval(refreshInterval)
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