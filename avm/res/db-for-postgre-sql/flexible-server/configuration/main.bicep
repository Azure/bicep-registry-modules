metadata name = 'DBforPostgreSQL Flexible Server Configurations'
metadata description = 'This module deploys a DBforPostgreSQL Flexible Server Configuration.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the configuration.')
param name string

@description('Conditional. The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Optional. Source of the configuration.')
param source string?

@description('Optional. Value of the configuration.')
param value string?

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' existing = {
  name: flexibleServerName
}

resource configuration 'Microsoft.DBforPostgreSQL/flexibleServers/configurations@2022-12-01' = {
  name: name
  parent: flexibleServer
  properties: {
    source: !empty(source) ? source : null
    value: !empty(value) ? value : null
  }
}

@description('The name of the deployed configuration.')
output name string = configuration.name

@description('The resource ID of the deployed configuration.')
output resourceId string = configuration.id

@description('The resource group of the deployed configuration.')
output resourceGroupName string = resourceGroup().name
