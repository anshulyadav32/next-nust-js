# 🚀 Full-Stack Authentication System

## 🏗️ Architecture Overview

This project uses a **modern full-stack architecture** combining the best of both Vue.js and React ecosystems:

```
fullstack-auth/
├── 🎨 frontend/          # Nuxt.js (Vue 3) - Client Application
├── 🔧 backend/           # Next.js API - Authentication & Database
├── 📦 shared/            # Shared types, utilities, constants
└── 📚 docs/              # Documentation
```

## 🛠️ Technology Stack

### Frontend (Nuxt.js)
- **Framework:** Nuxt 3 (Vue 3, Vite)
- **Styling:** Tailwind CSS
- **State:** Pinia (Vue store)
- **HTTP:** $fetch (Nuxt's built-in)
- **Auth:** Custom auth composables

### Backend (Next.js API)
- **Framework:** Next.js 15 API Routes
- **Database:** Prisma ORM + PostgreSQL
- **Authentication:** Auth.js v5
- **Email:** Nodemailer
- **Security:** bcrypt, JWT tokens

### Shared
- **Types:** TypeScript interfaces
- **Validation:** Zod schemas
- **Constants:** API endpoints, error codes

## 🌟 Features

### Phase 1: Multi-Provider Authentication
- ✅ Email/Password registration & login
- ✅ Google OAuth integration
- ✅ GitHub OAuth integration
- ✅ Session management

### Phase 2: Email System
- ✅ Email verification for new accounts
- ✅ Password reset with secure tokens
- ✅ Beautiful HTML email templates
- ✅ Development email logging

### Phase 3: Authorization
- ✅ Role-based access control (RBAC)
- ✅ User/Admin role system
- ✅ Protected routes & API endpoints
- ✅ Middleware-based security

### Phase 4: Frontend Integration
- 🔄 Vue.js authentication pages
- 🔄 Responsive UI components
- 🔄 Real-time auth state management
- 🔄 Form validation & error handling

## 🚀 Quick Start

### 1. Backend Setup (Next.js API)
```bash
cd backend
npm install
cp .env.example .env
# Configure your environment variables
npm run dev
```

### 2. Frontend Setup (Nuxt.js)
```bash
cd frontend  
npm install
npm run dev
```

### 3. Database Setup
```bash
cd backend
npx prisma migrate dev
npx prisma generate
```

## 📊 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/signin` - User login
- `GET /api/auth/signout` - User logout
- `GET /api/auth/session` - Get current session

### Email Verification
- `POST /api/auth/send-verification` - Send verification email
- `POST /api/auth/verify-email` - Verify email token

### Password Management
- `POST /api/auth/forgot-password` - Request password reset
- `POST /api/auth/reset-password` - Reset password with token

### Admin
- `GET /api/admin/users` - List all users (admin only)
- `PUT /api/admin/users/:id/role` - Update user role (admin only)

## 🔧 Development

### Frontend (Nuxt.js)
- **Dev Server:** http://localhost:3000
- **Build:** `npm run build`
- **Preview:** `npm run preview`

### Backend (Next.js)
- **API Server:** http://localhost:3001
- **Build:** `npm run build`
- **Database:** `npm run db:studio`

## 🌐 Deployment

### Frontend Options
- **Vercel** (recommended for Nuxt)
- **Netlify**
- **Cloudflare Pages**

### Backend Options
- **Vercel** (recommended for Next.js)
- **Railway**
- **Heroku**

### Database Options
- **Vercel Postgres**
- **PlanetScale**
- **Supabase**

## 🔐 Security Features

- 🛡️ **CSRF Protection:** Built-in token validation
- 🔒 **Password Hashing:** bcrypt with salt rounds
- 🎟️ **JWT Tokens:** Secure session management
- 📧 **Email Verification:** Prevent fake accounts
- 🔑 **Password Reset:** Secure token-based reset
- 👤 **Role-Based Access:** Granular permissions
- 🚪 **Route Protection:** Middleware-based guards

## 🎯 Next Steps

1. **Complete Frontend Integration** - Vue auth components
2. **Add Two-Factor Authentication** - TOTP/SMS
3. **User Management Dashboard** - Admin panel
4. **API Rate Limiting** - Prevent abuse
5. **Audit Logging** - Track user actions
6. **Social Features** - User profiles, preferences

---

## 📝 Deployment Notes

### Azure Container Apps
- See [DEPLOYMENT-SUMMARY.md](./DEPLOYMENT-SUMMARY.md) for deployment details
- Due to regional quota limits, the application is deployed to `West US` region
- See [REGION-CHANGE-NOTE.md](./REGION-CHANGE-NOTE.md) for more information

### Docker Local Development
- Local development uses Docker Compose for easy setup
- Run `./start-docker.sh` or `.\start-docker.ps1` to start the application locally

---

**🎉 Built with ❤️ using Vue.js + Next.js + TypeScript + Prisma**
