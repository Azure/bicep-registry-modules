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

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2024-08-01' existing = {
  name: flexibleServerName
}

resource database 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2024-08-01' = {
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
