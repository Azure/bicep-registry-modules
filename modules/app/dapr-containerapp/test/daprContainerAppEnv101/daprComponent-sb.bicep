param componentName string
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
  name: componentName
  parent: containerAppEnv
  properties: {
    componentType: daprComponent
    version: 'v1'
    secrets: [
      {
        name: serviceBusConnectionStringName
        value: '${sbAuthRule.listKeys().primaryConnectionString};EntityPath=${entityName}'
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
  name: 'sb-${componentName}-${uniqueString(resourceGroup().id, location)}'
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

resource sbAuthRule 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2021-11-01' existing = {
  name: 'RootManageSharedAccessKey'
  parent: servicebus
}
