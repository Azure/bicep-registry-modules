@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

param serviceBusNamespaceName string

var messageRoutingTopic = 'topic1'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Standard'
    capacity: 1
    tier: 'Standard'
  }
  properties: {}
  // identity: {
  //   type: 'UserAssigned'
  //   userAssignedIdentities: {
  //     '${managedIdentity.id}': {}
  //   }
  // }

  resource authorizationRule 'authorizationRules@2021-11-01' = {
    name: 'RootManageSharedAccessKey'
    properties: {
      rights: [
        'Listen'
        'Send'
        'Manage'
      ]
    }
  }

  resource topics 'topics@2021-11-01' = {
    name: messageRoutingTopic
    properties: {
      requiresDuplicateDetection: false
      enableBatchedOperations: true
      status: 'Active'
      supportOrdering: false
      enablePartitioning: true
      enableExpress: false
    }

    resource ubscription 'subscriptions@2021-11-01' = {
      name: 'subscription1'
      properties: {
        lockDuration: 'PT5M'
        requiresSession: false
        deadLetteringOnMessageExpiration: false
        deadLetteringOnFilterEvaluationExceptions: true
        defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
        autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
        enableBatchedOperations: true
        status: 'Active'
      }
    }
  }
}

resource sbPermissionsReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${managedIdentity.name}-ServiceBus-DataReceiver-RoleAssignment')
  scope: serviceBusNamespace
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0'
    ) // Azure Service Bus Data Receiver
    principalType: 'ServicePrincipal'
  }
}

resource sbPermissionsSender 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${managedIdentity.name}-ServiceBus-DataSender-RoleAssignment')
  scope: serviceBusNamespace
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39'
    ) // Azure Service Bus Data Sender
    principalType: 'ServicePrincipal'
  }
}
@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

output serviceBusResourceId string = serviceBusNamespace.id

output serviceBusName string = serviceBusNamespace.name

output serviceBusEndpoint string = serviceBusNamespace.properties.serviceBusEndpoint
