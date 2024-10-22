targetScope = 'subscription'

metadata name = 'Plain'
metadata description = 'This instance deploys the module without a Database.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddapln'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// The default pipeline is selecting random regions which don't have capacity for Azure Cosmos DB or support all Azure Cosmos DB features when creating new accounts.
#disable-next-line no-hardcoded-location
var enforcedLocation = 'eastus2'

// ============== //
// General resources
// ============== //
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
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
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      disableLocalAuth: true
      backupPolicyType: 'Continuous'
      disableKeyBasedMetadataWriteAccess: true
      defaultConsistencyLevel: 'ConsistentPrefix'
      backupPolicyContinuousTier: 'Continuous7Days'
      locations: [
        {
          failoverPriority: 0
          isZoneRedundant: false
          locationName: enforcedLocation
        }
      ]
      sqlDatabases: [
        {
          name: 'no-containers-specified'
        }
      ]
    }
  }
]
