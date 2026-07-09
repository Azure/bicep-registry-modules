metadata name = 'DBforMySQL Flexible Server Configurations'
metadata description = 'This module deploys a DBforMySQL Flexible Server Configuration.'

@description('Required. The name of the configuration.')
param name string

@description('Conditional. The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Optional. Source of the configuration.')
@allowed([
  'system-default'
  'user-override'
])
param source string?

@description('Optional. Value of the configuration.')
param value string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.dbformysql-flexisrv-configuration.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource configuration 'Microsoft.DBforMySQL/flexibleServers/configurations@2024-12-30' = {
  name: name
  parent: flexibleServer
  properties: {
    source: source
    value: value
  }
}

@description('The name of the deployed configuration.')
output name string = configuration.name

@description('The resource ID of the deployed configuration.')
output resourceId string = configuration.id

@description('The resource group name of the deployed configuration.')
output resourceGroupName string = resourceGroup().name
