metadata name = 'DBforPostgreSQL Flexible Server Administrators'
metadata description = 'This module deploys a DBforPostgreSQL Flexible Server Administrator.'
metadata owner = 'Azure/module-maintainers'

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

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' existing = {
  name: flexibleServerName
}

resource administrator 'Microsoft.DBforPostgreSQL/flexibleServers/administrators@2022-12-01' = {
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
