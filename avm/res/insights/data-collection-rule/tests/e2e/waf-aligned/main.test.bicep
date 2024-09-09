targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    location: resourceLocation
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
      location: resourceLocation
      dataCollectionRuleProperties: {
        kind: 'Windows'
        description: 'Collecting Windows-specific performance counters and Windows Event Logs'
        dataSources: {
          performanceCounters: [
            {
              name: 'perfCounterDataSource60'
              samplingFrequencyInSeconds: 60
              streams: [
                'Microsoft-InsightsMetrics'
              ]
              counterSpecifiers: [
                '\\Processor Information(_Total)\\% Processor Time'
                '\\Processor Information(_Total)\\% Privileged Time'
                '\\Processor Information(_Total)\\% User Time'
                '\\Processor Information(_Total)\\Processor Frequency'
                '\\System\\Processes'
                '\\Process(_Total)\\Thread Count'
                '\\Process(_Total)\\Handle Count'
                '\\System\\System Up Time'
                '\\System\\Context Switches/sec'
                '\\System\\Processor Queue Length'
                '\\Memory\\% Committed Bytes In Use'
                '\\Memory\\Available Bytes'
                '\\Memory\\Committed Bytes'
                '\\Memory\\Cache Bytes'
                '\\Memory\\Pool Paged Bytes'
                '\\Memory\\Pool Nonpaged Bytes'
                '\\Memory\\Pages/sec'
                '\\Memory\\Page Faults/sec'
                '\\Process(_Total)\\Working Set'
                '\\Process(_Total)\\Working Set - Private'
                '\\LogicalDisk(_Total)\\% Disk Time'
                '\\LogicalDisk(_Total)\\% Disk Read Time'
                '\\LogicalDisk(_Total)\\% Disk Write Time'
                '\\LogicalDisk(_Total)\\% Idle Time'
                '\\LogicalDisk(_Total)\\Disk Bytes/sec'
                '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
                '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
                '\\LogicalDisk(_Total)\\Disk Transfers/sec'
                '\\LogicalDisk(_Total)\\Disk Reads/sec'
                '\\LogicalDisk(_Total)\\Disk Writes/sec'
                '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
                '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
                '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
                '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
                '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
                '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
                '\\LogicalDisk(_Total)\\% Free Space'
                '\\LogicalDisk(_Total)\\Free Megabytes'
                '\\Network Interface(*)\\Bytes Total/sec'
                '\\Network Interface(*)\\Bytes Sent/sec'
                '\\Network Interface(*)\\Bytes Received/sec'
                '\\Network Interface(*)\\Packets/sec'
                '\\Network Interface(*)\\Packets Sent/sec'
                '\\Network Interface(*)\\Packets Received/sec'
                '\\Network Interface(*)\\Packets Outbound Errors'
                '\\Network Interface(*)\\Packets Received Errors'
              ]
            }
          ]
          windowsEventLogs: [
            {
              name: 'eventLogsDataSource'
              streams: [
                'Microsoft-Event'
              ]
              xPathQueries: [
                'Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
                'Security!*[System[(band(Keywords,13510798882111488))]]'
                'System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
              ]
            }
          ]
        }
        destinations: {
          azureMonitorMetrics: {
            name: 'azureMonitorMetrics-default'
          }
          logAnalytics: [
            {
              workspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
              name: nestedDependencies.outputs.logAnalyticsWorkspaceName
            }
          ]
        }
        dataFlows: [
          {
            streams: [
              'Microsoft-InsightsMetrics'
            ]
            destinations: [
              'azureMonitorMetrics-default'
            ]
          }
          {
            streams: [
              'Microsoft-Event'
            ]
            destinations: [
              nestedDependencies.outputs.logAnalyticsWorkspaceName
            ]
          }
        ]
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        resourceType: 'Data Collection Rules'
        kind: 'Windows'
      }
    }
  }
]
