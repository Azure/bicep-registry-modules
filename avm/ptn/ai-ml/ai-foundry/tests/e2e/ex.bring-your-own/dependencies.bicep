@description('Workload / application name prefix.')
param workloadName string

@description('The location to deploy the resources into.')
param location string

@description('Optional. Tags of the resources.')
param tags object = {}

var containers = ['project-data', 'sys-data']

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: take('stbyor${workloadName}', 24)
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
  }
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    deleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource containerResources 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = [
  for containerName in containers: {
    name: containerName
    parent: blobServices
    properties: {}
  }
]

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: take('kvbyor${workloadName}', 24)
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'premium'
      family: 'A'
    }
    tenantId: subscription().tenantId
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
    }
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enablePurgeProtection: null // set to null instead of false because that's what the AVM module does
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
  }
}

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2025-04-15' = {
  name: take('cosmosbyor${workloadName}cosmos', 50)
  location: location
  tags: tags
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    enableFreeTier: false
  }
}

resource aiSearch 'Microsoft.Search/searchServices@2023-11-01' = {
  name: 'srch${workloadName}search'
  location: location
  tags: tags
  sku: {
    name: 'standard'
  }
  properties: {
    hostingMode: 'default'
    partitionCount: 1
    replicaCount: 1
    publicNetworkAccess: 'enabled'
  }
}

output storageAccountResourceId string = storageAccount.id
output keyVaultResourceId string = keyVault.id
output cosmosDbAccountResourceId string = cosmosDbAccount.id
output aiSearchResourceId string = aiSearch.id

output containers string[] = containers
