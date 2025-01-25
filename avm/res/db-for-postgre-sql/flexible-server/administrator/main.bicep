metadata name = 'DBforPostgreSQL Flexible Server Administrators'
metadata description = 'This module deploys a DBforPostgreSQL Flexible Server Administrator.'

@description('Conditional. The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Required. The objectId of the Active Directory administrator.')
param objectId string

@description('Required. Active Directory administrator principal name.')
param principalName string

@allowed([
  'Group'
  'ServicePrincipal'
  'Unknown'
  'User'
])
@description('Required. The principal type used to represent the type of Active Directory Administrator.')
param principalType string

@description('Optional. The tenantId of the Active Directory administrator.')
param tenantId string = tenant().tenantId

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2024-08-01' existing = {
  name: flexibleServerName
}

resource administrator 'Microsoft.DBforPostgreSQL/flexibleServers/administrators@2024-08-01' = {
  name: objectId
  parent: flexibleServer
  properties: {
    principalName: principalName
    principalType: principalType
    tenantId: tenantId
  }
}

@description('The name of the deployed administrator.')
output name string = administrator.name

@description('The resource ID of the deployed administrator.')
output resourceId string = administrator.id

@description('The resource group of the deployed administrator.')
output resourceGroupName string = resourceGroup().name
