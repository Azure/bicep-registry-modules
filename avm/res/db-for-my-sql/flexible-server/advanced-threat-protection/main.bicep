metadata name = 'DBforMySQL Flexible Server Advanced Threat Protection'
metadata description = 'This module enables Advanced Threat Protection for DBforMySQL Flexible Server.'

@description('Conditional. The name of the parent DBforMySQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Optional. The state of the advanced threat protection.')
@allowed([
  'Enabled'
  'Disabled'
])
param advancedThreatProtection string = 'Enabled'

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' existing = {
  name: flexibleServerName
}

resource advancedThreatProtectionSettings 'Microsoft.DBforMySQL/flexibleServers/advancedThreatProtectionSettings@2023-12-30' = {
  parent: flexibleServer
  name: 'Default'
  properties: {
    state: advancedThreatProtection
  }
}

@description('The name of the deployed threat protection.')
output name string = advancedThreatProtectionSettings.name

@description('The resource ID of the deployed threat protection.')
output resourceId string = advancedThreatProtectionSettings.id

@description('The resource group of the deployed threat protection.')
output resourceGroupName string = resourceGroup().name
