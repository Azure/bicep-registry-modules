targetScope = 'subscription'

metadata name = 'Waf-aligned configuration with default parameter values'
metadata description = 'This instance deploys the Content Processing Solution Accelerator'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-waf-${namePrefix}-sa.cps-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints. Remove.')
param serviceShort string = 'scpeg'

param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //
#disable-next-line no-hardcoded-location // A value to avoid ongoing capacity challenges with Server Farm for frontend webapp in AVM Azure testing subscription
var enforcedLocation = 'swedencentral'

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
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      contentUnderstandingLocation: enforcedLocation
      environmentName: '${namePrefix}${serviceShort}'
      gptDeploymentCapacity: 1
      enableScaling: true
      enableTelemetry: true
      enablePrivateNetworking: true
    }
  }
]
