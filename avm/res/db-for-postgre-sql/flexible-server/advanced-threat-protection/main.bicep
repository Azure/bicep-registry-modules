metadata name = 'DBforPostgreSQL Flexible Server Advanced Threat Protection'
metadata description = 'This module deploys a DBforPostgreSQL Advanced Threat Protection.'

@description('Conditional. The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@allowed([
  'Disabled'
  'Enabled'
])
@description('Required. Specifies the state of the Threat Protection, whether it is enabled or disabled or a state has not been applied yet on the specific server.')
param serverThreatProtection string

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2024-08-01' existing = {
  name: flexibleServerName
}

resource flexibleServer_advancedThreatProtection 'Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings@2024-08-01' = {
  name: 'PostgreSQL-advancedThreatProtection'
  parent: flexibleServer
  properties: {
    state: serverThreatProtection
  }
}

@description('The resource id of the advanced threat protection state for the flexible server.')
output name string = flexibleServer_advancedThreatProtection.name

@description('The resource id of the advanced threat protection state for the flexible server.')
output resourceId string = flexibleServer_advancedThreatProtection.id

@description('The advanced threat protection state for the flexible server.')
output advancedTreatProtectionState string = flexibleServer_advancedThreatProtection.properties.state

@description('The resource group of the deployed administrator.')
output resourceGroupName string = resourceGroup().name
