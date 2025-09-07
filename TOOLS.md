# Project Tools and Scripts

## Local Development Tools

### 1. Docker Management
- `start-docker.ps1` / `start-docker.sh`: Start both frontend and backend containers
- `view-logs.ps1` / `view-logs.sh`: View container logs with filtering options

### 2. Local Access
- Frontend: http://localhost:3002
- Backend: http://localhost:3001
- Mobile access (same network): Use your machine's IP address with the same ports

## Azure Deployment Tools

### 1. Deployment Scripts
- `deploy-to-azure.ps1` / `deploy-to-azure.sh`: Full deployment script to Azure Container Apps

### 2. Monitoring Tools
- `monitor-deployment.ps1`: Real-time monitoring of Azure deployment
- `check-azure-status.ps1` / `check-azure-status.sh`: Check status of Azure resources
- `get-deployment-urls.ps1`: Wait for final URLs and save them to a file

### 3. Troubleshooting
- See `AZURE-TROUBLESHOOTING.md` for detailed Azure deployment troubleshooting

## Documentation Files

- `PROJECT-SUMMARY.md`: Overview of project architecture
- `DEPLOYMENT-SUMMARY.md`: Summary of deployment process and resources
- `ACCESSING-DEPLOYED-APP.md`: How to access and test the deployed application
- `LINKS.md`: Quick reference for all access URLs and commands
- `DEPLOYMENT-URLS.md`: (Generated) Contains the final Azure deployment URLs

## How to Use These Tools

1. **Starting Local Development**
   ```powershell
   # Start local Docker containers
   .\start-docker.ps1
   
   # View container logs
   .\view-logs.ps1
   ```

2. **Deploying to Azure**
   ```powershell
   # Deploy to Azure
   .\deploy-to-azure.ps1
   
   # Monitor deployment status
   .\monitor-deployment.ps1
   
   # Get final URLs when deployment completes
   .\get-deployment-urls.ps1
   ```

3. **Troubleshooting**
   ```powershell
   # Check Azure resource status
   .\check-azure-status.ps1
   
   # Get detailed information about a specific resource
   az containerapp show -n frontend-auth -g rg-fullstackauth
   ```
