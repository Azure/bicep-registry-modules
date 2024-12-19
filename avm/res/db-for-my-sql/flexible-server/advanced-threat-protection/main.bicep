metadata name = 'DBforMySQL Flexible Server Advanced Threat Protection'
metadata description = 'This module enables Advanced Threat Protection for DBforMySQL Flexible Server.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent DBforMySQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' existing = {
  name: flexibleServerName
}

resource advancedThreatProtection 'Microsoft.DBforMySQL/flexibleServers/advancedThreatProtectionSettings@2023-12-30' = {
  parent: flexibleServer
  name: 'Default'
  properties: {
    state: 'Enabled'
  }
}

@description('The name of the deployed administrator.')
output name string = advancedThreatProtection.name

@description('The resource ID of the deployed administrator.')
output resourceId string = advancedThreatProtection.id

@description('The resource group of the deployed administrator.')
output resourceGroupName string = resourceGroup().name
