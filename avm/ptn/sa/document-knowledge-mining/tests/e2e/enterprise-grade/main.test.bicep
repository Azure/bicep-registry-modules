metadata name = 'Default configuration with enterprise-grade parameter values'
metadata description = 'This test deploys the Document Knowledge Mining Solution Accelerator using parameters that deploy the enterprise-grade configuration.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sa-dkm-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sdkmswaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password used for VM authentication.')
@secure()
param vmAdminPassword string = newGuid()

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-hardcoded-location // A value to avoid the allowed location list validation to unnecessarily fail
var enforcedLocation = 'australiaeast'

#disable-next-line no-hardcoded-location
var enforcedCosmosReplicaLocation = 'canadacentral'

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
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
      location: enforcedLocation
      aiDeploymentsLocation: enforcedLocation
      cosmosReplicaLocation: enforcedCosmosReplicaLocation
      enablePrivateNetworking: true
      enableMonitoring: true
      enableRedundancy: true
      enableScalability: true
      enableTelemetry: true
      vmAdminUsername: 'adminuser'
      vmAdminPassword: vmAdminPassword
      createdBy: 'AVM_Pipeline'
    }
  }
]
