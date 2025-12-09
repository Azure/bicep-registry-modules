targetScope = 'subscription'

metadata name = 'Send data to Azure Storage or Event Hub (Preview)'
metadata description = 'This instance deploys the module to setup sending data to Azure Storage or Event Hub with Logs ingestion API using the AgentDirectToStore kind'

// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrad'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

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
    dataCollectionEndpointName: 'dep-${namePrefix}-dce-${serviceShort}'
    storageAccountName: take('dep${namePrefix}sa${uniqueString(deployment().name)}', 24)
    eventHubNamespaceName: 'dep-${namePrefix}-ehns-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      dataCollectionRuleProperties: {
        kind: 'AgentDirectToStore'
        description: 'Send data to Agent Direct Storage. Based on the example at https://learn.microsoft.com/en-us/azure/azure-monitor/vm/send-event-hubs-storage'
        dataSources: {
          performanceCounters: [
            {
              streams: [
                'Microsoft-Perf'
              ]
              samplingFrequencyInSeconds: 10
              counterSpecifiers: [
                '\\Process(_Total)\\Working Set - Private'
                '\\Memory\\% Committed Bytes In Use'
                '\\LogicalDisk(_Total)\\% Free Space'
                '\\Network Interface(*)\\Bytes Total/sec'
              ]
              name: 'perfCounterDataSource10'
            }
          ]
        }
        dataFlows: [
          {
            streams: [
              'Microsoft-Perf'
            ]
            destinations: [
              'myEh1'
              'blobNamedPerf'
              'tableNamedPerf'
            ]
          }
          {
            streams: [
              'Microsoft-Event'
            ]
            destinations: [
              'myEh1'
              'blobNamedPerf'
              'tableNamedPerf'
            ]
          }
        ]
        destinations: {
          storageBlobsDirect: [
            {
              storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId

              name: 'blobNamedPerf'
              containerName: nestedDependencies.outputs.storageContainerName
            }
          ]
          storageTablesDirect: [
            {
              storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
              name: 'tableNamedPerf'
              tableName: nestedDependencies.outputs.storageTableName
            }
          ]
          eventHubsDirect: [
            {
              eventHubResourceId: nestedDependencies.outputs.eventHubResourceId
              name: 'myEh1'
            }
          ]
        }
      }
    }
  }
]
