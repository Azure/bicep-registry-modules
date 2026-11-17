import { uniqueResourceName } from '../../../../../../../utilities/e2e-template-assets/functions/unique-resource-name.bicep'

targetScope = 'subscription'

metadata name = 'Active geo-replication'
metadata description = 'This instance deploys the module with active geo-replication enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cache-redisenterprise-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'creagr'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    redisClusterName: uniqueResourceName('${namePrefix}${serviceShort}001', resourceGroup.id, 63)
  }
}

// ============== //
// Test Execution //
// ============== //

var redisClusterName = uniqueResourceName('${namePrefix}${serviceShort}002', resourceGroup.id, 63)

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: redisClusterName
      skuName: 'Balanced_B10'
      database: {
        geoReplication: {
          groupNickname: nestedDependencies.outputs.geoReplicationGroupName
          linkedDatabases: [
            {
              id: nestedDependencies.outputs.redisDbResourceId
            }
            {
              id: '${resourceGroup.id}/providers/Microsoft.Cache/redisEnterprise/${redisClusterName}/databases/default'
            }
          ]
        }
      }
    }
  }
]
