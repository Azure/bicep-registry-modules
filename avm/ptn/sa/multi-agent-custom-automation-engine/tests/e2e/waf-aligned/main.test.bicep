targetScope = 'subscription'

metadata name = 'Default configuration with WAF aligned parameter values'
metadata description = 'This instance deploys the [Multi-Agent Custom Automation Engine solution accelerator](https://github.com/microsoft/Multi-Agent-Custom-Automation-Engine-Solution-Accelerator) using parameters that deploy the [WAF aligned](https://learn.microsoft.com/azure/well-architected/) configuration.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-wafaligned-${namePrefix}-sa.macae-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'macaewaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to set for the Virtual Machine.')
@secure()
param virtualMachineAdminPassword string = newGuid()

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
      solutionName: '${namePrefix}${serviceShort}'
      azureAiServiceLocation: enforcedLocation
      location: enforcedLocation
      enableMonitoring: true
      enablePrivateNetworking: true
      enableRedundancy: true
      enableScalability: true
      enableTelemetry: true
      virtualMachineAdminUsername: 'adminuser'
      virtualMachineAdminPassword: virtualMachineAdminPassword
    }
  }
]
