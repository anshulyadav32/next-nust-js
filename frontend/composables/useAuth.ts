// Authentication composable for Nuxt.js frontend
// Define types locally since shared types may not be available
interface User {
  id: string
  email: string
  name?: string
  role: 'USER' | 'ADMIN'
  emailVerified: boolean
  profileImage?: string
  createdAt: Date | string
  updatedAt: Date | string
}

interface AuthState {
  user: User | null
  isAuthenticated: boolean
  isLoading: boolean
  error: string | null
}

interface LoginResponse {
  success: boolean
  message?: string
  user?: User
}

interface RegisterData {
  name?: string
  email: string
  password: string
}

interface AuthCredentials {
  email: string
  password: string
}

interface PasswordResetRequest {
  email: string
}

interface PasswordResetSubmit {
  token: string
  password: string
}

interface ApiResponse<T = any> {
  success: boolean
  data?: T
  error?: string
  message?: string
}

export const useAuth = () => {
  const config = useRuntimeConfig()
  // Use backend API endpoints
  const apiBase = config.public.apiBase || '/api'

  // Reactive state
  const authState = ref<AuthState>({
    user: null,
    isAuthenticated: false,
    isLoading: true,
    error: null
  })

  // API helper function
  const apiCall = async <T>(endpoint: string, options: RequestInit = {}): Promise<ApiResponse<T>> => {
    try {
      const response = await $fetch<ApiResponse<T>>(`${apiBase}${endpoint}`, {
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
          ...options.headers
        },
        ...options
      })
      return response
    } catch (error: any) {
      console.error('API Error:', error)
      return {
        success: false,
        error: error.data?.error || error.message || 'Network error'
      }
    }
  }

  // Check authentication status
  const checkAuth = async () => {
    authState.value.isLoading = true
    authState.value.error = null

    try {
      const response = await apiCall<{ user: User }>('/auth/session')
      
      if (response.success && response.data?.user) {
        authState.value.user = response.data.user
        authState.value.isAuthenticated = true
      } else {
        authState.value.user = null
        authState.value.isAuthenticated = false
      }
    } catch (error) {
      authState.value.user = null
      authState.value.isAuthenticated = false
      authState.value.error = 'Failed to check authentication status'
    } finally {
      authState.value.isLoading = false
    }
  }

  // Register new user
  const register = async (userData: RegisterData): Promise<LoginResponse> => {
    authState.value.isLoading = true
    authState.value.error = null

    try {
      const response = await apiCall<{ user: User }>('/auth/register', {
        method: 'POST',
        body: JSON.stringify(userData)
      })

      if (response.success) {
        return {
          success: true,
          message: response.message || 'Registration successful! Please check your email for verification.',
          user: response.data?.user
        }
      } else {
        authState.value.error = response.error || 'Registration failed'
        return {
          success: false,
          message: response.error || 'Registration failed'
        }
      }
    } catch (error: any) {
      const errorMessage = error.message || 'Registration failed'
      authState.value.error = errorMessage
      return {
        success: false,
        message: errorMessage
      }
    } finally {
      authState.value.isLoading = false
    }
  }

  // Login user
  const login = async (credentials: AuthCredentials): Promise<LoginResponse> => {
    authState.value.isLoading = true
    authState.value.error = null

    try {
      const response = await apiCall<{ user: User }>('/auth/login', {
        method: 'POST',
        body: JSON.stringify({
          email: credentials.email,
          password: credentials.password
        })
      })

      if (response.success && response.data?.user) {
        authState.value.user = response.data.user
        authState.value.isAuthenticated = true
        return {
          success: true,
          message: response.message || 'Login successful!',
          user: response.data.user
        }
      } else {
        authState.value.error = response.error || 'Login failed'
        return {
          success: false,
          message: response.error || 'Login failed'
        }
      }
    } catch (error: any) {
      const errorMessage = error.message || 'Login failed'
      authState.value.error = errorMessage
      return {
        success: false,
        message: errorMessage
      }
    } finally {
      authState.value.isLoading = false
    }
  }

  // Logout user
  const logout = async (): Promise<void> => {
    try {
      await apiCall('/auth/logout', {
        method: 'POST'
      })
      
      authState.value.user = null
      authState.value.isAuthenticated = false
      authState.value.error = null
      
      // Redirect to home page
      await navigateTo('/')
    } catch (error) {
      console.error('Logout error:', error)
      // Even if logout fails on server, clear local state
      authState.value.user = null
      authState.value.isAuthenticated = false
      authState.value.error = null
    }
  }

  // Request password reset
  const forgotPassword = async (email: string): Promise<ApiResponse> => {
    try {
      const response = await apiCall('/api/auth/forgot-password', {
        method: 'POST',
        body: JSON.stringify({ email })
      })
      return response
    } catch (error: any) {
      return {
        success: false,
        error: error.message || 'Failed to send password reset email'
      }
    }
  }

  // Reset password with token
  const resetPassword = async (data: PasswordResetSubmit): Promise<ApiResponse> => {
    try {
      const response = await apiCall('/api/auth/reset-password', {
        method: 'POST',
        body: JSON.stringify(data)
      })
      return response
    } catch (error: any) {
      return {
        success: false,
        error: error.message || 'Failed to reset password'
      }
    }
  }

  // Verify email
  const verifyEmail = async (token: string): Promise<ApiResponse> => {
    try {
      const response = await apiCall('/api/auth/verify-email', {
        method: 'POST',
        body: JSON.stringify({ token })
      })
      return response
    } catch (error: any) {
      return {
        success: false,
        error: error.message || 'Email verification failed'
      }
    }
  }

  // Send verification email
  const sendVerification = async (): Promise<ApiResponse> => {
    try {
      const response = await apiCall('/api/auth/send-verification', {
        method: 'POST'
      })
      return response
    } catch (error: any) {
      return {
        success: false,
        error: error.message || 'Failed to send verification email'
      }
    }
  }

  // Initialize auth on app start
  onMounted(async () => {
    await checkAuth()
  })

  return {
    // State
    authState: readonly(authState),
    user: computed(() => authState.value.user),
    isAuthenticated: computed(() => authState.value.isAuthenticated),
    isLoading: computed(() => authState.value.isLoading),
    error: computed(() => authState.value.error),

    // Actions
    checkAuth,
    register,
    login,
    logout,
    forgotPassword,
    resetPassword,
    verifyEmail,
    sendVerification
  }
}
