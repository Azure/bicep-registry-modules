metadata name = 'Network Watchers'
metadata description = 'This module deploys a Network Watcher.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. Name of the Network Watcher resource (hidden).')
@minLength(1)
param name string = 'NetworkWatcher_${location}'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array that contains the Connection Monitors.')
param connectionMonitors array = []

@description('Optional. Array that contains the Flow Logs.')
param flowLogs array = []

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

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
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
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

resource networkWatcher 'Microsoft.Network/networkWatchers@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {}
}

resource networkWatcher_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
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
  for (connectionMonitor, index) in connectionMonitors: {
    name: '${uniqueString(deployment().name, location)}-NW-ConnectionMonitor-${index}'
    params: {
      endpoints: contains(connectionMonitor, 'endpoints') ? connectionMonitor.endpoints : []
      name: connectionMonitor.name
      location: location
      networkWatcherName: networkWatcher.name
      testConfigurations: contains(connectionMonitor, 'testConfigurations') ? connectionMonitor.testConfigurations : []
      testGroups: contains(connectionMonitor, 'testGroups') ? connectionMonitor.testGroups : []
      workspaceResourceId: contains(connectionMonitor, 'workspaceResourceId')
        ? connectionMonitor.workspaceResourceId
        : ''
    }
  }
]

module networkWatcher_flowLogs 'flow-log/main.bicep' = [
  for (flowLog, index) in flowLogs: {
    name: '${uniqueString(deployment().name, location)}-NW-FlowLog-${index}'
    params: {
      enabled: contains(flowLog, 'enabled') ? flowLog.enabled : true
      formatVersion: contains(flowLog, 'formatVersion') ? flowLog.formatVersion : 2
      location: contains(flowLog, 'location') ? flowLog.location : location
      name: contains(flowLog, 'name')
        ? flowLog.name
        : '${last(split(flowLog.targetResourceId, '/'))}-${split(flowLog.targetResourceId, '/')[4]}-flowlog'
      networkWatcherName: networkWatcher.name
      retentionInDays: contains(flowLog, 'retentionInDays') ? flowLog.retentionInDays : 365
      storageId: flowLog.storageId
      targetResourceId: flowLog.targetResourceId
      trafficAnalyticsInterval: contains(flowLog, 'trafficAnalyticsInterval') ? flowLog.trafficAnalyticsInterval : 60
      workspaceResourceId: contains(flowLog, 'workspaceResourceId') ? flowLog.workspaceResourceId : ''
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

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
