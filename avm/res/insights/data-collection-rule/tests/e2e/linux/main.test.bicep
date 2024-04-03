targetScope = 'subscription'

metadata name = 'Collecting Linux-specific information'
metadata description = 'This instance deploys the module to setup the collection of Linux-specific performance counters and Linux Syslog.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-insights.dataCollectionRules-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'idcrlin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
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
      description: 'Collecting Linux-specific performance counters and Linux Syslog'
      dataSources: {
        performanceCounters: [
          {
            name: 'perfCounterDataSource60'
            samplingFrequencyInSeconds: 60
            streams: [
              'Microsoft-InsightsMetrics'
            ]
            counterSpecifiers: [
              'Processor(*)\\% Processor Time'
              'Processor(*)\\% Idle Time'
              'Processor(*)\\% User Time'
              'Processor(*)\\% Nice Time'
              'Processor(*)\\% Privileged Time'
              'Processor(*)\\% IO Wait Time'
              'Processor(*)\\% Interrupt Time'
              'Processor(*)\\% DPC Time'
              'Memory(*)\\Available MBytes Memory'
              'Memory(*)\\% Available Memory'
              'Memory(*)\\Used Memory MBytes'
              'Memory(*)\\% Used Memory'
              'Memory(*)\\Pages/sec'
              'Memory(*)\\Page Reads/sec'
              'Memory(*)\\Page Writes/sec'
              'Memory(*)\\Available MBytes Swap'
              'Memory(*)\\% Available Swap Space'
              'Memory(*)\\Used MBytes Swap Space'
              'Memory(*)\\% Used Swap Space'
              'Logical Disk(*)\\% Free Inodes'
              'Logical Disk(*)\\% Used Inodes'
              'Logical Disk(*)\\Free Megabytes'
              'Logical Disk(*)\\% Free Space'
              'Logical Disk(*)\\% Used Space'
              'Logical Disk(*)\\Logical Disk Bytes/sec'
              'Logical Disk(*)\\Disk Read Bytes/sec'
              'Logical Disk(*)\\Disk Write Bytes/sec'
              'Logical Disk(*)\\Disk Transfers/sec'
              'Logical Disk(*)\\Disk Reads/sec'
              'Logical Disk(*)\\Disk Writes/sec'
              'Network(*)\\Total Bytes Transmitted'
              'Network(*)\\Total Bytes Received'
              'Network(*)\\Total Bytes'
              'Network(*)\\Total Packets Transmitted'
              'Network(*)\\Total Packets Received'
              'Network(*)\\Total Rx Errors'
              'Network(*)\\Total Tx Errors'
              'Network(*)\\Total Collisions'
            ]
          }
        ]
        syslog: [
          {
            name: 'sysLogsDataSource-debugLevel'
            streams: [
              'Microsoft-Syslog'
            ]
            facilityNames: [
              'auth'
              'authpriv'
            ]
            logLevels: [
              'Debug'
              'Info'
              'Notice'
              'Warning'
              'Error'
              'Critical'
              'Alert'
              'Emergency'
            ]
          }
          {
            name: 'sysLogsDataSource-warningLevel'
            streams: [
              'Microsoft-Syslog'
            ]
            facilityNames: [
              'cron'
              'daemon'
              'mark'
              'kern'
              'local0'
            ]
            logLevels: [
              'Warning'
              'Error'
              'Critical'
              'Alert'
              'Emergency'
            ]
          }
          {
            name: 'sysLogsDataSource-errLevel'
            streams: [
              'Microsoft-Syslog'
            ]
            facilityNames: [
              'local1'
              'local2'
              'local3'
              'local4'
              'local5'
              'local6'
              'local7'
              'lpr'
              'mail'
              'news'
              'syslog'
            ]
            logLevels: [
              'Error'
              'Critical'
              'Alert'
              'Emergency'
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
            'Microsoft-Syslog'
          ]
          destinations: [
            nestedDependencies.outputs.logAnalyticsWorkspaceName
          ]
        }
      ]
      kind: 'Linux'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        resourceType: 'Data Collection Rules'
        kind: 'Linux'
      }
    }
  }
]
