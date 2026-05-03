metadata name = 'DBforPostgreSQL Flexible Server Databases'
metadata description = 'This module deploys a DBforPostgreSQL Flexible Server Database.'

@description('Required. The name of the database.')
param name string

@description('Conditional. The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Optional. The collation of the database.')
param collation string?

@description('Optional. The charset of the database.')
param charset string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.dbforpostgresql-flexisrv-database.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource database 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2026-01-01-preview' = {
  name: name
  parent: flexibleServer
  properties: {
    collation: collation
    charset: charset
  }
}

@description('The name of the deployed database.')
output name string = database.name

@description('The resource ID of the deployed database.')
output resourceId string = database.id

@description('The resource group name of the deployed database.')
output resourceGroupName string = resourceGroup().name
