@description('Required. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Environment for Container Apps to create.')
param managedEnvironmentName string

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Required. The name of the workload profile to create.')
param workloadProfileName string

@description('Required. The name of the storage account to create.')
param storageAccountName string

resource managedEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: managedEnvironmentName
  location: location
  properties: {
    workloadProfiles: [
      {
        name: workloadProfileName
        workloadProfileType: 'D4'
        maximumCount: 1
        minimumCount: 1
      }
    ]
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: managedIdentityName
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowSharedKeyAccess: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
  }
  tags: {
    'hidden-title': 'This is visible in the resource name'
    Env: 'test'
  }

  resource storageQueueService 'queueServices@2023-04-01' = {
    name: 'default'

    resource storageQueue 'queues@2023-04-01' = {
      name: 'jobs-queue'
    }
  }
}

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Managed Environment.')
output managedEnvironmentResourceId string = managedEnvironment.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created storage account')
output storageAccountResourceId string = storageAccount.id

@description('The name of the storage account created.')
output storageAccountName string = storageAccount.name

@description('The name of the storage queue created.')
output storageQueueName string = storageAccount::storageQueueService::storageQueue.name
