// Guest middleware - redirects authenticated users away from auth pages
export default defineNuxtRouteMiddleware((to, from) => {
  const { isAuthenticated, isLoading } = useAuth()

  // Wait for auth check to complete
  if (isLoading.value) {
    return
  }

  // Redirect to dashboard if already authenticated
  if (isAuthenticated.value) {
    return navigateTo('/dashboard')
  }
})
