// Logout endpoint
export default defineEventHandler(async (event) => {
  try {
    // In a real app, you would invalidate the session/token
    // For demo purposes, we'll just clear the cookie
    deleteCookie(event, 'auth-token')

    return {
      success: true,
      message: 'Logout successful'
    }
  } catch (error) {
    return {
      success: false,
      error: 'Logout failed'
    }
  }
})
