metadata name = 'Service Bus Namespace Migration Configuration'
metadata description = 'This module deploys a Service Bus Namespace Migration Configuration.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment.')
@minLength(6)
@maxLength(50)
param namespaceName string

@description('Required. Name to access Standard Namespace after migration.')
param postMigrationName string

@description('Required. Existing premium Namespace resource ID which has no entities, will be used for migration.')
param targetNamespaceResourceId string

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
