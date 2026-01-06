targetScope = 'subscription'

metadata name = 'Public network restricted access with ACL'
metadata description = 'This instance deploys the module with public network access enabled but restricted to IPs, CIDRS or subnets.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddapres'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// The default pipeline is selecting random regions which don't have capacity for Azure Cosmos DB or support all Azure Cosmos DB features when creating new accounts.
#disable-next-line no-hardcoded-location
var enforcedLocation = 'westus3'

// ============ //
// Dependencies //
// ============ //

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// General resources
// ============== //
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    networkRestrictions: {
      publicNetworkAccess: 'Enabled'
      networkAclBypass: 'AzureServices'
      ipRules: ['79.0.0.0', '80.0.0.0']
      virtualNetworkRules: [
        {
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
        }
      ]
    }
    sqlDatabases: [
      {
        name: 'no-containers-specified'
      }
    ]
    zoneRedundant: false
  }
}
