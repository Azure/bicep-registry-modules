metadata name = 'Network Watchers'
metadata description = 'This module deploys a Network Watcher.'

@description('Optional. Name of the Network Watcher resource (hidden).')
@minLength(1)
param name string = 'NetworkWatcher_${location}'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array that contains the Connection Monitors.')
param connectionMonitors connectionMonitorType[]?

@description('Optional. Array that contains the Flow Logs.')
param flowLogs flowLogType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Network/networkWatchers@2024-05-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-networkwatcher.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource networkWatcher 'Microsoft.Network/networkWatchers@2024-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {}
}

resource networkWatcher_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: networkWatcher
}

resource networkWatcher_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(networkWatcher.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: networkWatcher
  }
]

module networkWatcher_connectionMonitors 'connection-monitor/main.bicep' = [
  for (connectionMonitor, index) in (connectionMonitors ?? []): {
    name: '${uniqueString(deployment().name, location)}-NW-ConnectionMonitor-${index}'
    params: {
      tags: tags
      endpoints: connectionMonitor.?endpoints
      name: connectionMonitor.name
      location: location
      networkWatcherName: networkWatcher.name
      testConfigurations: connectionMonitor.?testConfigurations
      testGroups: connectionMonitor.?testGroups
      workspaceResourceId: connectionMonitor.?workspaceResourceId
      autoStart: connectionMonitor.?autoStart
      destination: connectionMonitor.?destination
      monitoringIntervalInSeconds: connectionMonitor.?monitoringIntervalInSeconds
      notes: connectionMonitor.?notes
      source: connectionMonitor.?source
    }
  }
]

module networkWatcher_flowLogs 'flow-log/main.bicep' = [
  for (flowLog, index) in (flowLogs ?? []): {
    name: '${uniqueString(deployment().name, location)}-NW-FlowLog-${index}'
    params: {
      tags: tags
      enabled: flowLog.?enabled
      formatVersion: flowLog.?formatVersion
      location: flowLog.?location
      name: flowLog.?name
      networkWatcherName: networkWatcher.name
      retentionInDays: flowLog.?retentionInDays
      storageResourceId: flowLog.storageResourceId
      targetResourceId: flowLog.targetResourceId
      trafficAnalyticsInterval: flowLog.?trafficAnalyticsInterval
      workspaceResourceId: flowLog.?workspaceResourceId
      enabledFilteringCriteria: flowLog.?enabledFilteringCriteria
    }
  }
]

@description('The name of the deployed network watcher.')
output name string = networkWatcher.name

@description('The resource ID of the deployed network watcher.')
output resourceId string = networkWatcher.id

@description('The resource group the network watcher was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = networkWatcher.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of a flow log.')
type flowLogType = {
  @description('Optional. Name of the resource.')
  name: string?
  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.Network/networkWatchers/flowLogs@2024-05-01'>.tags?

  @description('Optional. Location for all resources.')
  location: string?

  @description('Required. Resource ID of the NSG that must be enabled for Flow Logs.')
  targetResourceId: string

  @description('Required. Resource ID of the diagnostic storage account.')
  storageResourceId: string

  @description('Optional. If the flow log should be enabled.')
  enabled: bool?

  @description('Optional. The flow log format version.')
  formatVersion: (1 | 2)?

  @description('Optional. Specify the Log Analytics Workspace Resource ID.')
  workspaceResourceId: string?

  @description('Optional. The interval in minutes which would decide how frequently TA service should do flow analytics.')
  trafficAnalyticsInterval: (10 | 60)?

  @description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
  @minValue(0)
  @maxValue(365)
  retentionInDays: int?

  @description('Optional. Field to filter network traffic logs based on SrcIP, SrcPort, DstIP, DstPort, Protocol, Encryption, Direction and Action. If not specified, all network traffic will be logged.')
  enabledFilteringCriteria: string?
}

@export()
@description('The type of a connection monitor.')
type connectionMonitorType = {
  @description('Required. Name of the resource.')
  name: string

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.tags?

  @description('Optional. Location for all resources.')
  location: string?

  @description('Optional. List of connection monitor endpoints.')
  endpoints: resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.properties.endpoints?

  @description('Optional. List of connection monitor test configurations.')
  testConfigurations: resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.properties.testConfigurations?

  @description('Optional. List of connection monitor test groups.')
  testGroups: resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.properties.testGroups?

  @description('Optional. Specify the Log Analytics Workspace Resource ID.')
  workspaceResourceId: string?

  @description('Optional. Determines if the connection monitor will start automatically once created.')
  autoStart: bool?

  @description('Optional. Describes the destination of connection monitor.')
  destination: resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.properties.destination?

  @description('Optional. Monitoring interval in seconds.')
  @minValue(30)
  @maxValue(1800)
  monitoringIntervalInSeconds: int?

  @description('Optional. Notes to be associated with the connection monitor.')
  notes: string?

  @description('Optional. Describes the source of connection monitor.')
  source: resourceInput<'Microsoft.Network/networkWatchers/connectionMonitors@2024-05-01'>.properties.source?
}
