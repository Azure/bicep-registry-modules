metadata name = 'DBforPostgreSQL Flexible Server Configurations'
metadata description = 'This module deploys a DBforPostgreSQL Flexible Server Configuration.'

@description('Required. The name of the configuration.')
param name string

@description('Conditional. The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Optional. Source of the configuration.')
param source string?

@description('Optional. Value of the configuration.')
param value string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.dbforpostgresql-flexisrv-config.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2026-01-01-preview' existing = {
  name: flexibleServerName
}

resource configuration 'Microsoft.DBforPostgreSQL/flexibleServers/configurations@2026-01-01-preview' = {
  name: name
  parent: flexibleServer
  properties: {
    source: source
    value: value
  }
}

@description('The name of the deployed configuration.')
output name string = configuration.name

@description('The resource ID of the deployed configuration.')
output resourceId string = configuration.id

@description('The resource group name of the deployed configuration.')
output resourceGroupName string = resourceGroup().name
