metadata name = 'Service Bus Namespace Queue Authorization Rules'
metadata description = 'This module deploys a Service Bus Namespace Queue Authorization Rule.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the service bus namepace queue.')
param name string

@description('Conditional. The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Conditional. The name of the parent Service Bus Namespace Queue. Required if the template is used in a standalone deployment.')
param queueName string

@description('Optional. The rights associated with the rule.')
@allowed([
  'Listen'
  'Manage'
  'Send'
])
param rights array = []

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource namespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: namespaceName

  resource queue 'queues@2022-10-01-preview' existing = {
    name: queueName
  }
}

resource authorizationRule 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2022-10-01-preview' = {
  name: name
  parent: namespace::queue
  properties: {
    rights: rights
  }
}

@description('The name of the authorization rule.')
output name string = authorizationRule.name

@description('The Resource ID of the authorization rule.')
output resourceId string = authorizationRule.id

@description('The name of the Resource Group the authorization rule was created in.')
output resourceGroupName string = resourceGroup().name
