metadata name = 'Synapse Workspaces Big Data Pools'
metadata description = 'This module deploys a Synapse Workspaces Big Data Pool.'

// ================ //
// Parameters       //
// ================ //

@description('Conditional. The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. The name of the Big Data Pool.')
param name string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. The kind of nodes that the Big Data pool provides.')
@allowed([
  'HardwareAcceleratedFPGA'
  'HardwareAcceleratedGPU'
  'MemoryOptimized'
  'None'
])
param nodeSizeFamily string = 'MemoryOptimized'

@allowed([
  'Large'
  'Medium'
  'None'
  'Small'
  'XLarge'
  'XXLarge'
  'XXXLarge'
])
@description('Required. The level of compute power that each node in the Big Data pool has.')
param nodeSize string

@description('Optional. Auto-scaling properties.')
param autoScale autoScaleType?

@description('Optional. The number of nodes in the Big Data pool if Auto-scaling is disabled.')
@minValue(3)
@maxValue(200)
param nodeCount int = 3

@description('Optional. Dynamic Executor Allocation.')
param dynamicExecutorAllocation dynamicExecutorAllocationType?

@description('Optional. Synapse workspace Big Data Pools Auto-pausing delay in minutes (5-10080). Disabled if value not provided.')
@minValue(-1)
@maxValue(10080) // 7 days in minutes
param autoPauseDelayInMinutes int = -1

@description('Optional. The Apache Spark version.')
@allowed([
  '3.4'
  '3.5'
])
param sparkVersion string = '3.4'

@description('Optional. Spark configuration file to specify additional properties.')
param sparkConfigProperties sparkConfigPropertiesType?

@description('Optional. Whether session level packages enabled. Disabled if value not provided.')
param sessionLevelPackagesEnabled bool = false

@description('Optional. The cache size.')
@minValue(0)
@maxValue(100)
param cacheSize int = 50

@description('Optional. The default folder where Spark logs will be written.')
param defaultSparkLogFolder string?

@description('Optional. Whether Auto-tune is Enabled or not. Disabled if value not provided.')
param autotuneEnabled bool = false

@description('Optional. Whether Compute Isolation is enabled or not. Disabled if value not provided.')
param computeIsolationEnabled bool = false

@description('Optional. The Spark events folder.')
param sparkEventsFolder string?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Tags of the resource.')
param tags object?

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource bigDataPool 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' = {
  name: name
  parent: workspace
  location: location
  tags: tags
  properties: {
    nodeSizeFamily: nodeSizeFamily
    nodeSize: nodeSize
    autoScale: !empty(autoScale)
      ? {
          enabled: true
          minNodeCount: autoScale.?minNodeCount
          maxNodeCount: autoScale.?maxNodeCount
        }
      : {
          enabled: false
        }
    nodeCount: empty(autoScale) ? nodeCount : null
    dynamicExecutorAllocation: !empty(dynamicExecutorAllocation)
      ? {
          enabled: true
          minExecutors: dynamicExecutorAllocation.?minExecutors
          maxExecutors: dynamicExecutorAllocation.?maxExecutors
        }
      : {
          enabled: false
        }
    autoPause: autoPauseDelayInMinutes != -1
      ? {
          enabled: true
          delayInMinutes: autoPauseDelayInMinutes < 5 ? 5 : autoPauseDelayInMinutes // Minimum 5 minutes
        }
      : {
          enabled: false
        }
    sparkVersion: sparkVersion
    sparkConfigProperties: sparkConfigProperties
    sessionLevelPackagesEnabled: sessionLevelPackagesEnabled
    cacheSize: cacheSize
    defaultSparkLogFolder: !empty(defaultSparkLogFolder) ? defaultSparkLogFolder : null
    isAutotuneEnabled: autotuneEnabled
    isComputeIsolationEnabled: computeIsolationEnabled
    sparkEventsFolder: !empty(sparkEventsFolder) ? sparkEventsFolder : null
  }
}

resource bigDataPool_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: bigDataPool
}

resource bigDataPool_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: bigDataPool
  }
]

resource bigDataPool_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(bigDataPool.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: bigDataPool
  }
]

@description('The name of the deployed Big Data Pool.')
output name string = bigDataPool.name

@description('The resource ID of the deployed Big Data Pool.')
output resourceId string = bigDataPool.id

@description('The resource group of the deployed Big Data Pool.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The synapse workspace Big Data Pools Auto-scaling properties.')
type autoScaleType = {
  @description('Required. Synapse workspace Big Data Pools Auto-scaling maximum node count.')
  @minValue(3)
  @maxValue(200)
  maxNodeCount: int

  @description('Required. Synapse workspace Big Data Pools Auto-scaling minimum node count.')
  @minValue(3)
  @maxValue(200)
  minNodeCount: int
}

@export()
@description('The synapse workspace Big Data Pools Dynamic Executor Allocation properties.')
type dynamicExecutorAllocationType = {
  @description('Required. Synapse workspace Big Data Pools Dynamic Executor Allocation minimum executors.')
  @minValue(1)
  @maxValue(10)
  minExecutors: int

  @description('Required. Synapse workspace Big Data Pools Dynamic Executor Allocation maximum executors (maxNodeCount-1).')
  @minValue(1)
  @maxValue(10)
  maxExecutors: int
}

@export()
@description('The synapse workspace Big Data Pools Spark configuration file properties.')
type sparkConfigPropertiesType = {
  @description('Required. The configuration type.')
  configurationType: ('Artifact' | 'File')

  @description('Required. The configuration content.')
  content: string

  @description('Required. The configuration filename.')
  filename: string
}
