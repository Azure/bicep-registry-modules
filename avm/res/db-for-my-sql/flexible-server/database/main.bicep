metadata name = 'DBforMySQL Flexible Server Databases'
metadata description = 'This module deploys a DBforMySQL Flexible Server Database.'

@description('Required. The name of the database.')
param name string

@description('Conditional. The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Optional. The collation of the database.')
param collation string = 'utf8'

@description('Optional. The charset of the database.')
param charset string = 'utf8_general_ci'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.dbformysql-flexisrv-database.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2024-12-30' existing = {
  name: flexibleServerName
}

resource database 'Microsoft.DBforMySQL/flexibleServers/databases@2024-12-30' = {
  name: name
  parent: flexibleServer
  properties: {
    collation: !empty(collation) ? collation : null
    charset: !empty(charset) ? charset : null
  }
}

@description('The name of the deployed database.')
output name string = database.name

@description('The resource ID of the deployed database.')
output resourceId string = database.id

@description('The resource group of the deployed database.')
output resourceGroupName string = resourceGroup().name
