# Azure Deployment Troubleshooting Guide

This document provides guidance for common issues you might encounter when deploying the fullstack authentication application to Azure.

## Prerequisites Check

- [ ] Azure CLI installed and logged in (`az login`)
- [ ] Subscription is active and set correctly (`az account set --subscription "<SUBSCRIPTION_ID>"`)
- [ ] Resource group exists or can be created (`az group create --name "rg-fullstackauth" --location "eastus"`)
- [ ] Docker images built successfully
- [ ] Local Docker containers run without errors

## Common Issues and Solutions

### 1. Resource Group Creation Failures

**Issue**: Unable to create resource group
**Possible Causes**:
- Insufficient permissions
- Subscription quota limits reached
- Name conflicts with existing (possibly soft-deleted) groups

**Solutions**:
- Check your Azure role assignments (`az role assignment list --all`)
- Try a different name for the resource group
- Check for any soft-deleted resource groups (`az group list-deleted`)

### 2. Container Apps Environment Creation Issues

**Issue**: Unable to create Container Apps Environment
**Possible Causes**:
- Region limitations for Container Apps
- Log Analytics workspace creation failure
- Network configuration issues
- Quota limits (e.g., "MaxNumberOfRegionalEnvironmentsInSubExceeded")

**Solutions**:
- Try a different Azure region (`westus`, `eastus2`, `westeurope`, etc.)
  - Note: We moved from `eastus` to `westus` due to environment quota limits
- Create a Log Analytics workspace manually:
  ```
  az monitor log-analytics workspace create \
    --resource-group rg-fullstackauth-west \
    --workspace-name log-fullstackauth-west
  ```
- Use the workspace ID in your deployment commands
- For quota limits, either request a quota increase or use a different region/subscription

### 3. Container Registry Access Problems

**Issue**: Unable to push/pull images to/from container registry
**Possible Causes**:
- Authentication issues
- Network restrictions
- Registry SKU limitations

**Solutions**:
- Re-authenticate with `az acr login --name <registry-name>`
- Check network outbound rules
- Verify registry SKU supports required operations

### 4. Container App Deployment Failures

**Issue**: Container Apps fail to deploy or start
**Possible Causes**:
- Container image issues
- Environment variable configuration
- Health probe failures
- Resource constraints

**Solutions**:
- Verify container image with `docker run` locally first
- Check environment variables in deployment command
- Implement or fix health endpoints
- Check resource limits (CPU/memory) in deployment configuration

### 5. Networking Issues

**Issue**: Apps deploy but can't communicate with each other
**Possible Causes**:
- CORS configuration
- Network security rules
- Service discovery problems

**Solutions**:
- Verify CORS settings in both frontend and backend
- Check network security group rules
- Ensure services use proper discovery mechanisms (environment variables, DNS)

## Logging and Diagnostics

### Container Apps Logs

```powershell
# View logs for a specific container app
az containerapp logs show -n <app-name> -g rg-fullstackauth
```

### Deployment Logs

```powershell
# View detailed deployment logs
az deployment group show -g rg-fullstackauth -n <deployment-name> --query properties.error
```

### Resource Health

```powershell
# Check health of resources
az resource show -g rg-fullstackauth -n <resource-name> --resource-type Microsoft.App/containerApps --query properties.provisioningState
```

## Recovery Steps

1. **Start Fresh**: Sometimes it's best to delete resources and start over:
   ```
   az group delete -n rg-fullstackauth --yes
   az group create -n rg-fullstackauth -l eastus
   ```

2. **Incremental Approach**: Deploy one component at a time:
   - First deploy Container Registry
   - Then deploy Container Apps Environment
   - Finally deploy individual Container Apps

3. **Use Azure Portal**: Some issues are easier to diagnose in the Azure Portal UI

## Getting Additional Help

If you continue to experience issues, please:
1. Check Azure Service Health for any ongoing issues
2. Gather detailed logs for all components
3. Review quotas and limits for your subscription
