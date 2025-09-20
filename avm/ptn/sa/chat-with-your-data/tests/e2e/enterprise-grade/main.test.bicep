metadata name = 'Default configuration with enterprise-grade parameter values'
metadata description = 'This test deploys the Chat with your data Solution Accelerator using parameters that deploy the enterprise-grade configuration.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-sa.cwyd-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
#disable-next-line no-unused-params // overridden below to avoid the allowed location list validation
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'scwydswaf'

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
      // You parameters go here
      solutionName: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      enableScalability: true
      enableTelemetry: true
      enableMonitoring: true
      enablePrivateNetworking: true
      enableRedundancy: true
      createdBy: 'AVM_Pipeline'
    }
  }
]
