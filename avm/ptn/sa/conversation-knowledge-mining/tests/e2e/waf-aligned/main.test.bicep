targetScope = 'subscription'

metadata name = 'WAF-aligned configuration with default parameter values'
metadata description = 'This instance deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator) using only the required parameters. Optional parameters will take the default values, which are designed for WAF-aligned environments.'

// ========== //
// Parameters //
// ========== //

@sys.description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sa.ckm-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sckmswaf'

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

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
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
      solutionName: take('${namePrefix}${serviceShort}001', 16)
      location: enforcedLocation
      aiServiceLocation: enforcedLocation
      secondaryLocation: enforcedLocation
      enableScalability: true
      enableTelemetry: true
      enableMonitoring: true
      enablePrivateNetworking: true
      enableRedundancy: true
      vmAdminUsername: 'adminuser'
      vmAdminPassword: vmAdminPassword
      usecase: 'telecom'
    }
  }
]
