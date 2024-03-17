metadata name = 'Relay Namespace Authorization Rules'
metadata description = 'This module deploys a Relay Namespace Authorization Rule.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Relay Namespace for the Relay Hybrid Connection. Required if the template is used in a standalone deployment.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Required. The name of the authorization rule.')
param name string

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

resource namespace 'Microsoft.Relay/namespaces@2021-11-01' existing = {
  name: namespaceName
}

resource authorizationRule 'Microsoft.Relay/namespaces/authorizationRules@2021-11-01' = {
  name: name
  parent: namespace
  properties: {
    rights: rights
  }
}

@description('The name of the authorization rule.')
output name string = authorizationRule.name

@description('The resource ID of the authorization rule.')
output resourceId string = authorizationRule.id

@description('The name of the Resource Group the authorization rule was created in.')
output resourceGroupName string = resourceGroup().name
