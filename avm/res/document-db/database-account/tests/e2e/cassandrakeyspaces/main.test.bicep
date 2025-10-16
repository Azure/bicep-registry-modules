targetScope = 'subscription'

metadata name = 'Cassandra Keyspaces'
metadata description = 'This instance deploys the module with Cassandra Keyspaces.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddacsk'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// The default pipeline is selecting random regions which don't have capacity for Azure Cosmos DB or support all Azure Cosmos DB features when creating new accounts.
#disable-next-line no-hardcoded-location
var enforcedLocation = 'eastus2'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
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
      enableAnalyticalStorage: true
      backupPolicyType: 'Periodic'
      capabilitiesToAdd: [
        'EnableCassandra'
      ]
      cassandraKeyspaces: [
        {
          name: '${namePrefix}-cks-${serviceShort}-001'
          throughput: 800
          tables: [
            {
              name: 'orders'
              analyticalStorageTtl: 86400
              defaultTtl: 3600
              schema: {
                columns: [
                  {
                    name: 'order_id'
                    type: 'uuid'
                  }
                  {
                    name: 'customer_id'
                    type: 'uuid'
                  }
                  {
                    name: 'order_date'
                    type: 'timestamp'
                  }
                  {
                    name: 'total_amount'
                    type: 'decimal'
                  }
                  {
                    name: 'status'
                    type: 'text'
                  }
                ]
                partitionKeys: [
                  {
                    name: 'customer_id'
                  }
                ]
                clusterKeys: [
                  {
                    name: 'order_date'
                    orderBy: 'desc'
                  }
                  {
                    name: 'order_id'
                    orderBy: 'asc'
                  }
                ]
              }
            }
            {
              name: 'products'
              autoscaleSettingsMaxThroughput: 1000
              analyticalStorageTtl: -1
              schema: {
                columns: [
                  {
                    name: 'product_id'
                    type: 'uuid'
                  }
                  {
                    name: 'category'
                    type: 'text'
                  }
                  {
                    name: 'name'
                    type: 'text'
                  }
                  {
                    name: 'price'
                    type: 'decimal'
                  }
                ]
                partitionKeys: [
                  {
                    name: 'category'
                  }
                ]
                clusterKeys: [
                  {
                    name: 'name'
                    orderBy: 'asc'
                  }
                ]
              }
            }
          ]
          views: [
            {
              name: 'completed_orders_view'
              viewDefinition: 'SELECT order_id, customer_id, order_date, total_amount FROM ${namePrefix}-cks-${serviceShort}-001.orders WHERE status = \'completed\''
              throughput: 400
            }
          ]
        }
        {
          name: '${namePrefix}-cks-${serviceShort}-002'
          autoscaleSettingsMaxThroughput: 4000
          tables: [
            {
              name: 'users'
              analyticalStorageTtl: -1
              schema: {
                columns: [
                  {
                    name: 'user_id'
                    type: 'uuid'
                  }
                  {
                    name: 'email'
                    type: 'text'
                  }
                  {
                    name: 'created_at'
                    type: 'timestamp'
                  }
                ]
                partitionKeys: [
                  {
                    name: 'user_id'
                  }
                ]
                clusterKeys: [
                  {
                    name: 'created_at'
                    orderBy: 'desc'
                  }
                ]
              }
            }
            {
              name: 'sessions'
              throughput: 600
              defaultTtl: 3600
              analyticalStorageTtl: -1
              schema: {
                columns: [
                  {
                    name: 'session_id'
                    type: 'uuid'
                  }
                  {
                    name: 'user_id'
                    type: 'uuid'
                  }
                  {
                    name: 'created_at'
                    type: 'timestamp'
                  }
                ]
                partitionKeys: [
                  {
                    name: 'user_id'
                  }
                ]
                clusterKeys: [
                  {
                    name: 'session_id'
                    orderBy: 'asc'
                  }
                ]
              }
            }
          ]
        }
      ]
      zoneRedundant: false
    }
  }
]

@secure()
output primaryReadOnlyKey string = testDeployment[0].outputs.primaryReadOnlyKey

@secure()
output primaryReadWriteKey string = testDeployment[0].outputs.primaryReadWriteKey

@secure()
output primaryReadOnlyConnectionString string = testDeployment[0].outputs.primaryReadOnlyConnectionString

@secure()
output primaryReadWriteConnectionString string = testDeployment[0].outputs.primaryReadWriteConnectionString

@secure()
output secondaryReadOnlyKey string = testDeployment[1].outputs.secondaryReadOnlyKey

@secure()
output secondaryReadWriteKey string = testDeployment[1].outputs.secondaryReadWriteKey

@secure()
output secondaryReadOnlyConnectionString string = testDeployment[1].outputs.secondaryReadOnlyConnectionString

@secure()
output secondaryReadWriteConnectionString string = testDeployment[1].outputs.secondaryReadWriteConnectionString
