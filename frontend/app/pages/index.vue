<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Hero Section -->
    <div class="bg-white shadow">
      <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4">
          <h1 class="text-2xl lg:text-3xl font-bold text-gray-900">
            🚀 Full-Stack Authentication System
          </h1>
          
          <!-- Auth Buttons -->
          <div v-if="!isAuthenticated" class="flex flex-col sm:flex-row gap-2 sm:gap-4">
            <NuxtLink to="/login" class="btn-secondary px-6 py-2 inline-flex justify-center">
              Sign In
            </NuxtLink>
            <NuxtLink to="/register" class="btn-primary px-6 py-2 inline-flex justify-center">
              Sign Up
            </NuxtLink>
          </div>
          
          <!-- User Menu -->
          <div v-else class="flex flex-col sm:flex-row items-start sm:items-center gap-2 sm:gap-4">
            <!-- Profile Image -->
            <ProfileImage 
              :user="user" 
              :editable="false"
              size="sm"
            />
            <div class="flex flex-col">
              <span class="text-gray-700 text-sm sm:text-base font-medium">Welcome, {{ user?.name || user?.email }}!</span>
              <div class="flex gap-2 mt-1">
                <NuxtLink to="/dashboard" class="btn-primary px-4 py-2 inline-flex justify-center text-sm">
                  Dashboard
                </NuxtLink>
                <button @click="handleLogout" class="btn-secondary px-4 py-2 text-sm">
                  Sign Out
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto py-8 sm:py-12 px-4 sm:px-6 lg:px-8">
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 lg:gap-12 items-center">
        <!-- Left Column - Features -->
        <div>
          <h2 class="text-3xl sm:text-4xl font-extrabold text-gray-900 mb-6">
            Modern Authentication 
            <span class="text-indigo-600">Made Simple</span>
          </h2>
          
          <p class="text-lg sm:text-xl text-gray-600 mb-8">
            A complete full-stack authentication system built with Vue.js (Nuxt) frontend 
            and Next.js backend, featuring modern security practices and beautiful UI.
          </p>

          <!-- Features List -->
          <div class="space-y-4">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div class="flex items-center justify-center h-8 w-8 rounded-md bg-indigo-500 text-white">
                  ✓
                </div>
              </div>
              <div class="ml-4">
                <h3 class="text-lg font-medium text-gray-900">Multi-Provider Authentication</h3>
                <p class="text-gray-600">Email/Password, Google OAuth, GitHub OAuth</p>
              </div>
            </div>

            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div class="flex items-center justify-center h-8 w-8 rounded-md bg-indigo-500 text-white">
                  ✓
                </div>
              </div>
              <div class="ml-4">
                <h3 class="text-lg font-medium text-gray-900">Email Verification</h3>
                <p class="text-gray-600">Secure email verification with beautiful templates</p>
              </div>
            </div>

            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div class="flex items-center justify-center h-8 w-8 rounded-md bg-indigo-500 text-white">
                  ✓
                </div>
              </div>
              <div class="ml-4">
                <h3 class="text-lg font-medium text-gray-900">Password Reset</h3>
                <p class="text-gray-600">Token-based password reset with expiration</p>
              </div>
            </div>

            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div class="flex items-center justify-center h-8 w-8 rounded-md bg-indigo-500 text-white">
                  ✓
                </div>
              </div>
              <div class="ml-4">
                <h3 class="text-lg font-medium text-gray-900">Role-Based Access Control</h3>
                <p class="text-gray-600">User and admin roles with protected routes</p>
              </div>
            </div>

            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div class="flex items-center justify-center h-8 w-8 rounded-md bg-indigo-500 text-white">
                  ✓
                </div>
              </div>
              <div class="ml-4">
                <h3 class="text-lg font-medium text-gray-900">Modern Tech Stack</h3>
                <p class="text-gray-600">Nuxt 3, Next.js 15, Prisma ORM, TypeScript</p>
              </div>
            </div>
          </div>

          <!-- CTA Buttons -->
          <div v-if="!isAuthenticated" class="mt-8 flex flex-col sm:flex-row gap-4">
            <NuxtLink to="/register" class="btn-primary px-8 py-3 text-lg">
              Get Started Free
            </NuxtLink>
            <NuxtLink to="/login" class="btn-secondary px-8 py-3 text-lg">
              Sign In
            </NuxtLink>
          </div>
        </div>

        <!-- Right Column - Tech Stack -->
        <div class="bg-white rounded-lg shadow-lg p-6 sm:p-8">
          <h3 class="text-xl sm:text-2xl font-bold text-gray-900 mb-6 text-center">
            🛠️ Tech Stack
          </h3>
          
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 sm:gap-6">
            <!-- Frontend -->
            <div class="text-center">
              <div class="bg-green-100 rounded-lg p-4 mb-3">
                <h4 class="font-semibold text-green-800">Frontend</h4>
                <div class="text-sm text-green-600 mt-2 space-y-1">
                  <div>🌊 Nuxt.js 3</div>
                  <div>🔥 Vue.js 3</div>
                  <div>🎨 Tailwind CSS</div>
                  <div>🍍 Pinia</div>
                </div>
              </div>
            </div>

            <!-- Backend -->
            <div class="text-center">
              <div class="bg-blue-100 rounded-lg p-4 mb-3">
                <h4 class="font-semibold text-blue-800">Backend</h4>
                <div class="text-sm text-blue-600 mt-2 space-y-1">
                  <div>⚡ Next.js 15</div>
                  <div>🔐 Auth.js v5</div>
                  <div>🗃️ Prisma ORM</div>
                  <div>📧 Nodemailer</div>
                </div>
              </div>
            </div>

            <!-- Database -->
            <div class="text-center">
              <div class="bg-purple-100 rounded-lg p-4 mb-3">
                <h4 class="font-semibold text-purple-800">Database</h4>
                <div class="text-sm text-purple-600 mt-2 space-y-1">
                  <div>🐘 PostgreSQL</div>
                  <div>📊 SQLite (dev)</div>
                  <div>🔄 Migrations</div>
                  <div>🎯 Type Safety</div>
                </div>
              </div>
            </div>

            <!-- Deployment -->
            <div class="text-center">
              <div class="bg-orange-100 rounded-lg p-4 mb-3">
                <h4 class="font-semibold text-orange-800">Deployment</h4>
                <div class="text-sm text-orange-600 mt-2 space-y-1">
                  <div>▲ Vercel Ready</div>
                  <div>🚀 Production</div>
                  <div>🔒 Secure</div>
                  <div>⚡ Fast</div>
                </div>
              </div>
            </div>
          </div>

          <!-- Auth Status -->
          <div v-if="isAuthenticated" class="mt-6 p-4 bg-green-50 rounded-lg text-center">
            <div class="text-green-800 font-medium">✅ You are signed in!</div>
            <div class="text-green-600 text-sm mt-1">
              Role: {{ user?.role || 'USER' }}
            </div>
          </div>
          <div v-else class="mt-6 p-4 bg-gray-50 rounded-lg text-center">
            <div class="text-gray-600">Sign in to access your dashboard</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Error Display -->
    <div v-if="error" class="fixed top-4 right-4 bg-red-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 max-w-sm">
      <div class="flex items-center justify-between">
        <span class="text-sm">{{ error }}</span>
        <button @click="error = null" class="ml-2 text-white hover:text-gray-200">
          ×
        </button>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white p-6 rounded-lg shadow-lg text-center">
        <div class="loading-spinner mx-auto mb-4"></div>
        <div class="text-gray-600">Loading...</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { user, isAuthenticated, isLoading, logout, error } = useAuth()

// Handle logout with error handling
const handleLogout = async () => {
  try {
    await logout()
  } catch (err) {
    console.error('Logout error:', err)
    // You could add a toast notification here
  }
}

// SEO
useSeoMeta({
  title: 'Full-Stack Authentication System - Nuxt + Next.js',
  description: 'Modern authentication system built with Vue.js (Nuxt) frontend and Next.js backend. Features email verification, OAuth, RBAC, and more.',
  ogTitle: 'Full-Stack Authentication System',
  ogDescription: 'Complete authentication solution with modern tech stack',
  ogType: 'website'
})
</script>
