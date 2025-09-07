# Region Change for Azure Deployment

Due to quota limits in the East US region, we've updated our deployment to use the West US region. Here's what changed:

## Resource Groups
- Old: `rg-fullstackauth` (East US)
- New: `rg-fullstackauth-west` (West US)

## Resources
- Log Analytics Workspace: `log-fullstackauth-west`
- Container Registry: `acrfullstackwest`
- Container App Environment: `frontend-auth-env` (now in West US)

## Scripts Updated
- `deploy-to-azure.ps1`
- `deploy-to-azure.sh`
- `monitor-deployment.ps1`
- `check-azure-status.ps1`
- `check-azure-status.sh`
- `get-deployment-urls.ps1`

## Error That Prompted Change
```
(MaxNumberOfRegionalEnvironmentsInSubExceeded) The subscription 'd0ae77fd-6582-4109-870a-949613871b52' 
cannot have more than 1 Container App Environments in East US.
```

This error occurred because the subscription already had a Container App Environment in the East US region, and there's a limit of 1 per region per subscription.

## Note on Region Selection
When deploying to Azure Container Apps, consider the following:

1. Container App Environment limits (typically 1-3 per region per subscription)
2. Region availability of Container Apps service
3. Proximity to users for better performance
4. Pricing differences between regions

Always check the current Azure limits and quotas before deployment: https://docs.microsoft.com/en-us/azure/container-apps/quotas
