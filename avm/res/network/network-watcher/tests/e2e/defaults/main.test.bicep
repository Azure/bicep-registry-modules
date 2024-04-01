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
param resourcelocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nnwmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

#disable-next-line no-hardcoded-location // Disabled as the default RG & location are created in always one location, but each test has to deploy into a different one
var testLocation = 'westeurope'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: testLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, testLocation)}-test-${serviceShort}-${iteration}'
  params: {
    // Note: This value is not required and only set to enable testing
    location: testLocation
  }
}]
