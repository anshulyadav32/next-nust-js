<template>
  <div class="profile-image-container">
    <!-- Profile Image Display -->
    <div class="relative inline-block">
      <div 
        class="w-20 h-20 rounded-full overflow-hidden border-4 border-white shadow-lg bg-gray-200 flex items-center justify-center"
        :class="{ 'cursor-pointer': editable }"
        @click="editable ? openFileDialog() : null"
      >
        <img 
          v-if="user?.profileImage" 
          :src="user.profileImage" 
          :alt="user.name || 'Profile'"
          class="w-full h-full object-cover"
        />
        <div v-else class="w-full h-full bg-indigo-500 flex items-center justify-center">
          <span class="text-white text-2xl font-bold">
            {{ getInitials(user?.name || user?.email || 'U') }}
          </span>
        </div>
      </div>
      
      <!-- Edit Icon -->
      <div 
        v-if="editable" 
        class="absolute -bottom-1 -right-1 w-6 h-6 bg-indigo-600 rounded-full flex items-center justify-center cursor-pointer hover:bg-indigo-700 transition-colors"
        @click="openFileDialog"
      >
        <svg class="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
        </svg>
      </div>
    </div>

    <!-- Hidden File Input -->
    <input
      ref="fileInput"
      type="file"
      accept="image/*"
      class="hidden"
      @change="handleFileSelect"
    />

    <!-- Upload Progress -->
    <div v-if="uploading" class="mt-2">
      <div class="w-full bg-gray-200 rounded-full h-2">
        <div class="bg-indigo-600 h-2 rounded-full transition-all duration-300" :style="{ width: uploadProgress + '%' }"></div>
      </div>
      <p class="text-xs text-gray-600 mt-1">Uploading... {{ uploadProgress }}%</p>
    </div>

    <!-- Error Message -->
    <div v-if="error" class="mt-2 text-red-600 text-sm">
      {{ error }}
    </div>

    <!-- Success Message -->
    <div v-if="successMessage" class="mt-2 text-green-600 text-sm">
      {{ successMessage }}
    </div>
  </div>
</template>

<script setup lang="ts">
interface User {
  id: string
  email: string
  name?: string
  profileImage?: string
}

interface Props {
  user: User | null
  editable?: boolean
  size?: 'sm' | 'md' | 'lg'
}

const props = withDefaults(defineProps<Props>(), {
  editable: false,
  size: 'md'
})

const emit = defineEmits<{
  'image-uploaded': [user: User]
}>()

const fileInput = ref<HTMLInputElement>()
const uploading = ref(false)
const uploadProgress = ref(0)
const error = ref('')
const successMessage = ref('')

// Get user initials for fallback avatar
const getInitials = (name: string) => {
  return name
    .split(' ')
    .map(word => word.charAt(0))
    .join('')
    .toUpperCase()
    .slice(0, 2)
}

// Open file dialog
const openFileDialog = () => {
  fileInput.value?.click()
}

// Handle file selection
const handleFileSelect = async (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return

  // Validate file type
  if (!file.type.startsWith('image/')) {
    error.value = 'Please select an image file'
    return
  }

  // Validate file size (max 5MB)
  if (file.size > 5 * 1024 * 1024) {
    error.value = 'Image size must be less than 5MB'
    return
  }

  await uploadImage(file)
}

// Upload image
const uploadImage = async (file: File) => {
  uploading.value = true
  uploadProgress.value = 0
  error.value = ''
  successMessage.value = ''

  try {
    // Convert file to base64 for demo
    const base64 = await fileToBase64(file)
    
    // Simulate upload progress
    const progressInterval = setInterval(() => {
      uploadProgress.value += 10
      if (uploadProgress.value >= 90) {
        clearInterval(progressInterval)
      }
    }, 100)

    // Call upload API
    const response = await $fetch('/api/auth/upload-profile-image', {
      method: 'POST',
      body: {
        imageData: base64,
        userId: props.user?.id
      }
    })

    clearInterval(progressInterval)
    uploadProgress.value = 100

    if (response.success && response.data?.user) {
      successMessage.value = 'Profile image updated successfully!'
      emit('image-uploaded', response.data.user)
      
      // Clear success message after 3 seconds
      setTimeout(() => {
        successMessage.value = ''
      }, 3000)
    } else {
      error.value = response.error || 'Upload failed'
    }
  } catch (err: any) {
    error.value = err.message || 'Upload failed'
  } finally {
    uploading.value = false
    uploadProgress.value = 0
  }
}

// Convert file to base64
const fileToBase64 = (file: File): Promise<string> => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.readAsDataURL(file)
    reader.onload = () => resolve(reader.result as string)
    reader.onerror = error => reject(error)
  })
}
</script>

<style scoped>
.profile-image-container {
  @apply flex flex-col items-center;
}
</style>
