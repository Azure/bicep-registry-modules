metadata name = 'DBforMySQL Flexible Server Configurations'
metadata description = 'This module deploys a DBforMySQL Flexible Server Configuration.'

@description('Required. The name of the configuration.')
param name string

@description('Conditional. The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Optional. Source of the configuration.')
@allowed([
  'system-default'
  'user-override'
])
param source string?

@description('Optional. Value of the configuration.')
param value string?

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2024-12-30' existing = {
  name: flexibleServerName
}

resource configuration 'Microsoft.DBforMySQL/flexibleServers/configurations@2024-12-30' = {
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
