targetScope = 'subscription'

metadata name = 'Cassandra Keyspaces - WAF-aligned'
metadata description = 'This instance deploys the module with Cassandra Keyspaces in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddacswaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// The default pipeline is selecting random regions which don't have capacity for Azure Cosmos DB or support all Azure Cosmos DB features when creating new accounts.
#disable-next-line no-hardcoded-location
var enforcedLocation = 'eastus2'
#disable-next-line no-hardcoded-location
var enforcedSecondLocation = 'westus2'

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// ============ //
// Dependencies //
// ============ //

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
  }
}

// ============ //
// Diagnostics
// ============ //
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
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
      enableAnalyticalStorage: true
      backupPolicyType: 'Periodic'
      capabilitiesToAdd: [
        'EnableCassandra'
      ]
      tags: {
        environment: 'production'
        role: 'validation'
        type: 'waf-aligned-cassandra'
      }
      failoverLocations: [
        {
          failoverPriority: 0
          isZoneRedundant: false
          locationName: enforcedLocation
        }
        {
          failoverPriority: 1
          isZoneRedundant: false
          locationName: enforcedSecondLocation
        }
      ]
      enableAutomaticFailover: true
      minimumTlsVersion: 'Tls12'
      disableLocalAuthentication: true
      disableKeyBasedMetadataWriteAccess: true
      networkRestrictions: {
        networkAclBypass: 'None'
        publicNetworkAccess: 'Disabled'
      }
      diagnosticSettings: [
        {
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      privateEndpoints: [
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          service: 'Cassandra'
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
        }
      ]
      cassandraKeyspaces: [
        {
          name: '${namePrefix}-cks-${serviceShort}-001'
          throughput: 1000
          tables: [
            {
              name: 'secure_orders'
              analyticalStorageTtl: 86400
              defaultTtl: 7200
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
                    orderBy: 'Desc'
                  }
                  {
                    name: 'order_id'
                    orderBy: 'Asc'
                  }
                ]
              }
            }
          ]
        }
        {
          name: '${namePrefix}-cks-${serviceShort}-002'
          autoscaleSettingsMaxThroughput: 4000
          tables: [
            {
              name: 'secure_users'
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
                    orderBy: 'Desc'
                  }
                ]
              }
            }
          ]
        }
      ]
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
