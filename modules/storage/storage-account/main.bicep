@description('Deployment Location')
param location string

@description('Name of Storage Account. Must be unique within Azure.')
param name string = 'st${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([ 'new', 'existing' ])
@description('Specifies whether to create a new Storage Account or use an existing one.')
param newOrExisting string = 'new'

@description('Name of Resource Group where the Storage Account will be deployed.')
param resourceGroupName string = resourceGroup().name

@description('ID of the subnet where the Storage Account will be deployed, if virtual network access is enabled.')
param subnetID string = ''

@description('Toggle to enable or disable virtual network access for the Storage Account.')
param enableVNET bool = false

@description('Toggle to enable or disable zone redundancy for the Storage Account.')
param isZoneRedundant bool = false

@description('Storage Account Type. Use Zonal Redundant Storage when able.')
param storageAccountType string = isZoneRedundant ? 'Standard_ZRS' : 'Standard_LRS'

var networkAcls = enableVNET ? {
  defaultAction: 'Deny'
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: subnetID
    }
  ]
} : {}

resource newStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = if (newOrExisting == 'new') {
  name: name
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
    }
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    networkAcls: networkAcls
    minimumTlsVersion: 'TLS1_2'
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  scope: resourceGroup(resourceGroupName)
  name: name
}

@description('The ID of the created or existing Storage Account. Use this ID to reference the Storage Account in other Azure resource deployments.')
output id string = newOrExisting == 'new' ? newStorageAccount.id : storageAccount.id
