// Login endpoint
export default defineEventHandler(async (event) => {
  try {
    // Handle different content types
    let body
    try {
      body = await readBody(event)
    } catch (error) {
      // If JSON parsing fails, try to get raw body
      const rawBody = await readRawBody(event)
      if (rawBody) {
        body = JSON.parse(rawBody.toString())
      } else {
        throw new Error('No body provided')
      }
    }
    
    console.log('Login request body:', body)
    
    const { email, password } = body

    // Basic validation
    if (!email || !password) {
      return {
        success: false,
        error: 'Email and password are required'
      }
    }

    // Mock authentication - in real app, check against database
    if (email === 'demo@example.com' && password === 'password') {
      const user = {
        id: '1',
        email: 'demo@example.com',
        name: 'Demo User',
        role: 'USER' as const,
        emailVerified: true,
        profileImage: 'https://api.dicebear.com/7.x/avataaars/svg?seed=demo&backgroundColor=b6e3f4',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      }

      // In a real app, you would set cookies or JWT tokens here
      setCookie(event, 'auth-token', 'mock-jwt-token', {
        httpOnly: true,
        secure: false, // Set to false for development
        sameSite: 'lax',
        maxAge: 60 * 60 * 24 * 7 // 7 days
      })

      return {
        success: true,
        data: { user },
        message: 'Login successful'
      }
    } else {
      return {
        success: false,
        error: 'Invalid credentials'
      }
    }
  } catch (error) {
    console.error('Login error:', error)
    return {
      success: false,
      error: 'Login failed'
    }
  }
})
