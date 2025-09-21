targetScope = 'subscription'

metadata name = 'Waf-aligned configuration with default parameter values'
metadata description = 'This instance deploys the Build Your Own Copilot Solution Accelerator'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-waf-${namePrefix}-sa.byoc-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints. Remove.')
param serviceShort string = 'byoc-waf'

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
name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
params: {
azureAiServiceLocation: enforcedLocation
enablePrivateNetworking: true
enableMonitoring: true
enablePurgeProtection: true
enableRedundancy: true
enableScalability: true
enableTelemetry: true
vmAdminUsername: 'adminuser'
vmAdminPassword: virtualMachineAdminPassword
}
}
]
