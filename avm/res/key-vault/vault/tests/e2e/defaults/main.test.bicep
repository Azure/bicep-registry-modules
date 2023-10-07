targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = '''
This instance deploys the module with the minimum set of required parameters.
> **Note:** The test currently implements additional non-required parameters to cater for a test-specific limitation.
'''

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-keyvault.vaults-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'kvvd'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}002'
    location: location
    // Only for testing purposes
    enablePurgeProtection: false
    // Workaround for PSRule
    lock: null
    roleAssignments: null
    diagnosticSettings: null
    privateEndpoints: null
    accessPolicies: null
    secrets: null
    keys: null
    tags: null
  }
}
