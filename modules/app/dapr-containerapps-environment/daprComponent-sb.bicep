param name string
param location string
param entityName string
param containerAppEnvName string

param createAzureServiceForComponent bool = true

param scopes array = []


var daprComponent = 'pubsub.azure.servicebus'
var serviceBusConnectionStringName = 'sb-root-connectionstring'

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-01-01-preview' existing = {
  name: containerAppEnvName
}

resource daprServiceBus 'Microsoft.App/managedEnvironments/daprComponents@2022-03-01' = {
  name: '${name}-sb'
  parent: containerAppEnv
  properties: {
    componentType: daprComponent
    version: 'v1'
    secrets: [
      {
        name: serviceBusConnectionStringName
        value: '${listKeys('${servicebus.id}/AuthorizationRules/RootManageSharedAccessKey', servicebus.apiVersion).primaryConnectionString};EntityPath=${entityName}'
      }
    ]
    metadata: [
      {
        name: 'connectionString'
        secretRef: serviceBusConnectionStringName
      }
      {
        name: 'consumerID'
        value: entityName
      }
    ]
    scopes: scopes
  }
}

resource servicebus 'Microsoft.ServiceBus/namespaces@2021-11-01' = if(createAzureServiceForComponent) {
  name: 'sb-${name}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }

  resource topic 'topics' = {
    name: entityName
    properties: {
      supportOrdering: true
    }
  
    resource subscription 'subscriptions' = {
      name: entityName
      properties: {
        deadLetteringOnFilterEvaluationExceptions: true
        deadLetteringOnMessageExpiration: true
        maxDeliveryCount: 10
      }
    }
  }
}
