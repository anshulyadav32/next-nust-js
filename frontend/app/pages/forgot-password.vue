<template>
  <div class="auth-container">
    <div class="auth-card fade-in">
      <div class="auth-header">
        <div class="flex justify-center mb-6">
          <div class="w-16 h-16 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-full flex items-center justify-center">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
            </svg>
          </div>
        </div>
        <h2 class="auth-title">Forgot your password?</h2>
        <p class="auth-subtitle">
          No worries! Enter your email address and we'll send you a link to reset your password.
        </p>
      </div>

      <form @submit.prevent="handleSubmit" class="mt-8 space-y-6">
        <!-- Email Field -->
        <div class="form-group">
          <label for="email" class="form-label">
            <svg class="w-4 h-4 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207" />
            </svg>
            Email address
          </label>
          <input
            id="email"
            v-model="form.email"
            type="email"
            required
            class="form-input"
            :class="{ 'error': errors.email }"
            placeholder="Enter your email address"
          />
          <p v-if="errors.email" class="error-message">{{ errors.email }}</p>
        </div>

        <!-- Error Message -->
        <div v-if="error" class="error-message text-center">
          {{ error }}
        </div>

        <!-- Success Message -->
        <div v-if="successMessage" class="success-message text-center">
          {{ successMessage }}
        </div>

        <!-- Submit Button -->
        <div>
          <button
            type="submit"
            :disabled="isLoading"
            class="btn-primary"
          >
            <span v-if="isLoading" class="loading-spinner mr-2"></span>
            {{ isLoading ? 'Sending...' : 'Send reset link' }}
          </button>
        </div>

        <!-- Back to Login -->
        <div class="text-center">
          <NuxtLink to="/login" class="text-sm font-medium text-indigo-600 hover:text-indigo-500 transition-colors">
            ← Back to sign in
          </NuxtLink>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'auth',
  middleware: 'guest'
})

const { forgotPassword } = useAuth()

// Form data
const form = ref({
  email: ''
})

// Form validation errors
const errors = ref({
  email: ''
})

const isLoading = ref(false)
const error = ref('')
const successMessage = ref('')

// Validate form
const validateForm = () => {
  errors.value = { email: '' }
  let isValid = true

  if (!form.value.email) {
    errors.value.email = 'Email is required'
    isValid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.value.email)) {
    errors.value.email = 'Please enter a valid email address'
    isValid = false
  }

  return isValid
}

// Handle form submission
const handleSubmit = async () => {
  if (!validateForm()) return

  isLoading.value = true
  error.value = ''
  successMessage.value = ''

  try {
    const result = await forgotPassword(form.value.email)
    
    if (result.success) {
      successMessage.value = 'Password reset link sent! Please check your email.'
      form.value.email = ''
    } else {
      error.value = result.error || 'Failed to send reset link'
    }
  } catch (err: any) {
    error.value = err.message || 'An error occurred'
  } finally {
    isLoading.value = false
  }
}

// SEO
useSeoMeta({
  title: 'Forgot Password - Full Stack Auth',
  description: 'Reset your password by entering your email address.'
})
</script>
