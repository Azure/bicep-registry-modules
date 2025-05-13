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

resource managedEnvironment 'Microsoft.App/managedEnvironments@2025-01-01' = {
  name: managedEnvironmentName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    workloadProfiles: [
      {
        name: workloadProfileName
        workloadProfileType: 'D4'
        maximumCount: 1
        minimumCount: 1
      }
    ]
    appLogsConfiguration: {
      destination: 'azure-monitor'
    }
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
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

  resource storageQueueService 'queueServices@2024-01-01' = {
    name: 'default'

    resource storageQueue 'queues@2024-01-01' = {
      name: 'jobs-queue'
    }
  }
}

// assign "Storage Queue Data Contributor" role to the managed identity for the storage account
resource roleAssignment_storageQueueDataContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managedIdentity.id, 'StorageQueueDataContributor', storageAccount.id)
  scope: storageAccount
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/974c5e8b-45b9-4653-ba55-5f855dd0fb88'
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
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
