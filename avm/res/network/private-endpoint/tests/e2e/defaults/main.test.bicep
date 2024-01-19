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
param resourceGroupName string = 'dep-${namePrefix}-network.privateendpoints-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'npemin'

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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: location
    subnetResourceId: nestedDependencies.outputs.subnetResourceId
    // Workaround for PSRule
    lock: {}
    roleAssignments: []
    applicationSecurityGroupResourceIds: []
    customNetworkInterfaceName: ''
    privateDnsZoneGroupName: ''
    ipConfigurations: []
    customDnsConfigs: []
    privateDnsZoneResourceIds: []
    manualPrivateLinkServiceConnections: []
    privateLinkServiceConnections: [
      {
        name: '${namePrefix}${serviceShort}001'
        properties: {
          privateLinkServiceId: nestedDependencies.outputs.keyVaultResourceId
          groupIds: [
            'vault'
          ]
        }
      }
    ]
    tags: {}
  }
}]
