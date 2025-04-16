metadata name = 'Management Groups'
metadata description = '''This template will prepare the management group structure based on the provided parameter.

This module has some known **limitations**:
- It's not possible to change the display name of the root management group (the one that has the tenant GUID as ID)
- It can't manage the Root (/) management group'''

targetScope = 'managementGroup'

@description('Required. The group ID of the Management group.')
param name string

@description('Optional. The friendly name of the management group. If no value is passed then this field will be set to the group ID.')
param displayName string = ''

@description('Optional. The management group parent ID. Defaults to current scope.')
param parentId string = last(split(az.managementGroup().id, '/'))!

@description('Optional. Location deployment metadata.')
param location string = deployment().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.management-managementgroup.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
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

resource parentManagementGroup 'Microsoft.Management/managementGroups@2021-04-01' existing = {
  name: parentId
  scope: tenant()
}

resource managementGroup 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: name
  scope: tenant()
  properties: {
    displayName: displayName
    details: !empty(parentId)
      ? {
          parent: {
            id: parentManagementGroup.id
          }
        }
      : null
  }
}

@description('The name of the management group.')
output name string = managementGroup.name

@description('The resource ID of the management group.')
output resourceId string = managementGroup.id
