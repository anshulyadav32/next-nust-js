// main.bicep.new - Template file
@description('The environment name')
param environmentName string = 'dev'

@description('The location for all resources')
param location string = resourceGroup().location

var resourceToken = uniqueString(subscription().id, resourceGroup().id, location, environmentName)

// Tags
var tags = {
  'azd-env-name': environmentName
}

// Create a user-assigned managed identity
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-${environmentName}-${resourceToken}'
  location: location
  tags: tags
}

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'plan-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  sku: {
    name: 'B1'
  }
}

// Frontend App Service
resource frontendApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'frontend-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'NUXT_PUBLIC_API_BASE_URL'
          value: 'https://${backendApp.properties.defaultHostName}'
        }
      ]
      cors: {
        allowedOrigins: ['*']
        supportCredentials: true
      }
    }
  }
}

// Backend App Service
resource backendApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'backend-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'NEXTAUTH_URL'
          value: 'https://${backendApp.properties.defaultHostName}'
        }
      ]
      cors: {
        allowedOrigins: ['https://${frontendApp.properties.defaultHostName}']
        supportCredentials: true
      }
    }
  }
}

// Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'kv-${environmentName}-${resourceToken}'
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: managedIdentity.properties.principalId
        permissions: {
          secrets: ['get', 'list']
        }
      }
    ]
  }
}

// Required outputs
output frontendUrl string = 'https://${frontendApp.properties.defaultHostName}'
output backendUrl string = 'https://${backendApp.properties.defaultHostName}'
output keyVaultName string = keyVault.name
output RESOURCE_GROUP_ID string = resourceGroup().id
