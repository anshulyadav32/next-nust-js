<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Header -->
    <header class="bg-white shadow">
      <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center">
          <h1 class="text-3xl font-bold text-gray-900">Dashboard</h1>
          <div class="flex items-center space-x-4">
            <span class="text-gray-700">{{ user?.name || user?.email }}</span>
            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-indigo-100 text-indigo-800">
              {{ user?.role }}
            </span>
            <button @click="logout" class="btn-secondary px-4 py-2">
              Sign Out
            </button>
          </div>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <div class="px-4 py-6 sm:px-0">
        <!-- Welcome Card -->
        <div class="bg-white overflow-hidden shadow rounded-lg mb-6">
          <div class="px-4 py-5 sm:p-6">
            <h3 class="text-lg leading-6 font-medium text-gray-900 mb-2">
              Welcome to your dashboard! 🎉
            </h3>
            <p class="text-gray-600 mb-4">
              You have successfully signed in to the full-stack authentication system.
            </p>
            
            <!-- Email Verification Status -->
            <div v-if="user?.emailVerified" class="flex items-center text-green-600 mb-4">
              <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
              </svg>
              Email verified
            </div>
            <div v-else class="flex items-center text-yellow-600 mb-4">
              <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
              </svg>
              Email not verified
              <button @click="sendVerification" class="ml-2 text-indigo-600 hover:text-indigo-500 font-medium">
                Send verification email
              </button>
            </div>
          </div>
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3 mb-6">
          <!-- Account Info -->
          <div class="bg-white overflow-hidden shadow rounded-lg">
            <div class="p-5">
              <div class="flex items-center">
                <div class="flex-shrink-0">
                  <svg class="h-6 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                </div>
                <div class="ml-5 w-0 flex-1">
                  <dl>
                    <dt class="text-sm font-medium text-gray-500 truncate">Account Type</dt>
                    <dd class="text-lg font-medium text-gray-900">{{ user?.role }}</dd>
                  </dl>
                </div>
              </div>
            </div>
          </div>

          <!-- Member Since -->
          <div class="bg-white overflow-hidden shadow rounded-lg">
            <div class="p-5">
              <div class="flex items-center">
                <div class="flex-shrink-0">
                  <svg class="h-6 w-6 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3a2 2 0 012-2h4a2 2 0 012 2v4m-6 4v10m6-10v10m6-4H6" />
                  </svg>
                </div>
                <div class="ml-5 w-0 flex-1">
                  <dl>
                    <dt class="text-sm font-medium text-gray-500 truncate">Member Since</dt>
                    <dd class="text-lg font-medium text-gray-900">
                      {{ formatDate(user?.createdAt) }}
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
          </div>

          <!-- Status -->
          <div class="bg-white overflow-hidden shadow rounded-lg">
            <div class="p-5">
              <div class="flex items-center">
                <div class="flex-shrink-0">
                  <svg class="h-6 w-6 text-green-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <div class="ml-5 w-0 flex-1">
                  <dl>
                    <dt class="text-sm font-medium text-gray-500 truncate">Status</dt>
                    <dd class="text-lg font-medium text-green-600">Active</dd>
                  </dl>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Actions -->
        <div class="bg-white shadow rounded-lg">
          <div class="px-4 py-5 sm:p-6">
            <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">
              Quick Actions
            </h3>
            <div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <button @click="updateProfile" class="btn-primary text-center">
                Update Profile
              </button>
              <button @click="changePassword" class="btn-secondary text-center">
                Change Password
              </button>
              <NuxtLink 
                v-if="user?.role === 'ADMIN'" 
                to="/admin" 
                class="btn-primary bg-red-600 hover:bg-red-700 text-center"
              >
                Admin Panel
              </NuxtLink>
              <button @click="downloadData" class="btn-secondary text-center">
                Download My Data
              </button>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- Notifications -->
    <div v-if="notification" class="fixed bottom-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg">
      {{ notification }}
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  middleware: 'auth'
})

const { user, logout, sendVerification } = useAuth()

const notification = ref('')

// Format date helper
const formatDate = (date: Date | string | undefined) => {
  if (!date) return 'Unknown'
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// Actions
const updateProfile = () => {
  // TODO: Implement profile update
  notification.value = 'Profile update feature coming soon!'
  setTimeout(() => {
    notification.value = ''
  }, 3000)
}

const changePassword = () => {
  // TODO: Navigate to change password page
  notification.value = 'Password change feature coming soon!'
  setTimeout(() => {
    notification.value = ''
  }, 3000)
}

const downloadData = () => {
  // TODO: Implement data export
  notification.value = 'Data export feature coming soon!'
  setTimeout(() => {
    notification.value = ''
  }, 3000)
}

// SEO
useSeoMeta({
  title: 'Dashboard - Full Stack Auth',
  description: 'Your personal dashboard with account information and settings.'
})
</script>
