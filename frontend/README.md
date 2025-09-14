# 🚀 Full-Stack Authentication System

A modern, complete authentication system built with **Nuxt.js 3** frontend and **Next.js** backend, featuring beautiful UI, profile images, and comprehensive security features.

![Nuxt.js](https://img.shields.io/badge/Nuxt.js-3.x-00DC82?style=for-the-badge&logo=nuxt.js)
![Vue.js](https://img.shields.io/badge/Vue.js-3.x-4FC08D?style=for-the-badge&logo=vue.js)
![TypeScript](https://img.shields.io/badge/TypeScript-5.x-3178C6?style=for-the-badge&logo=typescript)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-3.x-06B6D4?style=for-the-badge&logo=tailwindcss)

## ✨ Features

### 🔐 Authentication
- **Email/Password Authentication** - Secure login and registration
- **OAuth Integration** - Google and GitHub OAuth support
- **Email Verification** - Secure email verification system
- **Password Reset** - Token-based password reset with expiration
- **Session Management** - Secure session handling with cookies

### 👤 User Management
- **Profile Images** - Upload and manage profile pictures
- **User Roles** - Role-based access control (USER/ADMIN)
- **User Dashboard** - Comprehensive user dashboard
- **Profile Management** - Update user information

### 🎨 Modern UI/UX
- **Responsive Design** - Works perfectly on all devices
- **Beautiful Interface** - Modern, clean design with Tailwind CSS
- **Loading States** - Smooth loading indicators
- **Error Handling** - Comprehensive error messages and feedback
- **Dark Mode Ready** - Easy to extend with dark mode

### 🛠️ Technical Features
- **TypeScript** - Full type safety throughout the application
- **API Integration** - Complete REST API with Nuxt.js server
- **Middleware** - Route protection and authentication middleware
- **Composables** - Reusable Vue 3 composition API functions
- **Hot Reload** - Fast development with Vite

## 🏗️ Tech Stack

### Frontend
- **Nuxt.js 3** - The intuitive Vue framework
- **Vue.js 3** - Progressive JavaScript framework
- **TypeScript** - Type-safe JavaScript
- **Tailwind CSS** - Utility-first CSS framework
- **Pinia** - Vue state management

### Backend
- **Nuxt.js Server API** - Built-in server-side API
- **H3** - Lightweight HTTP framework
- **Cookie Management** - Secure session handling

### Development
- **Vite** - Fast build tool and dev server
- **ESLint** - Code linting and formatting
- **Hot Module Replacement** - Instant updates during development

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ 
- npm or yarn

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/login-system-nuxtjs.git
   cd login-system-nuxtjs
   ```

2. **Install dependencies**
```bash
npm install
   ```

3. **Set up environment variables**
```bash
   cp .env.example .env.local
   ```
   
   Edit `.env.local` with your configuration:
   ```env
   # NextAuth Configuration
   NEXTAUTH_URL=http://localhost:3000
   NEXTAUTH_SECRET=your-secret-key-here
   
   # Database Configuration
   DATABASE_URL="your-database-url"
   
   # OAuth Providers (optional)
   AUTH_GOOGLE_ID=your-google-client-id
   AUTH_GOOGLE_SECRET=your-google-client-secret
   AUTH_GITHUB_ID=your-github-client-id
   AUTH_GITHUB_SECRET=your-github-client-secret
   ```

4. **Start the development server**
```bash
   npm run dev
   ```

5. **Open your browser**
   Navigate to [http://localhost:3000](http://localhost:3000)

## 📁 Project Structure

```
login-system-nuxtjs/
├── app/                    # App directory (Nuxt 3)
│   ├── assets/            # Static assets
│   │   └── css/          # Global styles
│   ├── layouts/          # Layout components
│   │   ├── auth.vue      # Authentication layout
│   │   └── default.vue   # Default layout
│   ├── pages/            # Page components
│   │   ├── index.vue     # Landing page
│   │   ├── login.vue     # Login page
│   │   ├── register.vue  # Registration page
│   │   ├── dashboard.vue # User dashboard
│   │   └── api-test.vue  # API testing page
│   └── app.vue           # Root component
├── components/           # Reusable components
│   └── ProfileImage.vue  # Profile image component
├── composables/          # Vue composables
│   └── useAuth.ts        # Authentication composable
├── middleware/           # Route middleware
│   ├── auth.ts          # Authentication middleware
│   └── guest.ts         # Guest middleware
├── server/              # Server-side API
│   └── api/            # API endpoints
│       └── auth/       # Authentication endpoints
├── nuxt.config.ts       # Nuxt configuration
├── tailwind.config.js   # Tailwind configuration
└── package.json         # Dependencies
```

## 🔧 API Endpoints

### Authentication
- `GET /api/auth/session` - Get current user session
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/logout` - User logout
- `POST /api/auth/upload-profile-image` - Upload profile image

### Health Check
- `GET /api/health` - API health check

## 🎯 Usage

### Demo Credentials
For testing purposes, use these demo credentials:
- **Email**: `demo@example.com`
- **Password**: `password`

### Key Features

1. **Landing Page** (`/`)
   - Beautiful hero section
   - Feature showcase
   - Authentication status display

2. **Authentication** (`/login`, `/register`)
   - Secure login/registration forms
   - Form validation
   - OAuth provider buttons
   - Error handling

3. **Dashboard** (`/dashboard`)
   - Protected route (requires authentication)
   - User profile information
   - Profile image management
   - Quick actions

4. **API Testing** (`/api-test`)
   - Interactive API endpoint testing
   - Response visualization
   - Error debugging

## 🛡️ Security Features

- **Route Protection** - Middleware-based route protection
- **Session Management** - Secure cookie-based sessions
- **Input Validation** - Client and server-side validation
- **Error Handling** - Secure error messages
- **CSRF Protection** - Built-in CSRF protection

## 🎨 Customization

### Styling
The project uses Tailwind CSS for styling. You can customize the design by:
- Modifying `tailwind.config.js`
- Updating CSS classes in components
- Adding custom CSS in `app/assets/css/main.css`

### Components
All components are modular and reusable:
- `ProfileImage.vue` - Profile image with upload functionality
- Layout components in `app/layouts/`
- Page components in `app/pages/`

### API
Extend the API by adding new endpoints in `server/api/`:
- Follow the existing pattern
- Use TypeScript for type safety
- Include proper error handling

## 🚀 Deployment

### Vercel (Recommended)
1. Push your code to GitHub
2. Connect your repository to Vercel
3. Set environment variables in Vercel dashboard
4. Deploy automatically

### Other Platforms
The project can be deployed to any platform that supports Node.js:
- Netlify
- Railway
- DigitalOcean App Platform
- AWS Amplify

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Nuxt.js](https://nuxt.com/) - The intuitive Vue framework
- [Vue.js](https://vuejs.org/) - The progressive JavaScript framework
- [Tailwind CSS](https://tailwindcss.com/) - A utility-first CSS framework
- [DiceBear](https://dicebear.com/) - Avatar library for profile images

## 🌐 **Live Applications**

Your full-stack authentication system is now live and deployed:

- **Frontend (Nuxt.js)**: https://nuxtjs-frontend-8n17qov81-ay-xperts-projects.vercel.app
- **Backend (Next.js)**: https://nextjs-backend-hfyv8dqya-ay-xperts-projects.vercel.app
- **GitHub Repository**: https://github.com/anshulyadav32/login-system-nuxtjs

## 📞 Support

If you have any questions or need help, please:
- Open an issue on GitHub
- Check the documentation
- Review the code examples

---

**Built with ❤️ using Nuxt.js 3 and Vue.js 3**