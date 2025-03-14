targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-maintenance.maintenanceconfigurations-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mmcmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

// General resources
// =================

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: 'dep-avmx-compute.virtualMachines-cvmwinwaf-rg'
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
      location: enforcedLocation
      maintenanceConfigurationResourceId: '/subscriptions/cfa4dc0b-3d25-4e58-a70a-7085359080c5/resourcegroups/dep-avmx-compute.virtualmachines-cvmwinwaf-rg/providers/microsoft.maintenance/maintenanceconfigurations/dep-avmx-mc-cvmwinwaf'
      resourceId: '/subscriptions/cfa4dc0b-3d25-4e58-a70a-7085359080c5/resourceGroups/dep-avmx-compute.virtualmachines-cvmwinwaf-rg/providers/Microsoft.Compute/virtualMachines/avmxcvmwinwaf'
    }
  }
]
