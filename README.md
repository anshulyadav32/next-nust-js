# 🚀 Full-Stack Authentication System

## 🏗️ Architecture Overview

This project uses a **modern full-stack architecture** combining the best of both Vue.js and React ecosystems:

```
next-nust-js/
├── 🎨 frontend/          # Nuxt.js (Vue 3) - Client Application
├── 🔧 backend/           # Next.js API - Authentication & Database
├── 📦 shared/            # Shared types, utilities, constants
├── 🏗️ infra/            # Infrastructure configuration
├── 📄 .env.*.example     # Environment configuration templates
├── 🐳 docker-compose.yml # Docker setup for containerized deployment
└── 🚀 start-*.js/sh      # Development and deployment scripts
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

### Development Setup

1. **Clone and Install Dependencies**
```bash
git clone https://github.com/anshulyadav32/next-nust-js.git
cd next-nust-js
npm install
cd backend && npm install
cd ../frontend && npm install
```

2. **Environment Configuration**
```bash
# Copy environment templates
cp .env.local.example .env.local
cp .env.production.example .env.production

# Edit the environment files with your actual values
# .env.local - for development
# .env.production - for production deployment
```

3. **Database Setup (Backend)**
```bash
cd backend
npx prisma migrate dev
npx prisma generate
```

4. **Start Development Servers**

**Option A: Using Node.js directly**
```bash
# Terminal 1: Start backend (http://localhost:3001)
cd backend
npm run dev

# Terminal 2: Start frontend (http://localhost:3002)  
cd frontend
npm run dev
```

**Option B: Using the development launcher**
```bash
# Starts both backend and frontend automatically
node start-dev.js
```

**Option C: Using Docker**
```bash
# Start with Docker Compose
./start-docker.sh
# or
docker compose up --build
```

### Production Deployment

1. **Build the Applications**
```bash
# Build backend
cd backend
npm run build

# Build frontend
cd frontend
npm run build
```

2. **Start Production Servers**
```bash
# Start backend (production mode)
cd backend
npm start

# Start frontend (production mode)
cd frontend
npm start
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
- **Dev Server:** http://localhost:3002
- **Build:** `npm run build`
- **Start:** `npm start` (production mode)
- **Preview:** `npm run preview`

### Backend (Next.js)
- **API Server:** http://localhost:3001
- **Build:** `npm run build` 
- **Start:** `npm start` (production mode)
- **Database:** `npx prisma studio`

### Environment Files
- **`.env.local.example`** - Development configuration template
- **`.env.production.example`** - Production configuration template
- Copy these files and remove `.example` extension, then configure with your actual values

### Docker Development
```bash
# Start all services
./start-docker.sh

# Stop all services  
docker compose down

# View logs
docker compose logs -f
```

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

### Docker Deployment
- **Local Development:** Use `./start-docker.sh` for containerized development
- **Production:** Configure `.env.production` and deploy with Docker Compose
- **Ports:** Frontend (3002), Backend (3001)

### Cloud Deployment Options

#### Frontend (Nuxt.js)
- **Vercel** (recommended)
- **Netlify** 
- **Cloudflare Pages**
- **Azure Container Apps**

#### Backend (Next.js)
- **Vercel** (recommended)
- **Railway**
- **Heroku** 
- **Azure Container Apps**

#### Database
- **PostgreSQL:** Vercel Postgres, PlanetScale, Supabase
- **Development:** SQLite (included in backend)

### Environment Setup
1. Copy `.env.local.example` → `.env.local` for development
2. Copy `.env.production.example` → `.env.production` for production
3. Configure OAuth providers (Google, GitHub)
4. Set up database URLs and SMTP settings
5. Generate secure `NEXTAUTH_SECRET` for production

---

**🎉 Built with ❤️ using Vue.js + Next.js + TypeScript + Prisma**
