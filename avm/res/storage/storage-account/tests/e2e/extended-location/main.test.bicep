targetScope = 'subscription'

metadata name = 'Using extended zones'
metadata description = '''
This instance deploys the module within an Azure Extended Zone.

> Note: To run a deployment with an extended location, the subscription must be registered for the feature. For example:
> ```pwsh
> az provider register --namespace 'Microsoft.EdgeZones'
> az edge-zones extended-zone register --extended-zone-name 'losangeles'
> ```
> Please refer to the [documentation](https://learn.microsoft.com/en-us/azure/extended-zones/request-access) for more information.
'''

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-storage.storageaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssaexzn'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// This test specifically tests an extended location that is restricted to certain regions based on support
// Hardcoding the location and extended zone here to ensure the test is able to run
var enforcedLocation = 'westus'
var extendedZone = 'losangeles'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
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
      extendedLocationZone: extendedZone
      kind: 'StorageV2'
      skuName: 'Premium_LRS'
      allowBlobPublicAccess: false
    }
  }
]
