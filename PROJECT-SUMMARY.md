# Fullstack Authentication Project Summary

This document provides a quick overview of the project architecture, deployment options, and maintenance guidelines.

## Project Architecture

### Overview
- **Frontend**: Nuxt.js (Vue 3) application serving the user interface
- **Backend**: Next.js API providing authentication and database services
- **Database**: PostgreSQL (development uses SQLite via Prisma)
- **Authentication**: Auth.js v5 (previously NextAuth) with multiple providers
- **Containerization**: Docker with multi-stage builds for production optimization

### Key Components

1. **Frontend (Nuxt.js)**
   - SSR-capable Vue application
   - Custom authentication composables
   - Protected routes via middleware
   - Tailwind CSS for styling

2. **Backend (Next.js API)**
   - Auth.js integration for authentication
   - Prisma ORM for database access
   - Email services for verification and password reset
   - Role-based access control

3. **Shared Layer**
   - TypeScript types shared between frontend and backend
   - Common utilities and constants

## Deployment Options

### 1. Local Development

Run the application locally using:

```bash
# PowerShell
.\start-docker.ps1

# Bash
./start-docker.sh
```

This will start:
- Frontend on http://localhost:3002
- Backend on http://localhost:3001

### 2. Docker Containers

The project includes Docker configurations for both services:

```bash
# Build the images
docker-compose -f docker-compose.dev.yml build

# Run the containers
docker-compose -f docker-compose.dev.yml up
```

### 3. Azure Container Apps (Production)

Deploy to Azure using:

```bash
# PowerShell
.\deploy-to-azure.ps1

# Bash
./deploy-to-azure.sh
```

This will:
1. Create necessary Azure resources
2. Push Docker images to Azure Container Registry
3. Deploy both services as Container Apps
4. Configure network and environment variables

## Maintenance Guidelines

### Database Migrations

When changing the database schema:

```bash
# Generate a migration
cd backend
npx prisma migrate dev --name <migration-name>

# Apply migrations
npx prisma migrate deploy
```

### Adding New Environment Variables

1. Update `.env.example` in the respective service directory
2. Add the variable to Docker Compose files
3. Update Azure deployment scripts as needed

### Monitoring & Logs

- **Local**: Use `.\view-logs.ps1` or `./view-logs.sh`
- **Azure**: Use Azure Portal or `az containerapp logs show`

### Security Considerations

- Auth.js secret must be kept secure
- Database connection strings should use environment variables
- OAuth provider credentials should be rotated periodically
- Email templates should be reviewed for phishing prevention

## Troubleshooting

See `AZURE-TROUBLESHOOTING.md` for detailed Azure deployment troubleshooting.

For local Docker issues:
1. Check Docker logs with `.\view-logs.ps1`
2. Verify environment variables
3. Check container networking
4. Validate health check endpoints are responding

## Future Development

Planned enhancements:
1. Add multi-factor authentication
2. Implement API rate limiting
3. Add audit logging for security events
4. Improve email template customization
5. Add user profile management
