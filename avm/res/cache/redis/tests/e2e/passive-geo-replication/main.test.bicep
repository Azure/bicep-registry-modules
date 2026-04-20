targetScope = 'subscription'

metadata name = 'Passive Geo-Replicated Redis Cache'
metadata description = 'This instance deploys the module with geo-replication enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cache.redis-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'crpgeo'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
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
    location: nestedDependencies1.outputs.pairedRegionName
    redisName: 'dep-${namePrefix}-redis-sec-${serviceShort}'
  }
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
      capacity: 2
      enableNonSslPort: true
      minimumTlsVersion: '1.2'
      availabilityZones: []
      replicasPerPrimary: 1
      replicasPerMaster: 1
      geoReplicationObject: {
        linkedRedisCacheResourceId: nestedDependencies2.outputs.redisResourceId
        linkedRedisCacheLocation: nestedDependencies2.outputs.redisLocation
        name: nestedDependencies2.outputs.redisName
      }
      redisVersion: '6'
      shardCount: 1
      skuName: 'Premium'
    }
  }
]
