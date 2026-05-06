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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.dbformysql-flexisrv-advdthreatprot.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2024-12-30' existing = {
  name: flexibleServerName
}

resource advancedThreatProtectionSettings 'Microsoft.DBforMySQL/flexibleServers/advancedThreatProtectionSettings@2024-12-30' = {
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
