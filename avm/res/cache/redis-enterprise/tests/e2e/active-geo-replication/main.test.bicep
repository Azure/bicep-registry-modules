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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    redisClusterName: '${namePrefix}${serviceShort}001'
    location: enforcedLocation
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
      database: {
        geoReplication: {
          groupNickname: nestedDependencies.outputs.geoReplicationGroupName
          linkedDatabases: [
            {
              id: nestedDependencies.outputs.redisDbResourceId
            }
            {
              id: '${resourceGroup.id}/providers/Microsoft.Cache/redisEnterprise/${namePrefix}${serviceShort}002/databases/default'
            }
          ]
        }
      }
    }
  }
]
