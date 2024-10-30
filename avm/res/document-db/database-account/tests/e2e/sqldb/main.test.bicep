targetScope = 'subscription'

metadata name = 'SQL Database'
metadata description = 'This instance deploys the module with a SQL Database.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddasql'

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
    location: enforcedLocation
    enableAnalyticalStorage: true
    name: '${namePrefix}${serviceShort}001'
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: enforcedLocation
      }
    ]
    sqlDatabases: [
      {
        containers: [
          {
            kind: 'Hash'
            name: 'container-001'
            indexingPolicy: {
              automatic: true
            }
            paths: [
              '/myPartitionKey'
            ]
            analyticalStorageTtl: 0
            conflictResolutionPolicy: {
              conflictResolutionPath: '/myCustomId'
              mode: 'LastWriterWins'
            }
            defaultTtl: 1000
            uniqueKeyPolicyKeys: [
              {
                paths: [
                  '/firstName'
                ]
              }
              {
                paths: [
                  '/lastName'
                ]
              }
            ]
            throughput: 600
          }
        ]
        name: 'all-configs-specified'
      }
      {
        containers: [
          {
            name: 'container-001'
            indexingPolicy: {
              automatic: true
            }
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'automatic-indexing-policy'
      }
      {
        containers: [
          {
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
            conflictResolutionPolicy: {
              conflictResolutionPath: '/myCustomId'
              mode: 'LastWriterWins'
            }
          }
        ]
        name: 'last-writer-conflict-resolution-policy'
      }
      {
        containers: [
          {
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
            analyticalStorageTtl: 1000
          }
        ]
        name: 'fixed-analytical-ttl'
      }
      {
        containers: [
          {
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
            analyticalStorageTtl: -1
          }
        ]
        name: 'infinite-analytical-ttl'
      }
      {
        containers: [
          {
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
            defaultTtl: 1000
          }
        ]
        name: 'document-ttl'
      }
      {
        containers: [
          {
            name: 'container-001'
            paths: [
              '/myPartitionKey'
            ]
            uniqueKeyPolicyKeys: [
              {
                paths: [
                  '/firstName'
                ]
              }
              {
                paths: [
                  '/lastName'
                ]
              }
            ]
          }
        ]
        name: 'unique-key-policy'
      }
      {
        containers: [
          {
            name: 'container-003'
            throughput: 500
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'db-and-container-fixed-throughput-level'
        throughput: 500
      }
      {
        containers: [
          {
            name: 'container-003'
            throughput: 500
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'container-fixed-throughput-level'
      }
      {
        containers: [
          {
            name: 'container-003'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'database-fixed-throughput-level'
        throughput: 500
      }
      {
        containers: [
          {
            name: 'container-003'
            autoscaleSettingsMaxThroughput: 1000
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'db-and-container-autoscale-level'
        autoscaleSettingsMaxThroughput: 1000
      }
      {
        containers: [
          {
            name: 'container-003'
            autoscaleSettingsMaxThroughput: 1000
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'container-autoscale-level'
      }
      {
        containers: [
          {
            name: 'container-003'
            paths: [
              '/myPartitionKey'
            ]
          }
        ]
        name: 'database-autoscale-level'
        autoscaleSettingsMaxThroughput: 1000
      }
      {
        containers: [
          {
            name: 'container-001'
            kind: 'MultiHash'
            paths: [
              '/myPartitionKey1'
              '/myPartitionKey2'
              '/myPartitionKey3'
            ]
          }
          {
            name: 'container-002'
            kind: 'MultiHash'
            paths: [
              'myPartitionKey1'
              'myPartitionKey2'
              'myPartitionKey3'
            ]
          }
          {
            name: 'container-003'
            kind: 'Hash'
            paths: [
              '/myPartitionKey1'
            ]
          }
          {
            name: 'container-004'
            kind: 'Hash'
            paths: [
              'myPartitionKey1'
            ]
          }
          {
            name: 'container-005'
            kind: 'Hash'
            version: 2
            paths: [
              'myPartitionKey1'
            ]
          }
        ]
        name: 'all-partition-key-types'
      }
      {
        containers: []
        name: 'empty-containers-array'
      }
      {
        name: 'no-containers-specified'
      }
    ]
  }
}
