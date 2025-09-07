targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Environment name')
param environmentName string

@minLength(1)
@description('Primary Azure region')
param location string = 'eastus'

// Explicit location for subscription-level deployment
var deploymentLocation = location

@description('Resource group name')
param resourceGroupName string = 'rg-${environmentName}'

@description('Application insights sampling rate')
param applicationInsightsSamplingRate int = 10

@description('Container registry sku')
param containerRegistryPullSkuName string = 'Basic'

@description('Environment variables for frontend service')
param nitroPort string = '3002'

@description('Environment variables for backend service')
param nextauthUrl string

// Tags
var tags = {
  application: 'fullstack-auth'
  environment: environmentName
  'azd-env-name': environmentName
}

// Resource naming
var resourceToken = uniqueString(subscription().id, location, environmentName)

// Resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// Deploy resources to the resource group
module resources 'resources.bicep' = {
  scope: resourceGroup
  name: 'resources'
  params: {
    location: location
    tags: tags
    resourceToken: resourceToken
    applicationInsightsSamplingRate: applicationInsightsSamplingRate
    containerRegistryPullSkuName: containerRegistryPullSkuName
    nitroPort: nitroPort
    nextauthUrl: nextauthUrl
  }
}

// Outputs
output RESOURCE_GROUP_ID string = resourceGroup.id
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = resources.outputs.AZURE_CONTAINER_REGISTRY_ENDPOINT
output AZURE_CONTAINER_REGISTRY_NAME string = resources.outputs.AZURE_CONTAINER_REGISTRY_NAME
