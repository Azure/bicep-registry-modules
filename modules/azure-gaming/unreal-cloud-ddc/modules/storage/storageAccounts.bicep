@description('Deployment Location')
param location string

param name string = uniqueString(resourceGroup().id)
param resourceGroupName string = resourceGroup().name

@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'

param subnetID string = ''
param enableVNET bool = false

@description('Toggle to enable or disable zone redudance.')
param isZoneRedundant bool = false

@allowed([ 'Standard', 'Premium' ])
@description('Storage Account Tier. Standard or Premium.')
param storageAccountTier string = 'Standard'

@description('Storage Account Type. Use Zonal Redundant Storage when able.')
param storageAccountType string = isZoneRedundant ? '${storageAccountTier}_ZRS' : '${storageAccountTier}_LRS'

var networkAcls = enableVNET ? {
  defaultAction: 'Deny'
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: subnetID
    }
  ]
} : {}

resource newStorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = if (newOrExisting == 'new') {
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

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  scope: resourceGroup(resourceGroupName)
  name: name
}

var blobStorageConnectionString = newOrExisting == 'new' ? 'DefaultEndpointsProtocol=https;AccountName=${name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}' : ''

output id string = storageAccount.id
output blobStorageConnectionString string = blobStorageConnectionString
output resourceGroupName string = resourceGroupName
output apiVersion string = newStorageAccount.apiVersion
