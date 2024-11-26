metadata name = 'DBforPostgreSQL Flexible Server Administrators'
metadata description = 'This module deploys a DBforPostgreSQL Flexible Server Administrator.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Specifies the state of the Threat Protection, whether it is enabled or disabled or a state has not been applied yet on the specific server.')
param serverThreatProtection string

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2024-08-01' existing = {
  name: flexibleServerName
}

resource flexibleServer_advancedThreatProtection 'Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings@2024-08-01' = {
  name: 'PostgreSQL-Threat'
  parent: flexibleServer
  properties: {
    state: serverThreatProtection
  }
}

@description('The resource group of the deployed administrator.')
output resourceGroupName string = resourceGroup().name
