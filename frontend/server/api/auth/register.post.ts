// Register endpoint
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
    
    console.log('Register request body:', body)
    
    const { name, email, password } = body

    // Basic validation
    if (!email || !password) {
      return {
        success: false,
        error: 'Email and password are required'
      }
    }

    if (password.length < 8) {
      return {
        success: false,
        error: 'Password must be at least 8 characters long'
      }
    }

    // Mock user creation - in real app, save to database
    const user = {
      id: Date.now().toString(),
      email,
      name: name || email.split('@')[0],
      role: 'USER' as const,
      emailVerified: false,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    }

    return {
      success: true,
      data: { user },
      message: 'Registration successful! Please check your email for verification.'
    }
  } catch (error) {
    console.error('Register error:', error)
    return {
      success: false,
      error: 'Registration failed'
    }
  }
})
