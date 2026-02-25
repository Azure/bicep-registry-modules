targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework'

// ========== //
// Parameters //
// ========== //

@sys.description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sa.ccsa-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sccsawaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password used for VM authentication.')
@secure()
param virtualMachineAdminPassword string = newGuid()

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
      azureAiServiceLocation: enforcedLocation
      enableScalability: true
      enableTelemetry: true
      enableMonitoring: true
      enablePrivateNetworking: true
      enableRedundancy: true
      virtualMachineAdminUsername: 'adminuser'
      virtualMachineAdminPassword: virtualMachineAdminPassword
    }
  }
]
