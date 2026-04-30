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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.dbforpostgresql-flexisrv-admin.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource administrator 'Microsoft.DBforPostgreSQL/flexibleServers/administrators@2026-01-01-preview' = {
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
