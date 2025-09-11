// Auth middleware - protects routes that require authentication
export default defineNuxtRouteMiddleware((to, from) => {
  const { isAuthenticated, isLoading } = useAuth()

  // Wait for auth check to complete
  if (isLoading.value) {
    return
  }

  // Redirect to login if not authenticated
  if (!isAuthenticated.value) {
    return navigateTo('/login')
  }
})
