# Container App Deployment Fix

This document explains the changes made to fix the Container App Environment quota issue.

## Issue

The error message indicated that you've reached the maximum number of Container App Environments allowed in your subscription:

```
(MaxNumberOfGlobalEnvironmentsInSubExceeded) The subscription 'd0ae77fd-6582-4109-870a-949613871b52' cannot have more than 1 Container App Environments.
```

## Solution

We've updated your deployment script to use the existing Container App Environment instead of trying to create a new one.

### Changes Made:

1. **Using Existing Resources**:
   - Changed the resource group to `rg-dev` which already contains a Container App Environment
   - Set the location to `eastus` to match the existing environment
   - Set the Container App Environment name to `az-cae-onox3m7mozzm2` (your existing environment)

2. **Deployment Script Logic**:
   - Modified the script to check if the environment exists rather than trying to create a new one
   - Added better error handling if the environment can't be found

## How to Deploy

1. Start Docker Desktop and ensure it's running
2. Build your Docker images:
   ```powershell
   # Build frontend image
   docker build -t fullstack-auth-frontend:latest ./frontend
   
   # Build backend image
   docker build -t fullstack-auth-backend:latest ./backend
   ```

3. Run the updated deployment script:
   ```powershell
   ./deploy-to-azure.ps1
   ```

## Additional Notes

1. If you need to list all available Container App Environments:
   ```powershell
   az containerapp env list --output table
   ```

2. If you want to deploy to a different region in the future, you'll need to:
   - Request a quota increase from Azure support, or
   - Delete an existing Container App Environment first

3. For local development, you can use:
   ```powershell
   ./start-docker.ps1
   ```
