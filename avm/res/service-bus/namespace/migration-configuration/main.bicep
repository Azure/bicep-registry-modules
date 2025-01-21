metadata name = 'Service Bus Namespace Migration Configuration'
metadata description = 'This module deploys a Service Bus Namespace Migration Configuration.'

@description('Conditional. The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment.')
@minLength(1)
@maxLength(260)
param namespaceName string

@description('Required. Name to access Standard Namespace after migration.')
param postMigrationName string

@description('Required. Existing premium Namespace resource ID which has no entities, will be used for migration.')
param targetNamespaceResourceId string

resource namespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: namespaceName
}

resource migrationConfiguration 'Microsoft.ServiceBus/namespaces/migrationConfigurations@2022-10-01-preview' = {
  name: '$default'
  parent: namespace
  properties: {
    targetNamespace: targetNamespaceResourceId
    postMigrationName: postMigrationName
  }
}

@description('The name of the migration configuration.')
output name string = migrationConfiguration.name

@description('The Resource ID of the migration configuration.')
output resourceId string = migrationConfiguration.id

@description('The name of the Resource Group the migration configuration was created in.')
output resourceGroupName string = resourceGroup().name
