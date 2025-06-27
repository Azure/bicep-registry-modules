targetScope = 'subscription'

metadata name = 'Default configuration with WAF aligned parameter values'
metadata description = 'This instance deploys the [Modernize Your Code Solution Accelerator](https://github.com/microsoft/Modernize-Your-Code-Solution-Accelerator) using parameters that deploy the WAF aligned configuration.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-waf-${namePrefix}-sa.moderncode-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
#disable-next-line no-unused-params // overridden below to avoid the allowed location list validation
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'samycwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-hardcoded-location // A value to avoid the allowed location list validation to unnecessarily fail
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
      solutionName: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      enableMonitoring: true
      enableRedundancy: true
      enableScaling: true
      enablePrivateNetworking: true
      azureAiServiceLocation: enforcedLocation
      vmAdminUsername: 'adminuser'
      vmAdminPassword: 'a#aoWui1fgha%sjna2sdf%h'
    }
  }
]
