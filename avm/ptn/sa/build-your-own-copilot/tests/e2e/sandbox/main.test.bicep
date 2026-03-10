targetScope = 'subscription'

metadata name = 'Sandbox configuration with default parameter values'
metadata description = 'This instance deploys the Build Your Own Copilot Solution Accelerator using only the required parameters. Optional parameters will take the default values, which are designed for Sandbox environments.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'byoc-min'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sa.ca-${serviceShort}-rg'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //
#disable-next-line no-hardcoded-location // A value to avoid ongoing capacity challenges with Server Farm for frontend webapp in AVM Azure testing subscription
var enforcedLocation = 'australiaeast'

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
      solutionName: take('${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}', 15)
      azureAiServiceLocation: enforcedLocation
      enablePrivateNetworking: false
      enableMonitoring: false
      enablePurgeProtection: false
      enableRedundancy: false
      enableScalability: false
      enableTelemetry: true
    }
  }
]
