# Fullstack Authentication Application

## Access Links

### Local Development
- Frontend: http://localhost:3002
- Backend API: http://localhost:3001

### Mobile Development (same network)
- Frontend: http://{your-ip-address}:3002
- Backend API: http://{your-ip-address}:3001

### Azure Deployment
- Frontend: https://frontend-auth.westus.azurecontainerapps.io
- Backend API: https://backend-auth.westus.azurecontainerapps.io
- Note: Deployed to West US region due to quota limits in East US

## Quick Commands

### Start Local Development
```powershell
# PowerShell
.\start-docker.ps1

# Bash
./start-docker.sh
```

### View Logs
```powershell
# PowerShell - View all logs
.\view-logs.ps1

# PowerShell - View frontend logs
.\view-logs.ps1 frontend

# PowerShell - View backend logs
.\view-logs.ps1 backend

# Bash - View all logs
./view-logs.sh

# Bash - View frontend logs
./view-logs.sh frontend

# Bash - View backend logs
./view-logs.sh backend
```

### Deploy to Azure
```powershell
# PowerShell
.\deploy-to-azure.ps1

# Bash
./deploy-to-azure.sh
```

### Check Azure Deployment Status
```powershell
# PowerShell
.\monitor-deployment.ps1

# Or check directly in Azure Portal
```

## Documentation

- [Project Summary](./PROJECT-SUMMARY.md)
- [Azure Troubleshooting](./AZURE-TROUBLESHOOTING.md)
- [Accessing Deployed App](./ACCESSING-DEPLOYED-APP.md)
- [Backend README](./backend/README.md)
- [Frontend README](./frontend/README.md)

## Tech Stack

- **Frontend**: Nuxt.js (Vue 3) with Tailwind CSS
- **Backend**: Next.js API with Auth.js and Prisma
- **Containerization**: Docker with multi-stage builds
- **Cloud**: Azure Container Apps

## Authentication Features

- Email/Password Registration & Login
- OAuth with Google and GitHub
- Email Verification
- Password Reset
- Role-Based Access Control
