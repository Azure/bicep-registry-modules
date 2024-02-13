metadata name = 'Management Groups'
metadata description = '''This template will prepare the management group structure based on the provided parameter.

This module has some known **limitations**:
- It's not possible to change the display name of the root management group (the one that has the tenant GUID as ID)
- It can't manage the Root (/) management group'''
metadata owner = 'Azure/module-maintainers'

targetScope = 'managementGroup'

@description('Required. The group ID of the Management group.')
param name string

@description('Optional. The friendly name of the management group. If no value is passed then this field will be set to the group ID.')
param displayName string = ''

@description('Optional. The management group parent ID. Defaults to current scope.')
param parentId string = last(split(az.managementGroup().id, '/'))!

@description('Optional. Location deployment metadata.')
param location string = deployment().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource parentManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: parentId
  scope: tenant()
}

resource managementGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: name
  scope: tenant()
  properties: {
    displayName: displayName
    details: !empty(parentId) ? {
      parent: {
        id: parentManagementGroup.id
      }
    } : null
  }
}

@description('The name of the management group.')
output name string = managementGroup.name

@description('The resource ID of the management group.')
output resourceId string = managementGroup.id
