// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  
  // Modules
  modules: [
    '@nuxtjs/tailwindcss',
    '@pinia/nuxt'
  ],
  
  // Runtime Config
  runtimeConfig: {
    public: {
      apiBase: 'http://localhost:3001'
    }
  },
  
  // Specify app directory structure
  srcDir: './',
  dir: {
    pages: 'pages',
    layouts: 'layouts',
    middleware: 'middleware',
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
