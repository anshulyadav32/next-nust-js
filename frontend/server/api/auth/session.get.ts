// Get current user session
export default defineEventHandler(async (event) => {
  try {
    // In a real app, you would check cookies, JWT tokens, etc.
    // For demo purposes, we'll return a mock user
    const mockUser = {
      id: '1',
      email: 'demo@example.com',
      name: 'Demo User',
      role: 'USER' as const,
      emailVerified: true,
      profileImage: 'https://api.dicebear.com/7.x/avataaars/svg?seed=demo&backgroundColor=b6e3f4',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }

    return {
      success: true,
      data: { user: mockUser }
    }
  } catch (error) {
    return {
      success: false,
      error: 'Failed to get session'
    }
  }
})
