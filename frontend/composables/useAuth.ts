// Authentication composable for Nuxt.js frontend
import type { 
  AuthState, 
  User, 
  LoginResponse, 
  RegisterData, 
  AuthCredentials,
  PasswordResetRequest,
  PasswordResetSubmit,
  ApiResponse 
} from '~/../../shared/types'

export const useAuth = () => {
  const config = useRuntimeConfig()
  const apiBase = config.public.apiBase

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
      const response = await apiCall<{ user: User }>('/api/auth/session')
      
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
      const response = await apiCall<{ user: User }>('/api/auth/register', {
        method: 'POST',
        body: JSON.stringify(userData)
      })

      if (response.success) {
        return {
          success: true,
          message: 'Registration successful! Please check your email for verification.',
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
      // Use NextAuth.js signin endpoint
      const response = await $fetch(`${apiBase}/api/auth/signin`, {
        method: 'POST',
        credentials: 'include',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          email: credentials.email,
          password: credentials.password,
          callbackUrl: window.location.origin
        })
      })

      // Check if login was successful by getting session
      await checkAuth()
      
      if (authState.value.isAuthenticated) {
        return {
          success: true,
          message: 'Login successful!',
          user: authState.value.user!
        }
      } else {
        return {
          success: false,
          message: 'Invalid credentials'
        }
      }
    } catch (error: any) {
      const errorMessage = error.data?.message || error.message || 'Login failed'
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
      await $fetch(`${apiBase}/api/auth/signout`, {
        method: 'POST',
        credentials: 'include'
      })
      
      authState.value.user = null
      authState.value.isAuthenticated = false
      authState.value.error = null
      
      // Redirect to home page
      await navigateTo('/')
    } catch (error) {
      console.error('Logout error:', error)
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
