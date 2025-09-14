<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Navigation Bar -->
    <nav class="bg-white shadow-lg border-b border-gray-200 sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
          <!-- Logo/Brand -->
          <div class="flex items-center">
            <NuxtLink to="/" class="flex items-center space-x-2 group">
              <div class="w-8 h-8 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-lg flex items-center justify-center group-hover:scale-110 transition-transform duration-200">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              </div>
              <span class="text-xl font-bold text-gray-900 group-hover:text-indigo-600 transition-colors">
                AuthSystem
              </span>
            </NuxtLink>
          </div>

          <!-- Desktop Navigation -->
          <div class="hidden md:flex items-center space-x-8">
            <NuxtLink 
              to="/" 
              class="nav-link"
              :class="{ 'nav-link-active': $route.path === '/' }"
            >
              Home
            </NuxtLink>
            
            <NuxtLink 
              v-if="isAuthenticated" 
              to="/dashboard" 
              class="nav-link"
              :class="{ 'nav-link-active': $route.path === '/dashboard' }"
            >
              Dashboard
            </NuxtLink>
            
            <NuxtLink 
              v-if="isAuthenticated" 
              to="/profile-settings" 
              class="nav-link"
              :class="{ 'nav-link-active': $route.path === '/profile-settings' }"
            >
              Profile
            </NuxtLink>
          </div>

          <!-- User Menu / Auth Buttons -->
          <div class="flex items-center space-x-4">
            <!-- Loading State -->
            <div v-if="isLoading" class="flex items-center space-x-2">
              <div class="animate-spin rounded-full h-5 w-5 border-2 border-indigo-500 border-t-transparent"></div>
              <span class="text-sm text-gray-500">Loading...</span>
            </div>

            <!-- Authenticated User Menu -->
            <div v-else-if="isAuthenticated" class="flex items-center space-x-4">
              <!-- Profile Image -->
              <div class="relative">
                <ProfileImage 
                  :user="user" 
                  :editable="false"
                  class="w-8 h-8"
                />
              </div>
              
              <!-- User Info -->
              <div class="hidden sm:block">
                <div class="text-sm font-medium text-gray-900">
                  {{ user?.name || user?.email }}
                </div>
                <div class="text-xs text-gray-500">
                  {{ user?.role }}
                </div>
              </div>

              <!-- Dropdown Menu -->
              <div class="relative" ref="dropdown">
                <button 
                  @click="toggleDropdown"
                  class="flex items-center text-gray-500 hover:text-gray-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 rounded-full p-1"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                  </svg>
                </button>

                <!-- Dropdown Content -->
                <div 
                  v-if="showDropdown"
                  class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-50 border border-gray-200"
                >
                  <NuxtLink 
                    to="/profile-settings" 
                    class="dropdown-item"
                    @click="closeDropdown"
                  >
                    <svg class="w-4 h-4 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                    Profile Settings
                  </NuxtLink>
                  
                  <NuxtLink 
                    to="/dashboard" 
                    class="dropdown-item"
                    @click="closeDropdown"
                  >
                    <svg class="w-4 h-4 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2H5a2 2 0 00-2-2z" />
                    </svg>
                    Dashboard
                  </NuxtLink>
                  
                  <div class="border-t border-gray-100"></div>
                  
                  <button 
                    @click="handleLogout"
                    class="dropdown-item text-red-600 hover:bg-red-50"
                  >
                    <svg class="w-4 h-4 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
                    </svg>
                    Sign Out
                  </button>
                </div>
              </div>
            </div>

            <!-- Guest User Buttons -->
            <div v-else class="flex items-center space-x-3">
              <NuxtLink 
                to="/login" 
                class="btn-secondary px-4 py-2 text-sm"
              >
                Sign In
              </NuxtLink>
              <NuxtLink 
                to="/register" 
                class="btn-primary px-4 py-2 text-sm"
              >
                Sign Up
              </NuxtLink>
            </div>
          </div>

          <!-- Mobile Menu Button -->
          <div class="md:hidden">
            <button 
              @click="toggleMobileMenu"
              class="text-gray-500 hover:text-gray-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 rounded-md p-2"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path v-if="!showMobileMenu" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>

        <!-- Mobile Menu -->
        <div v-if="showMobileMenu" class="md:hidden border-t border-gray-200 py-4">
          <div class="space-y-2">
            <NuxtLink 
              to="/" 
              class="mobile-nav-link"
              :class="{ 'mobile-nav-link-active': $route.path === '/' }"
              @click="closeMobileMenu"
            >
              Home
            </NuxtLink>
            
            <NuxtLink 
              v-if="isAuthenticated" 
              to="/dashboard" 
              class="mobile-nav-link"
              :class="{ 'mobile-nav-link-active': $route.path === '/dashboard' }"
              @click="closeMobileMenu"
            >
              Dashboard
            </NuxtLink>
            
            <NuxtLink 
              v-if="isAuthenticated" 
              to="/profile-settings" 
              class="mobile-nav-link"
              :class="{ 'mobile-nav-link-active': $route.path === '/profile-settings' }"
              @click="closeMobileMenu"
            >
              Profile Settings
            </NuxtLink>

            <!-- Mobile Auth Buttons -->
            <div v-if="!isAuthenticated" class="pt-4 border-t border-gray-200 space-y-2">
              <NuxtLink 
                to="/login" 
                class="mobile-nav-link"
                @click="closeMobileMenu"
              >
                Sign In
              </NuxtLink>
              <NuxtLink 
                to="/register" 
                class="mobile-nav-link"
                @click="closeMobileMenu"
              >
                Sign Up
              </NuxtLink>
            </div>

            <!-- Mobile Logout -->
            <button 
              v-if="isAuthenticated"
              @click="handleLogout"
              class="mobile-nav-link text-red-600 hover:bg-red-50 w-full text-left"
            >
              Sign Out
            </button>
          </div>
        </div>
      </div>
    </nav>

    <!-- Main Content -->
    <main class="flex-1">
      <slot />
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useAuth } from '~/composables/useAuth'

// Auth composable
const { user, isAuthenticated, isLoading, logout } = useAuth()

// UI state
const showDropdown = ref(false)
const showMobileMenu = ref(false)
const dropdown = ref(null)

// Toggle dropdown menu
const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value
}

// Close dropdown menu
const closeDropdown = () => {
  showDropdown.value = false
}

// Toggle mobile menu
const toggleMobileMenu = () => {
  showMobileMenu.value = !showMobileMenu.value
}

// Close mobile menu
const closeMobileMenu = () => {
  showMobileMenu.value = false
}

// Handle logout
const handleLogout = async () => {
  await logout()
  closeDropdown()
  closeMobileMenu()
  await navigateTo('/')
}

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
  if (dropdown.value && !dropdown.value.contains(event.target)) {
    closeDropdown()
  }
}

// Close mobile menu when clicking outside
const handleMobileClickOutside = (event) => {
  if (showMobileMenu.value && !event.target.closest('nav')) {
    closeMobileMenu()
  }
}

// Add event listeners
onMounted(() => {
  document.addEventListener('click', handleClickOutside)
  document.addEventListener('click', handleMobileClickOutside)
})

// Remove event listeners
onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
  document.removeEventListener('click', handleMobileClickOutside)
})
</script>