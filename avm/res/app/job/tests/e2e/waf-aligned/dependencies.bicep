@description('Required. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Environment for Container Apps to create.')
param managedEnvironmentName string

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Required. The name of the workload profile to create.')
param workloadProfileName string

resource managedEnvironment 'Microsoft.App/managedEnvironments@2023-05-01' = {
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
  name: uniqueString('${managedEnvironmentName}storage')
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
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-04-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 1
    }
  }
}

resource storageQueue 'Microsoft.Storage/storageAccounts/queueServices@2023-04-01' = {
  name: 'default'
  parent: storageAccount
}

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Managed Environment.')
output managedEnvironmentResourceId string = managedEnvironment.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the storage account created.')
output storageAccountResourceId string = storageAccount.id

@description('The primary key of the storage account created.')
output storageAccountKey string = storageAccount.listKeys().keys[0].value

@description('The name of the storage queue created.')
output storageQueueName string = storageQueue.name
