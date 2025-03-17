metadata name = 'Maintenance Configuration Assignments'
metadata description = 'This module deploys a Maintenance Configuration Assignment.'

// ============== //
//   Parameters   //
// ============== //

@description('Required. Maintenance configuration assignment Name.')
param name string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. The maintenance configuration resource ID.')
param maintenanceConfigurationResourceId string

@description('Optional. The unique resource ID to assign the configuration to.')
param filter filterType?

@description('Optional. The unique resource ID to assign the configuration to.')
param resourceId string?

// =============== //
//   Deployments   //
// =============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.maintenance-configurationassignment.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' existing = if (resourceId != null || !empty(resourceId)) {
  name: last(split(resourceId!, '/'))!
  // scope: resourceGroup(split(resourceId!, '/')[2], split(resourceId!, '/')[4])
}

resource configurationAssignment 'Microsoft.Maintenance/configurationAssignments@2023-04-01' = if (resourceId != null || !empty(resourceId)) {
  scope: vm
  // scope: resourceGroup(split(resourceId!, '/')[2], split(resourceId!, '/')[4])
  location: location
  name: name
  properties: {
    // filter: filter
    maintenanceConfigurationId: maintenanceConfigurationResourceId
    // resourceId: resourceId
    resourceId: vm.id
  }
}

resource configurationAssignment_dynamic 'Microsoft.Maintenance/configurationAssignments@2023-04-01' = if (resourceId == null || empty(resourceId)) {
  location: location
  name: name
  properties: {
    filter: filter
    maintenanceConfigurationId: maintenanceConfigurationResourceId
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The name of the Maintenance configuration assignment.')
output name string = configurationAssignment.name ?? configurationAssignment_dynamic.name

@description('The resource ID of the Maintenance configuration assignment.')
output resourceId string = configurationAssignment.id ?? configurationAssignment_dynamic.id

@description('The name of the resource group the Maintenance configuration assignment was created in.')
output resourceGroupName string = resourceGroup().name

// @description('The location the Maintenance configuration assignment was created in.')
// output location string = configurationAssignment.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for a managed configuration dynamic assignment filter.')
type filterType = {
  @description('Optional. List of allowed resource group names.')
  resourceGroups: string[]?

  @description('Optional. List of allowed resource types.')
  resourceTypes: string[]?

  @description('Optional. List of locations to scope the query to.')
  locations: string[]?

  @description('Optional. List of allowed operating systems.')
  osTypes: ('Linux' | 'Windows')[]?

  @description('Optional. Tags to be applied on all resources/Resource Groups in this deployment.')
  tagSettings: object?
}
