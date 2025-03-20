targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters. This instance uses filters to define a dynamic scope and assign it to the input maintenance configuration. The dynamic scope will be resolved at run time. '

// ========== //
// Parameters //
// ========== //

@description('Optional. The location for all resources.')
param enforcedLocation string = deployment().location

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-maintenance.maintenanceconfigurations-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mcamin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// #disable-next-line no-hardcoded-location
// var enforcedLocation = 'uksouth'

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    maintenanceConfigurationName: 'dep-${namePrefix}-mc-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      maintenanceConfigurationResourceId: nestedDependencies.outputs.maintenanceConfigurationResourceId
      filter: {
        osTypes: [
          'Linux'
          'Windows'
        ]
        resourceTypes: [
          'Virtual Machines'
        ]
      }
    }
  }
]
