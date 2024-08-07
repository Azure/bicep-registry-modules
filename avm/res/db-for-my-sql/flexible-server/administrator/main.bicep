metadata name = 'DBforMySQL Flexible Server Administrators'
metadata description = 'This module deploys a DBforMySQL Flexible Server Administrator.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent DBforMySQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Required. SID (object ID) of the server administrator.')
param sid string

@description('Required. The resource ID of the identity used for AAD Authentication.')
param identityResourceId string

@description('Required. Login name of the server administrator.')
param login string

@description('Optional. The tenantId of the Active Directory administrator.')
param tenantId string = tenant().tenantId

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' existing = {
  name: flexibleServerName
}

resource administrator 'Microsoft.DBforMySQL/flexibleServers/administrators@2023-06-30' = {
  name: 'ActiveDirectory'
  parent: flexibleServer
  properties: {
    administratorType: 'ActiveDirectory'
    identityResourceId: identityResourceId
    login: login
    sid: sid
    tenantId: tenantId
  }
}

@description('The name of the deployed administrator.')
output name string = administrator.name

@description('The resource ID of the deployed administrator.')
output resourceId string = administrator.id

@description('The resource group of the deployed administrator.')
output resourceGroupName string = resourceGroup().name
