metadata name = 'DBforMySQL Flexible Server Databases'
metadata description = 'This module deploys a DBforMySQL Flexible Server Database.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the database.')
param name string

@description('Conditional. The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Optional. The collation of the database.')
param collation string = 'utf8'

@description('Optional. The charset of the database.')
param charset string = 'utf8_general_ci'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2022-09-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2022-09-30-preview' existing = {
  name: flexibleServerName
}

resource database 'Microsoft.DBforMySQL/flexibleServers/databases@2022-01-01' = {
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
