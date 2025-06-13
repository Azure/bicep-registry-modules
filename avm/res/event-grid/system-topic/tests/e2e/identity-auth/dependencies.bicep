@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Storage Queue to create.')
param storageQueueName string

@description('Required. The name of the Storage Blob Container to create.')
param storageBlobContainerName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
}

resource storageQueue 'Microsoft.Storage/storageAccounts/queueServices/queues@2024-01-01' = {
  name: '${storageAccount.name}/default/${storageQueueName}'
  properties: {
    metadata: {
      purpose: 'EventGrid deliveries'
    }
  }
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  name: '${storageAccount.name}/default/${storageBlobContainerName}'
  properties: {
    publicAccess: 'None'
    metadata: {
      purpose: 'EventGrid dead letters'
    }
  }
}

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The name of the created Storage Account.')
output storageAccountName string = storageAccount.name

@description('The name of the created Storage Queue.')
output queueName string = storageQueueName

@description('The name of the created Storage Container.')
output blobContainerName string = storageBlobContainerName
