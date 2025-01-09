targetScope = 'subscription'

metadata name = 'Active geo-replication'
metadata description = 'This instance deploys the module with active geo-replication enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cache-redisenterprise-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'creagr'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The name of the geo-replication group.')
param geoReplicationGroupName string = 'geo-replication-group'

@description('Optional. The zones to deploy resources to.')
param zones array = [
  1
  2
  3
]

// ============ //
// Variables    //
// ============ //
var redisName1 = '${namePrefix}${serviceShort}001'
var redisName2 = '${namePrefix}${serviceShort}002'

// Not all regions support zone-redundancy, so hardcoding 2 zone-enabled locations here
#disable-next-line no-hardcoded-location
var enforcedLocation = 'northeurope'
#disable-next-line no-hardcoded-location
var enforcedPairedLocation = 'uksouth'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies1 'dependencies1.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies1'
  params: {
    location: enforcedLocation
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    pairedRegionScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
  }
}

module nestedDependencies2 'dependencies2.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies2'
  params: {
    location: enforcedLocation
    geoReplicationGroupName: geoReplicationGroupName
    redisName: redisName1
    zones: zones
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedPairedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}002'
      location: enforcedPairedLocation
      geoReplication: {
        groupNickname: geoReplicationGroupName
        linkedDatabases: [
          {
            id: nestedDependencies2.outputs.redisDbResourceId
          }
          {
            id: '${resourceGroup.id}/providers/Microsoft.Cache/redisEnterprise/${redisName2}/databases/default'
          }
        ]
      }
      zones: zones
    }
  }
]
