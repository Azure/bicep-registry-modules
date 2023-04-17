@description('Deployment Location')
param location string

@description('Name of Storage Account. Must be unique within Azure.')
param name string = 'st${uniqueString(resourceGroup().id, subscription().id)}'

@description('ID of the subnet where the Storage Account will be deployed, if virtual network access is enabled.')
param subnetID string = ''

@description('Toggle to enable or disable virtual network access for the Storage Account.')
param enableVNET bool = false

@description('Toggle to enable or disable zone redundancy for the Storage Account.')
param isZoneRedundant bool = false

@description('Storage Account Type. Use Zonal Redundant Storage when able.')
param storageAccountType string = isZoneRedundant ? 'Standard_ZRS' : 'Standard_LRS'

@description('Toggle to enable or disable Blob service of the Storage Account.')
param enableBlobService bool = false

@description('Properties object for a Blob service of a Storage Account.')
param blobProperties blobServiceProperties = {}

@description('Name of a blob container to be created')
param blobContainerName string = 'default'

@description('Properties object for a Blob container of a Storage Account.')
param blobContainerProperties blobServiceContainerProperties = {}

@description('Toggle to enable or disable versioning for Blob service of the Storage Account. Used only if enableBlobService is set to true.')
type isBlobVersioningEnabled = false | true

type blobServiceProperties = {
  changeFeed: changeFeed?
  containerDeleteRetentionPolicy: containerDeleteRetentionPolicy?
  cors: cors?
  deleteRetentionPolicy: deleteRetentionPolicy?
  isVersioningEnabled: isBlobVersioningEnabled?
  lastAccessTimeTrackingPolicy: lastAccessTimeTrackingPolicy?
  restorePolicy: restorePolicy?
}

type changeFeed = {
  enabled: bool
  retentionInDays: int
}

type containerDeleteRetentionPolicy = {
  allowPermanentDelete: bool
  days: int
  enabled: bool
}

type cors = {
  corsRules: [
    {
      allowedHeaders: [
        'string'
      ]
      allowedMethods: [
        'string'
      ]
      allowedOrigins: [
        'string'
      ]
      exposedHeaders: [
        'string'
      ]
      maxAgeInSeconds: int
    }
  ]
}

type deleteRetentionPolicy = {
  allowPermanentDelete: bool
  days: int
  enabled: bool
}

type lastAccessTimeTrackingPolicy = {
  blobType: [
    'string'
  ]
  enable: bool
  name: 'AccessTimeTracking'
  trackingGranularityInDays: int
}

type restorePolicy = {
  days: int
  enabled: bool
}

type blobServiceContainerProperties = {
  publicAccess: blobContainerPublicAccess?
}

type blobContainerPublicAccess = 'Blob' | 'Container' | 'None'

var networkAcls = enableVNET ? {
  defaultAction: 'Deny'
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: subnetID
    }
  ]
} : {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
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

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = if (enableBlobService) {
  name: 'default'
  parent: storageAccount
  properties: blobProperties
}

resource containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = if (enableBlobService) {
  name: blobContainerName
  parent: blobService
  properties: blobContainerProperties
}

@description('The ID of the created or existing Storage Account. Use this ID to reference the Storage Account in other Azure resource deployments.')
output id string = storageAccount.id
