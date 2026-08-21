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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.servicebus-namespace-migrconfig.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, resourceGroup().location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource namespace 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = {
  name: namespaceName
}

resource migrationConfiguration 'Microsoft.ServiceBus/namespaces/migrationConfigurations@2024-01-01' = {
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
