<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>

<script setup>
// Initialize auth on app start
const { checkAuth } = useAuth()

// Check authentication status when app loads
onMounted(async () => {
  await checkAuth()
})
</script>
