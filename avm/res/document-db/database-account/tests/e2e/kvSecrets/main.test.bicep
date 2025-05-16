targetScope = 'subscription'

metadata name = 'Deploying with a key vault reference to save secrets'
metadata description = 'This instance deploys the module saving all its secrets in a key vault.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddaskvs'

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

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}-kv-ref'
    zoneRedundant: false
  }
}

// ============== //
// Usage          //
// ============== //

module keyVault 'br/public:avm/res/key-vault/vault:0.12.1' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-kv'
  params: {
    name: '${namePrefix}-kv'
    enablePurgeProtection: false
    enableRbacAuthorization: true
    secrets: [
      {
        name: 'primaryReadOnlyKey'
        value: testDeployment.outputs.primaryReadOnlyKey
      }
      {
        name: 'primaryReadWriteKey'
        value: testDeployment.outputs.primaryReadWriteKey
      }
      {
        name: 'primaryReadOnlyConnectionString'
        value: testDeployment.outputs.primaryReadOnlyConnectionString
      }
      {
        name: 'primaryReadWriteConnectionString'
        value: testDeployment.outputs.primaryReadWriteConnectionString
      }
      {
        name: 'secondaryReadOnlyConnectionString'
        value: testDeployment.outputs.secondaryReadOnlyConnectionString
      }
      {
        name: 'secondaryReadOnlyKey'
        value: testDeployment.outputs.secondaryReadOnlyKey
      }
      {
        name: 'secondaryReadWriteConnectionString'
        value: testDeployment.outputs.secondaryReadWriteConnectionString
      }
      {
        name: 'secondaryReadWriteKey'
        value: testDeployment.outputs.secondaryReadWriteKey
      }
    ]
  }
}
