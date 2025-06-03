@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Storage Queue to create.')
param storageQueueName string

@description('Required. The name of the Service Bus Namespace to create.')
param serviceBusNamespaceName string

@description('Required. The name of the Service Bus Topic to create.')
param serviceBusTopicName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

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

// Service Bus Namespace and Topic for testing deliveryWithResourceIdentity
resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }

  resource topic 'topics@2024-01-01' = {
    name: serviceBusTopicName
    properties: {
      enablePartitioning: false
    }
  }
}

// Role assignment for managed identity to send messages to Service Bus
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(serviceBusNamespace.id, managedIdentity.id, 'Azure Service Bus Data Sender')
  scope: serviceBusNamespace
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39') // Azure Service Bus Data Sender
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

@description('The name of the created Storage Account Queue.')
output queueName string = storageAccount::queueService::queue.name

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created User Assigned Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Service Bus Namespace.')
output serviceBusNamespaceResourceId string = serviceBusNamespace.id

@description('The resource ID of the created Service Bus Topic.')
output serviceBusTopicResourceId string = serviceBusNamespace::topic.id

@description('The name of the created Service Bus Topic.')
output serviceBusTopicName string = serviceBusNamespace::topic.name
