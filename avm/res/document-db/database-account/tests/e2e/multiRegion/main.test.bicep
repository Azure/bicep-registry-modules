targetScope = 'subscription'

metadata name = 'Deploying multiple regions'
metadata description = 'This instance deploys the module in multiple regions with configs specific of multi region scenarios.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddaumr'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// The default pipeline is selecting random regions which don't have capacity for Azure Cosmos DB or support all Azure Cosmos DB features when creating new accounts.
#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'
#disable-next-line no-hardcoded-location
var enforcedPairedLocation = 'uksouth'

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
    automaticFailover: false
    location: enforcedLocation
    backupPolicyType: 'Periodic'
    backupIntervalInMinutes: 300
    backupStorageRedundancy: 'Zone'
    backupRetentionIntervalInHours: 16
    enableMultipleWriteLocations: true
    name: '${namePrefix}-multi-region'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: true
        locationName: enforcedLocation
      }
      {
        failoverPriority: 1
        isZoneRedundant: true
        locationName: enforcedPairedLocation
      }
    ]
    sqlDatabases: [
      {
        name: 'no-containers-specified'
      }
    ]
  }
}
