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

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' existing = {
  name: flexibleServerName
}

resource database 'Microsoft.DBforMySQL/flexibleServers/databases@2023-06-30' = {
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
