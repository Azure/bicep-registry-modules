@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Storage Queue to create.')
param storageQueueName string = 'eventqueue'

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'

  resource queueService 'queueServices@2024-01-01' = {
    name: 'default'

    resource queue 'queues@2024-01-01' = {
      name: storageQueueName
    }
  }
}

@description('The name of the created Storage Account Queue.')
output queueName string = storageAccount::queueService::queue.name

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id
