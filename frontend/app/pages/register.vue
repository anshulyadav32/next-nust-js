<template>
  <div class="auth-container">
    <div class="auth-card">
      <div class="auth-header">
        <h2 class="auth-title">Create your account</h2>
        <p class="auth-subtitle">
          Already have an account?
          <NuxtLink to="/login" class="font-medium text-indigo-600 hover:text-indigo-500">
            Sign in here
          </NuxtLink>
        </p>
      </div>

      <form @submit.prevent="handleSubmit" class="mt-8 space-y-6">
        <!-- Name Field -->
        <div class="form-group">
          <label for="name" class="form-label">Full Name</label>
          <input
            id="name"
            v-model="form.name"
            type="text"
            class="form-input"
            :class="{ 'border-red-300': errors.name }"
            placeholder="Enter your full name"
          />
          <p v-if="errors.name" class="error-message">{{ errors.name }}</p>
        </div>

        <!-- Email Field -->
        <div class="form-group">
          <label for="email" class="form-label">Email address</label>
          <input
            id="email"
            v-model="form.email"
            type="email"
            required
            class="form-input"
            :class="{ 'border-red-300': errors.email }"
            placeholder="Enter your email"
          />
          <p v-if="errors.email" class="error-message">{{ errors.email }}</p>
        </div>

        <!-- Password Field -->
        <div class="form-group">
          <label for="password" class="form-label">Password</label>
          <input
            id="password"
            v-model="form.password"
            type="password"
            required
            class="form-input"
            :class="{ 'border-red-300': errors.password }"
            placeholder="Choose a strong password"
          />
          <p v-if="errors.password" class="error-message">{{ errors.password }}</p>
        </div>

        <!-- Confirm Password Field -->
        <div class="form-group">
          <label for="confirmPassword" class="form-label">Confirm Password</label>
          <input
            id="confirmPassword"
            v-model="form.confirmPassword"
            type="password"
            required
            class="form-input"
            :class="{ 'border-red-300': errors.confirmPassword }"
            placeholder="Confirm your password"
          />
          <p v-if="errors.confirmPassword" class="error-message">{{ errors.confirmPassword }}</p>
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
            {{ isLoading ? 'Creating account...' : 'Create account' }}
          </button>
        </div>

        <!-- OAuth Buttons -->
        <div class="mt-6">
          <div class="relative">
            <div class="absolute inset-0 flex items-center">
              <div class="w-full border-t border-gray-300" />
            </div>
            <div class="relative flex justify-center text-sm">
              <span class="px-2 bg-white text-gray-500">Or sign up with</span>
            </div>
          </div>

          <div class="mt-6 grid grid-cols-2 gap-3">
            <button
              type="button"
              @click="signUpWithProvider('google')"
              class="btn-google"
            >
              <svg class="w-5 h-5 mr-2" viewBox="0 0 24 24">
                <path fill="currentColor" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                <path fill="currentColor" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                <path fill="currentColor" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                <path fill="currentColor" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
              </svg>
              Google
            </button>

            <button
              type="button"
              @click="signUpWithProvider('github')"
              class="btn-github"
            >
              <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 24 24">
                <path d="M12 0C5.374 0 0 5.373 0 12 0 17.302 3.438 21.8 8.207 23.387c.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z"/>
              </svg>
              GitHub
            </button>
          </div>
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

const { register, isLoading, error } = useAuth()
const router = useRouter()

// Form data
const form = ref({
  name: '',
  email: '',
  password: '',
  confirmPassword: ''
})

// Form validation errors
const errors = ref({
  name: '',
  email: '',
  password: '',
  confirmPassword: ''
})

const successMessage = ref('')

// Validate form
const validateForm = () => {
  errors.value = { name: '', email: '', password: '', confirmPassword: '' }
  let isValid = true

  if (!form.value.email) {
    errors.value.email = 'Email is required'
    isValid = false
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.value.email)) {
    errors.value.email = 'Please enter a valid email address'
    isValid = false
  }

  if (!form.value.password) {
    errors.value.password = 'Password is required'
    isValid = false
  } else if (form.value.password.length < 8) {
    errors.value.password = 'Password must be at least 8 characters'
    isValid = false
  }

  if (!form.value.confirmPassword) {
    errors.value.confirmPassword = 'Please confirm your password'
    isValid = false
  } else if (form.value.password !== form.value.confirmPassword) {
    errors.value.confirmPassword = 'Passwords do not match'
    isValid = false
  }

  return isValid
}

// Handle form submission
const handleSubmit = async () => {
  if (!validateForm()) return

  const result = await register({
    name: form.value.name || undefined,
    email: form.value.email,
    password: form.value.password
  })

  if (result.success) {
    successMessage.value = result.message || 'Account created successfully! Please check your email for verification.'
    // Redirect to login after success
    setTimeout(() => {
      router.push('/login')
    }, 2000)
  }
}

// Handle OAuth sign up
const signUpWithProvider = async (provider: string) => {
  const config = useRuntimeConfig()
  // Redirect to NextAuth.js OAuth endpoint
  window.location.href = `${config.public.apiBase}/api/auth/signin/${provider}?callbackUrl=${window.location.origin}/dashboard`
}

// SEO
useSeoMeta({
  title: 'Sign Up - Full Stack Auth',
  description: 'Create a new account to get started with our full-stack authentication system.'
})
</script>
