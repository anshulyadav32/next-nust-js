// Shared TypeScript types for authentication system

export interface User {
  id: string
  email: string
  name?: string
  emailVerified?: Date
  image?: string
  role: 'USER' | 'ADMIN'
  createdAt: Date
  updatedAt: Date
}

export interface Session {
  user: User
  expires: Date
}

export interface AuthCredentials {
  email: string
  password: string
}

export interface RegisterData extends AuthCredentials {
  name?: string
}

export interface LoginResponse {
  success: boolean
  message?: string
  user?: User
}

export interface ApiResponse<T = any> {
  success: boolean
  data?: T
  error?: string
  message?: string
}

export interface PasswordResetRequest {
  email: string
}

export interface PasswordResetSubmit {
  token: string
  password: string
}

export interface EmailVerification {
  token: string
}

export interface AuthState {
  user: User | null
  isAuthenticated: boolean
  isLoading: boolean
  error: string | null
}

// API Endpoints
export const API_ENDPOINTS = {
  // Authentication
  REGISTER: '/api/auth/register',
  LOGIN: '/api/auth/signin', 
  LOGOUT: '/api/auth/signout',
  SESSION: '/api/auth/session',
  
  // Email verification
  SEND_VERIFICATION: '/api/auth/send-verification',
  VERIFY_EMAIL: '/api/auth/verify-email',
  
  // Password reset
  FORGOT_PASSWORD: '/api/auth/forgot-password',
  RESET_PASSWORD: '/api/auth/reset-password',
  
  // Admin
  ADMIN_USERS: '/api/admin/users',
  ADMIN_USER_ROLE: '/api/admin/users',
} as const

// HTTP Status Codes
export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  INTERNAL_SERVER_ERROR: 500,
} as const

// Error Messages
export const ERROR_MESSAGES = {
  INVALID_CREDENTIALS: 'Invalid email or password',
  USER_EXISTS: 'User with this email already exists',
  USER_NOT_FOUND: 'User not found',
  INVALID_TOKEN: 'Invalid or expired token',
  UNAUTHORIZED: 'You must be logged in to access this resource',
  FORBIDDEN: 'You do not have permission to access this resource',
  VALIDATION_ERROR: 'Please check your input and try again',
  NETWORK_ERROR: 'Network error. Please try again.',
  UNKNOWN_ERROR: 'Something went wrong. Please try again.',
} as const

// Success Messages
export const SUCCESS_MESSAGES = {
  REGISTRATION_SUCCESS: 'Account created successfully! Please check your email for verification.',
  LOGIN_SUCCESS: 'Welcome back!',
  LOGOUT_SUCCESS: 'You have been logged out successfully',
  EMAIL_VERIFIED: 'Email verified successfully!',
  VERIFICATION_SENT: 'Verification email sent! Please check your inbox.',
  PASSWORD_RESET_SENT: 'Password reset link sent to your email',
  PASSWORD_RESET_SUCCESS: 'Password reset successfully!',
} as const
