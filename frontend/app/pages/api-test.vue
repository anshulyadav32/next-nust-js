<template>
  <div class="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-2xl mx-auto">
      <h1 class="text-3xl font-bold text-gray-900 mb-8">API Test Page</h1>
      
      <div class="bg-white shadow rounded-lg p-6 mb-6">
        <h2 class="text-xl font-semibold mb-4">Test API Endpoints</h2>
        
        <div class="space-y-4">
          <button 
            @click="testSession" 
            :disabled="loading"
            class="btn-primary"
          >
            Test Session Endpoint
          </button>
          
          <button 
            @click="testLogin" 
            :disabled="loading"
            class="btn-primary"
          >
            Test Login (demo@example.com / password)
          </button>
          
          <button 
            @click="testRegister" 
            :disabled="loading"
            class="btn-primary"
          >
            Test Register
          </button>
          
          <button 
            @click="testLogout" 
            :disabled="loading"
            class="btn-secondary"
          >
            Test Logout
          </button>
        </div>
      </div>
      
      <div class="bg-white shadow rounded-lg p-6">
        <h3 class="text-lg font-semibold mb-4">API Response:</h3>
        <pre class="bg-gray-100 p-4 rounded text-sm overflow-auto">{{ response }}</pre>
      </div>
      
      <div v-if="error" class="mt-4 bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
        {{ error }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const response = ref('')
const error = ref('')
const loading = ref(false)

const testSession = async () => {
  loading.value = true
  error.value = ''
  try {
    const result = await $fetch('/api/auth/session')
    response.value = JSON.stringify(result, null, 2)
  } catch (err: any) {
    error.value = err.message || 'Session test failed'
    response.value = JSON.stringify(err, null, 2)
  } finally {
    loading.value = false
  }
}

const testLogin = async () => {
  loading.value = true
  error.value = ''
  try {
    const result = await $fetch('/api/auth/login', {
      method: 'POST',
      body: {
        email: 'demo@example.com',
        password: 'password'
      }
    })
    response.value = JSON.stringify(result, null, 2)
  } catch (err: any) {
    error.value = err.message || 'Login test failed'
    response.value = JSON.stringify(err, null, 2)
  } finally {
    loading.value = false
  }
}

const testRegister = async () => {
  loading.value = true
  error.value = ''
  try {
    const result = await $fetch('/api/auth/register', {
      method: 'POST',
      body: {
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123'
      }
    })
    response.value = JSON.stringify(result, null, 2)
  } catch (err: any) {
    error.value = err.message || 'Register test failed'
    response.value = JSON.stringify(err, null, 2)
  } finally {
    loading.value = false
  }
}

const testLogout = async () => {
  loading.value = true
  error.value = ''
  try {
    const result = await $fetch('/api/auth/logout', {
      method: 'POST'
    })
    response.value = JSON.stringify(result, null, 2)
  } catch (err: any) {
    error.value = err.message || 'Logout test failed'
    response.value = JSON.stringify(err, null, 2)
  } finally {
    loading.value = false
  }
}

// SEO
useSeoMeta({
  title: 'API Test - Full Stack Auth',
  description: 'Test page for API endpoints'
})
</script>
