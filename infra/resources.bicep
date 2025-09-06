param location string = resourceGroup().location
param tags object = {}
param resourceToken string = uniqueString(subscription().id, location, environmentName)
param applicationInsightsSamplingRate int = 10
param containerRegistryPullSkuName string = 'Basic'
param nitroPort string = '3002'
param nextauthUrl string

// Resource names
var containerRegistryName = 'acr${resourceToken}'
var logAnalyticsName = 'log${resourceToken}'
var applicationInsightsName = 'appi${resourceToken}'
var keyVaultName = 'kv${resourceToken}'
var managedIdentityName = 'mi${resourceToken}'
var containerAppsEnvironmentName = 'cae${resourceToken}'
var frontendContainerAppName = 'cafrontend${resourceToken}'
var backendContainerAppName = 'cabackend${resourceToken}'

// Log Analytics Workspace
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

// Application Insights
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
    SamplingPercentage: applicationInsightsSamplingRate
  }
}

// User-assigned managed identity
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: tags
}

// Container Registry
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: containerRegistryName
  location: location
  tags: tags
  sku: {
    name: containerRegistryPullSkuName
  }
  properties: {
    adminUserEnabled: false
  }
}

// Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
  }
}

// Container Apps Environment
resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: containerAppsEnvironmentName
  location: location
  tags: tags
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
  }
}

// Frontend Container App
resource frontendContainerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: frontendContainerAppName
  location: location
  tags: union(tags, { 'azd-service-name': 'frontend' })
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    managedEnvironmentId: containerAppsEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: int(nitroPort)
        corsPolicy: {
          allowedOrigins: ['*']
          allowCredentials: true
        }
      }
      registries: [
        {
          server: containerRegistry.properties.loginServer
          identity: managedIdentity.id
        }
      ]
    }
    template: {
      containers: [
        {
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          name: 'frontend'
          env: [
            {
              name: 'NUXT_PUBLIC_API_BASE_URL'
              value: 'https://${backendContainerAppName}.${containerAppsEnvironment.properties.defaultDomain}'
            }
            {
              name: 'NUXT_API_BASE_URL'
              value: 'https://${backendContainerAppName}.${containerAppsEnvironment.properties.defaultDomain}'
            }
            {
              name: 'NITRO_PORT'
              value: nitroPort
            }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
        }
      ]
    }
  }
}

// Backend Container App
resource backendContainerApp 'Microsoft.App/containerApps@2024-03-01' = {
  name: backendContainerAppName
  location: location
  tags: union(tags, { 'azd-service-name': 'backend' })
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    managedEnvironmentId: containerAppsEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 3001
        corsPolicy: {
          allowedOrigins: ['https://${frontendContainerAppName}.${containerAppsEnvironment.properties.defaultDomain}']
          allowCredentials: true
        }
      }
      registries: [
        {
          server: containerRegistry.properties.loginServer
          identity: managedIdentity.id
        }
      ]
      secrets: [
        {
          name: 'database-url'
          keyVaultUrl: '${keyVault.properties.vaultUri}secrets/DATABASE-URL'
          identity: managedIdentity.id
        }
        {
          name: 'nextauth-secret'
          keyVaultUrl: '${keyVault.properties.vaultUri}secrets/NEXTAUTH-SECRET'
          identity: managedIdentity.id
        }
        {
          name: 'azure-postgres-host'
          keyVaultUrl: '${keyVault.properties.vaultUri}secrets/AZURE-POSTGRES-HOST'
          identity: managedIdentity.id
        }
        {
          name: 'azure-postgres-user'
          keyVaultUrl: '${keyVault.properties.vaultUri}secrets/AZURE-POSTGRES-USER'
          identity: managedIdentity.id
        }
        {
          name: 'azure-postgres-database'
          keyVaultUrl: '${keyVault.properties.vaultUri}secrets/AZURE-POSTGRES-DATABASE'
          identity: managedIdentity.id
        }
        {
          name: 'azure-postgres-password'
          keyVaultUrl: '${keyVault.properties.vaultUri}secrets/AZURE-POSTGRES-PASSWORD'
          identity: managedIdentity.id
        }
      ]
    }
    template: {
      containers: [
        {
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          name: 'backend'
          env: [
            {
              name: 'DATABASE_URL'
              secretRef: 'database-url'
            }
            {
              name: 'NEXTAUTH_URL'
              value: nextauthUrl
            }
            {
              name: 'NEXTAUTH_SECRET'
              secretRef: 'nextauth-secret'
            }
            {
              name: 'AZURE_POSTGRES_HOST'
              secretRef: 'azure-postgres-host'
            }
            {
              name: 'AZURE_POSTGRES_PORT'
              value: '5432'
            }
            {
              name: 'AZURE_POSTGRES_USER'
              secretRef: 'azure-postgres-user'
            }
            {
              name: 'AZURE_POSTGRES_DATABASE'
              secretRef: 'azure-postgres-database'
            }
            {
              name: 'AZURE_POSTGRES_PASSWORD'
              secretRef: 'azure-postgres-password'
            }
            {
              name: 'AZURE_POSTGRES_SSL'
              value: 'true'
            }
          ]
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
        }
      ]
    }
  }
}

// Role assignments
resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: containerRegistry
  name: guid(containerRegistry.id, managedIdentity.id, '7f951dda-4ed3-4680-a7ca-43fe172d538d')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource keyVaultSecretsOfficerRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: keyVault
  name: guid(keyVault.id, managedIdentity.id, 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Outputs
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerRegistry.properties.loginServer
output AZURE_CONTAINER_REGISTRY_NAME string = containerRegistry.name
