metadata name = 'Sandbox configuration with default parameter values'
metadata description = 'This test deploys the sandbox configuration for Document Knowledge Mining Solution Accelerator with default parameters.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sa-dkm-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sdkmsmin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-hardcoded-location // A value to avoid the allowed location list validation to unnecessarily fail
var enforcedLocation = 'australiaeast'

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
      // You parameters go here
      // name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      aiDeploymentsLocation: enforcedLocation
      enablePrivateNetworking: false
      enableMonitoring: false
      enableRedundancy: false
      enableScalability: false
      enableTelemetry: true
      createdBy: 'AVM_Pipeline'
    }
  }
]
