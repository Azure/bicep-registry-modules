targetScope = 'subscription'

metadata name = 'Multi resource group'
metadata description = 'This instance deploys the module leveraging virtual machine and maintenance configuration dependencies from two different resource groups. This instance assigns an existing Linux virtual machine to the input maintenance configuration.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-maintenance.maintenanceconfigurations-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mcamrg'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

// General resources
// =================
resource resourceGroup_vm 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

resource resourceGroup_mc 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'dep-${namePrefix}-maintenance.maintenanceconfigurations-${serviceShort}-mc-rg'
  location: enforcedLocation
}

module nestedDependencies_vm 'dependencies_vm.bicep' = {
  scope: resourceGroup_vm
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies_vm'
  params: {
    virtualMachineName: 'dep-${namePrefix}-vm-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: enforcedLocation
  }
}

module nestedDependencies_mc 'dependencies_mc.bicep' = {
  scope: resourceGroup_vm
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies_mc'
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
    scope: resourceGroup_vm
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      maintenanceConfigurationResourceId: nestedDependencies_mc.outputs.maintenanceConfigurationResourceId
      resourceId: nestedDependencies_vm.outputs.virtualMachineResourceId
    }
  }
]
