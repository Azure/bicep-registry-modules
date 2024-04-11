targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'NetworkWatcherRG' // Note, this is the default NetworkWatcher resource group. Do not change.

@description('Optional. The location to deploy resources to.')
#disable-next-line no-unused-params // A rotation location cannot be used for this test as NetworkWatcher Resource Groups are created for any test location automatically
param resourceLocation string = deployment().location

@description('Optional. The static location of the resource group & resources.') // Note, we set the location of the NetworkWatcherRG to avoid conflicts with the already existing NetworkWatcherRG
param tempLocation string = 'uksouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nnwmin'

#disable-next-line no-unused-params
@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: tempLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, tempLocation)}-test-${serviceShort}-${iteration}'
  params: {
    // Note: This value is not required and only set to enable testing
    location: tempLocation
  }
}]
