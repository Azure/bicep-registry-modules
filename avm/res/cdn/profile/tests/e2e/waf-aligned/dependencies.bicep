@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the primary Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

// WAF: Reliability - Primary storage account with geo-redundancy
resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_GRS' // WAF: Reliability - Geo-redundant storage
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: true // Required for CDN access
    minimumTlsVersion: 'TLS1_2' // WAF: Security - Minimum TLS version
    supportsHttpsTrafficOnly: true // WAF: Security - HTTPS only
    accessTier: 'Hot' // WAF: Performance - Hot tier for frequently accessed data
    networkAcls: {
      defaultAction: 'Allow' // WAF: Allow CDN access
      bypass: 'AzureServices'
    }
    encryption: {
      services: {
        blob: {
          enabled: true // WAF: Security - Encryption at rest
        }
        file: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

// WAF: Reliability - Secondary storage account for failover
resource secondaryStorageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: '${take(storageAccountName, 20)}sec'
  location: location
  sku: {
    name: 'Standard_LRS' // WAF: Cost Optimization - LRS for secondary
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: true
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    accessTier: 'Cool' // WAF: Cost Optimization - Cool tier for backup
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
    encryption: {
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

// WAF: Security - Managed identity for secure access
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

// Outputs
@description('The resource ID of the primary Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The name of the primary Storage Account.')
output storageAccountName string = storageAccount.name

@description('The name of the secondary Storage Account.')
output secondaryStorageAccountName string = secondaryStorageAccount.name

@description('The resource ID of the Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
