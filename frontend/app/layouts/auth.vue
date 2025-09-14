<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
      <div class="text-center">
        <NuxtLink to="/" class="text-3xl font-bold text-gray-900">
          🚀 Auth System
        </NuxtLink>
        <h2 class="mt-6 text-center text-xl font-medium text-gray-900">
          <slot name="title"></slot>
        </h2>
      </div>
      <div class="mt-8 bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
        <slot />
      </div>
    </div>
  </div>
</template>