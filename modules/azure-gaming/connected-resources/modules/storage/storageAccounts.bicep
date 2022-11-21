@description('Deployment Location')
param location string

param name string = uniqueString(resourceGroup().id)

@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'

@description('Resource Group')
param resourceGroupName string = resourceGroup().name

param subnetID string = ''
param enableVNET bool = false

@description('Toggle to enable or disable zone redudance.')
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

resource newStorageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = if (newOrExisting == 'new') {
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

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  scope: resourceGroup(resourceGroupName)
  name: name
}

var keys = newOrExisting == 'new' ? listKeys(newStorageAccount.id, newStorageAccount.apiVersion) : listKeys(storageAccount.id, storageAccount.apiVersion)
var blobStorageConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${keys.keys[0].value}'

output id string = newOrExisting == 'new' ? newStorageAccount.id : storageAccount.id
output blobStorageConnectionString string = blobStorageConnectionString
