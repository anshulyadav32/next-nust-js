// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  
  // Modules
  modules: [
    '@nuxtjs/tailwindcss',
    '@pinia/nuxt'
  ],
  
  // Global CSS
  css: [
    '~/app/assets/css/main.css'
  ],
  
  // Runtime Config
  runtimeConfig: {
    public: {
      apiBase: process.env.NODE_ENV === 'production' ? 'https://nextjs-backend-hfyv8dqya-ay-xperts-projects.vercel.app' : 'http://localhost:3000'
    }
  },
  
  // Specify app directory structure
  srcDir: './',
  dir: {
    pages: 'app/pages',
    layouts: 'app/layouts',
  },
  
  // Server options handled via .env file
  // NITRO_PORT=3002
  // NITRO_HOST=0.0.0.0
  
  // Server-side rendering
  ssr: true,
  
  // App config
  app: {
    head: {
      title: 'Full-Stack Auth System',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: 'Modern authentication system with Nuxt.js and Next.js' }
      ]
    }
  }
})
