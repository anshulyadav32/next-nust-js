<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Profile Settings</h1>
        <p class="mt-2 text-gray-600">Manage your account information and preferences</p>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <!-- Profile Image Section -->
        <div class="lg:col-span-1">
          <div class="bg-white rounded-lg shadow p-6">
            <h2 class="text-lg font-medium text-gray-900 mb-4">Profile Picture</h2>
            <div class="flex flex-col items-center">
              <ProfileImage 
                :user="user" 
                :editable="true"
                class="mb-4"
              />
              <p class="text-sm text-gray-500 text-center">
                Click on the image to upload a new profile picture
              </p>
            </div>
          </div>
        </div>

        <!-- Profile Information Section -->
        <div class="lg:col-span-2">
          <div class="bg-white rounded-lg shadow">
            <div class="px-6 py-4 border-b border-gray-200">
              <h2 class="text-lg font-medium text-gray-900">Personal Information</h2>
            </div>
            
            <form @submit.prevent="updateProfile" class="p-6 space-y-6">
              <!-- Username -->
              <div>
                <label for="username" class="block text-sm font-medium text-gray-700 mb-2">
                  Username
                </label>
                <input
                  id="username"
                  v-model="form.username"
                  type="text"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  placeholder="Enter your username"
                  :disabled="isLoading"
                />
                <p class="mt-1 text-sm text-gray-500">
                  This will be your unique identifier on the platform
                </p>
              </div>

              <!-- Name and Surname -->
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label for="firstName" class="block text-sm font-medium text-gray-700 mb-2">
                    First Name
                  </label>
                  <input
                    id="firstName"
                    v-model="form.firstName"
                    type="text"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="Enter your first name"
                    :disabled="isLoading"
                  />
                </div>
                <div>
                  <label for="lastName" class="block text-sm font-medium text-gray-700 mb-2">
                    Last Name
                  </label>
                  <input
                    id="lastName"
                    v-model="form.lastName"
                    type="text"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                    placeholder="Enter your last name"
                    :disabled="isLoading"
                  />
                </div>
              </div>

              <!-- Email -->
              <div>
                <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                  Email Address
                </label>
                <input
                  id="email"
                  v-model="form.email"
                  type="email"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  placeholder="Enter your email address"
                  :disabled="isLoading"
                />
                <p class="mt-1 text-sm text-gray-500">
                  This will be used for account notifications and login
                </p>
              </div>

              <!-- Phone -->
              <div>
                <label for="phone" class="block text-sm font-medium text-gray-700 mb-2">
                  Phone Number
                </label>
                <input
                  id="phone"
                  v-model="form.phone"
                  type="tel"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  placeholder="Enter your phone number"
                  :disabled="isLoading"
                />
                <p class="mt-1 text-sm text-gray-500">
                  Include country code (e.g., +1 555 123 4567)
                </p>
              </div>

              <!-- Bio -->
              <div>
                <label for="bio" class="block text-sm font-medium text-gray-700 mb-2">
                  Bio
                </label>
                <textarea
                  id="bio"
                  v-model="form.bio"
                  rows="3"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  placeholder="Tell us about yourself..."
                  :disabled="isLoading"
                ></textarea>
                <p class="mt-1 text-sm text-gray-500">
                  A brief description about yourself (optional)
                </p>
              </div>

              <!-- Error Message -->
              <div v-if="error" class="bg-red-50 border border-red-200 rounded-md p-4">
                <div class="flex">
                  <div class="flex-shrink-0">
                    <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                    </svg>
                  </div>
                  <div class="ml-3">
                    <p class="text-sm text-red-800">{{ error }}</p>
                  </div>
                </div>
              </div>

              <!-- Success Message -->
              <div v-if="successMessage" class="bg-green-50 border border-green-200 rounded-md p-4">
                <div class="flex">
                  <div class="flex-shrink-0">
                    <svg class="h-5 w-5 text-green-400" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                    </svg>
                  </div>
                  <div class="ml-3">
                    <p class="text-sm text-green-800">{{ successMessage }}</p>
                  </div>
                </div>
              </div>

              <!-- Action Buttons -->
              <div class="flex justify-end space-x-3">
                <button
                  type="button"
                  @click="resetForm"
                  class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
                  :disabled="isLoading"
                >
                  Reset
                </button>
                <button
                  type="submit"
                  class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50"
                  :disabled="isLoading"
                >
                  <span v-if="isLoading" class="flex items-center">
                    <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Updating...
                  </span>
                  <span v-else>Update Profile</span>
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed, watch } from 'vue'
import { useAuth } from '~/composables/useAuth'

// Page meta
definePageMeta({
  middleware: 'auth',
  layout: 'default'
})

// Auth composable
const { user, isAuthenticated, isLoading: authLoading } = useAuth()

// Form state
const form = reactive({
  username: '',
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  bio: ''
})

// UI state
const isLoading = ref(false)
const error = ref('')
const successMessage = ref('')

// Computed properties
const hasChanges = computed(() => {
  if (!user.value) return false
  return (
    form.username !== (user.value.username || '') ||
    form.firstName !== (user.value.firstName || '') ||
    form.lastName !== (user.value.lastName || '') ||
    form.email !== (user.value.email || '') ||
    form.phone !== (user.value.phone || '') ||
    form.bio !== (user.value.bio || '')
  )
})

// Initialize form with user data
const initializeForm = () => {
  if (user.value) {
    form.username = user.value.username || ''
    form.firstName = user.value.firstName || ''
    form.lastName = user.value.lastName || ''
    form.email = user.value.email || ''
    form.phone = user.value.phone || ''
    form.bio = user.value.bio || ''
  }
}

// Reset form to original values
const resetForm = () => {
  initializeForm()
  error.value = ''
  successMessage.value = ''
}

// Update profile
const updateProfile = async () => {
  if (!hasChanges.value) {
    successMessage.value = 'No changes to save'
    return
  }

  isLoading.value = true
  error.value = ''
  successMessage.value = ''

  try {
    const response = await $fetch('/api/auth/update-profile', {
      method: 'POST',
      body: {
        username: form.username,
        firstName: form.firstName,
        lastName: form.lastName,
        email: form.email,
        phone: form.phone,
        bio: form.bio
      }
    })

    if (response.success) {
      successMessage.value = 'Profile updated successfully!'
      // Update user data in auth state
      if (user.value) {
        Object.assign(user.value, response.data.user)
      }
    } else {
      error.value = response.error || 'Failed to update profile'
    }
  } catch (e) {
    console.error('Profile update error:', e)
    error.value = e.response?._data?.error || e.message || 'Failed to update profile'
  } finally {
    isLoading.value = false
  }
}

// Initialize form when user data is available
onMounted(() => {
  if (user.value) {
    initializeForm()
  }
})

// Watch for user changes
watch(user, (newUser) => {
  if (newUser) {
    initializeForm()
  }
}, { immediate: true })
</script>
