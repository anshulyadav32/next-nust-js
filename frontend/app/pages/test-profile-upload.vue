<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Profile Upload Test Page</h1>
        <p class="mt-2 text-gray-600">Frontend interface for testing profile picture upload functionality</p>
      </div>

      <!-- Upload Section -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <!-- Upload Form -->
        <div class="bg-white rounded-lg shadow">
          <div class="px-6 py-4 border-b border-gray-200">
            <h2 class="text-lg font-medium text-gray-900">Upload Profile Picture</h2>
          </div>
          <div class="p-6">
            <!-- File Upload Area -->
            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Select Image File
              </label>
              <div 
                @drop="handleDrop"
                @dragover.prevent
                @dragenter.prevent
                class="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center hover:border-gray-400 transition-colors"
              >
                <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
                  <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                </svg>
                <div class="mt-4">
                  <label for="file-upload" class="cursor-pointer">
                    <span class="mt-2 block text-sm font-medium text-gray-900">
                      Drop files here or click to upload
                    </span>
                    <input 
                      id="file-upload" 
                      name="file-upload" 
                      type="file" 
                      class="sr-only" 
                      accept="image/*"
                      @change="handleFileSelect"
                    >
                  </label>
                  <p class="mt-2 text-xs text-gray-500">
                    PNG, JPG, GIF up to 10MB
                  </p>
                </div>
              </div>
            </div>

            <!-- Selected File Info -->
            <div v-if="selectedFile" class="mb-6 p-4 bg-gray-50 rounded-lg">
              <h3 class="text-sm font-medium text-gray-900 mb-2">Selected File:</h3>
              <div class="text-sm text-gray-600">
                <p><strong>Name:</strong> {{ selectedFile.name }}</p>
                <p><strong>Size:</strong> {{ formatFileSize(selectedFile.size) }}</p>
                <p><strong>Type:</strong> {{ selectedFile.type }}</p>
              </div>
            </div>

            <!-- Preview -->
            <div v-if="previewUrl" class="mb-6">
              <h3 class="text-sm font-medium text-gray-900 mb-2">Preview:</h3>
              <div class="flex justify-center">
                <img 
                  :src="previewUrl" 
                  alt="Preview" 
                  class="h-32 w-32 object-cover rounded-full border-4 border-gray-200"
                >
              </div>
            </div>

            <!-- Upload Button -->
            <div class="flex space-x-4">
              <button 
                @click="uploadFile" 
                :disabled="!selectedFile || uploading"
                class="btn-primary flex-1"
              >
                <svg v-if="uploading" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                {{ uploading ? 'Uploading...' : 'Upload Image' }}
              </button>
              <button 
                @click="clearSelection" 
                :disabled="uploading"
                class="btn-secondary"
              >
                Clear
              </button>
            </div>
          </div>
        </div>

        <!-- Results Section -->
        <div class="bg-white rounded-lg shadow">
          <div class="px-6 py-4 border-b border-gray-200">
            <h2 class="text-lg font-medium text-gray-900">Upload Results</h2>
          </div>
          <div class="p-6">
            <!-- Success Result -->
            <div v-if="uploadResult && uploadResult.success" class="mb-4">
              <div class="flex items-center mb-2">
                <svg class="h-5 w-5 text-green-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                </svg>
                <span class="text-green-800 font-medium">Upload Successful!</span>
              </div>
              <div class="bg-green-50 border border-green-200 rounded-lg p-4">
                <pre class="text-sm text-green-800 whitespace-pre-wrap">{{ JSON.stringify(uploadResult.data, null, 2) }}</pre>
              </div>
            </div>

            <!-- Error Result -->
            <div v-else-if="uploadResult && !uploadResult.success" class="mb-4">
              <div class="flex items-center mb-2">
                <svg class="h-5 w-5 text-red-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
                <span class="text-red-800 font-medium">Upload Failed</span>
              </div>
              <div class="bg-red-50 border border-red-200 rounded-lg p-4">
                <p class="text-sm text-red-800 mb-2"><strong>Error:</strong> {{ uploadResult.error }}</p>
                <pre class="text-sm text-red-700 whitespace-pre-wrap">{{ JSON.stringify(uploadResult.data, null, 2) }}</pre>
              </div>
            </div>

            <!-- No Results -->
            <div v-else class="text-gray-500 text-center py-8">
              <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
              </svg>
              <p class="mt-2">No upload results yet</p>
              <p class="text-sm">Select and upload an image to see results</p>
            </div>
          </div>
        </div>
      </div>

      <!-- API Information -->
      <div class="mt-8 bg-white rounded-lg shadow">
        <div class="px-6 py-4 border-b border-gray-200">
          <h2 class="text-lg font-medium text-gray-900">API Information</h2>
        </div>
        <div class="p-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Endpoint</h3>
              <p class="mt-1 text-sm text-gray-900 font-mono">POST {{ backendUrl }}/api/profile/picture</p>
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Content Type</h3>
              <p class="mt-1 text-sm text-gray-900">multipart/form-data</p>
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Max File Size</h3>
              <p class="mt-1 text-sm text-gray-900">10MB</p>
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Supported Formats</h3>
              <p class="mt-1 text-sm text-gray-900">JPEG, PNG, GIF, WebP</p>
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Authentication</h3>
              <p class="mt-1 text-sm text-gray-900">Required (Cookie-based)</p>
            </div>
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Response Format</h3>
              <p class="mt-1 text-sm text-gray-900">JSON</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Test Instructions -->
      <div class="mt-8 bg-blue-50 border border-blue-200 rounded-lg p-6">
        <div class="flex">
          <svg class="h-5 w-5 text-blue-400 mt-0.5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <div>
            <h3 class="text-sm font-medium text-blue-800">Testing Instructions</h3>
            <div class="mt-2 text-sm text-blue-700">
              <ol class="list-decimal list-inside space-y-1">
                <li>Make sure the Next.js backend server is running on {{ backendUrl }}</li>
                <li>Ensure you're logged in (authentication required for profile uploads)</li>
                <li>Select an image file (JPEG, PNG, GIF, or WebP format)</li>
                <li>Preview the image and verify file details</li>
                <li>Click "Upload Image" to test the API endpoint</li>
                <li>Check the results section for success/error responses</li>
              </ol>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
interface UploadResult {
  success: boolean
  data: any
  error?: string
}

const config = useRuntimeConfig()
const backendUrl = config.public.apiBase || 'http://localhost:3001'

// Reactive state
const selectedFile = ref<File | null>(null)
const previewUrl = ref<string | null>(null)
const uploading = ref(false)
const uploadResult = ref<UploadResult | null>(null)

// Handle file selection
const handleFileSelect = (event: Event) => {
  const target = event.target as HTMLInputElement
  if (target.files && target.files[0]) {
    setSelectedFile(target.files[0])
  }
}

// Handle drag and drop
const handleDrop = (event: DragEvent) => {
  event.preventDefault()
  if (event.dataTransfer?.files && event.dataTransfer.files[0]) {
    setSelectedFile(event.dataTransfer.files[0])
  }
}

// Set selected file and create preview
const setSelectedFile = (file: File) => {
  // Validate file type
  if (!file.type.startsWith('image/')) {
    alert('Please select an image file')
    return
  }

  // Validate file size (10MB limit)
  if (file.size > 10 * 1024 * 1024) {
    alert('File size must be less than 10MB')
    return
  }

  selectedFile.value = file
  
  // Create preview URL
  if (previewUrl.value) {
    URL.revokeObjectURL(previewUrl.value)
  }
  previewUrl.value = URL.createObjectURL(file)
  
  // Clear previous results
  uploadResult.value = null
}

// Clear selection
const clearSelection = () => {
  selectedFile.value = null
  if (previewUrl.value) {
    URL.revokeObjectURL(previewUrl.value)
    previewUrl.value = null
  }
  uploadResult.value = null
  
  // Clear file input
  const fileInput = document.getElementById('file-upload') as HTMLInputElement
  if (fileInput) {
    fileInput.value = ''
  }
}

// Upload file
const uploadFile = async () => {
  if (!selectedFile.value) return
  
  uploading.value = true
  uploadResult.value = null
  
  try {
    const formData = new FormData()
    formData.append('image', selectedFile.value)
    
    const response = await $fetch(`${backendUrl}/api/profile/picture`, {
      method: 'POST',
      body: formData,
      credentials: 'include' // Include cookies for authentication
    })
    
    uploadResult.value = {
      success: true,
      data: response
    }
  } catch (error: any) {
    uploadResult.value = {
      success: false,
      data: error.data || error.message,
      error: error.message || 'Upload failed'
    }
  } finally {
    uploading.value = false
  }
}

// Format file size
const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 Bytes'
  
  const k = 1024
  const sizes = ['Bytes', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

// Cleanup on unmount
onUnmounted(() => {
  if (previewUrl.value) {
    URL.revokeObjectURL(previewUrl.value)
  }
})
</script>

<style scoped>
.btn-primary {
  @apply bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed;
}

.btn-secondary {
  @apply bg-gray-600 text-white px-4 py-2 rounded-md hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed;
}
</style>