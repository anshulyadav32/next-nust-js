<template>
  <div class="min-h-screen bg-gray-50">
    <header class="bg-white shadow">
      <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center">
          <NuxtLink to="/" class="text-2xl font-bold text-gray-900">
            🚀 Auth System
          </NuxtLink>
          
          <div class="flex space-x-4">
            <NuxtLink to="/" class="px-3 py-2 text-gray-700 hover:text-gray-900">
              Home
            </NuxtLink>
            <NuxtLink to="/dashboard" class="px-3 py-2 text-gray-700 hover:text-gray-900">
              Dashboard
            </NuxtLink>
          </div>
        </div>
      </div>
    </header>

    <main>
      <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <slot />
      </div>
    </main>
  </div>
</template>