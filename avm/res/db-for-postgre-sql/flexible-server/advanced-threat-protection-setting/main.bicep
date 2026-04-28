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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.dbforpostgresql-flexisrv-adthprotstg.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2026-01-01-preview' existing = {
  name: flexibleServerName
}

resource flexibleServer_advancedThreatProtection 'Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings@2026-01-01-preview' = {
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
