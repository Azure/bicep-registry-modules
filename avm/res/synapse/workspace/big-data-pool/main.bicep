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

@description('Optional. Library version requirements.')
param libraryRequirements libraryRequirementsType?

@description('Optional. List of custom libraries/packages associated with the spark pool.')
param customLibraries customLibraryType[]?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
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

var enableReferencedModulesTelemetry bool = false

// Initial pool creation - libraries must not be included on first deployment.
module bigDataPool_create '../modules/bigDataPool.bicep' = {
  name: '${deployment().name}-create'
  params: {
    workspaceName: workspaceName
    name: name
    location: location
    tags: tags
    nodeSizeFamily: nodeSizeFamily
    nodeSize: nodeSize
    autoScale: autoScale
    nodeCount: nodeCount
    dynamicExecutorAllocation: dynamicExecutorAllocation
    autoPauseDelayInMinutes: autoPauseDelayInMinutes
    sparkVersion: sparkVersion
    sparkConfigProperties: sparkConfigProperties
    sessionLevelPackagesEnabled: sessionLevelPackagesEnabled
    cacheSize: cacheSize
    defaultSparkLogFolder: defaultSparkLogFolder
    autotuneEnabled: autotuneEnabled
    computeIsolationEnabled: computeIsolationEnabled
    sparkEventsFolder: sparkEventsFolder
  }
}

// Azure does not allow setting libraryRequirements or customLibraries during initial pool creation.
// Synapse's internal library management pool (systemreservedpool-librarymanagement) also needs
// time to initialize after a new Big Data Pool is created. Without this wait, the library
// installation Spark job fails with a transient WASB 500 error.
module bigDataPool_libraryWait 'br/public:avm/res/resources/deployment-script:0.5.2' = if (libraryRequirements != null || !empty(customLibraries ?? [])) {
  name: '${deployment().name}-libraryWait'
  params: {
    name: '${deployment().name}-libraryWait'
    location: resourceGroup().location
    tags: tags
    kind: 'AzurePowerShell'
    enableTelemetry: enableReferencedModulesTelemetry
    scriptContent: 'Start-Sleep -Seconds 300'
    azPowerShellVersion: '11.0'
    timeout: 'PT15M'
    cleanupPreference: 'Always'
    retentionInterval: 'PT1H'
  }
  dependsOn: [
    bigDataPool_create
  ]
}

// Second-pass deployment that adds the library configuration to the already-created pool.
module bigDataPool_libraries '../modules/bigDataPool.bicep' = if (libraryRequirements != null || !empty(customLibraries ?? [])) {
  name: '${deployment().name}-libraries'
  params: {
    workspaceName: workspaceName
    name: name
    location: location
    tags: tags
    nodeSizeFamily: nodeSizeFamily
    nodeSize: nodeSize
    autoScale: autoScale
    nodeCount: nodeCount
    dynamicExecutorAllocation: dynamicExecutorAllocation
    autoPauseDelayInMinutes: autoPauseDelayInMinutes
    sparkVersion: sparkVersion
    sparkConfigProperties: sparkConfigProperties
    sessionLevelPackagesEnabled: sessionLevelPackagesEnabled
    cacheSize: cacheSize
    defaultSparkLogFolder: defaultSparkLogFolder
    autotuneEnabled: autotuneEnabled
    computeIsolationEnabled: computeIsolationEnabled
    sparkEventsFolder: sparkEventsFolder
    libraryRequirements: libraryRequirements
    customLibraries: customLibraries
  }
  dependsOn: [
    bigDataPool_libraryWait
  ]
}

// Reference to the deployed pool for use by locks, diagnostics and role assignments.
resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource bigDataPool 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' existing = {
  name: name
  parent: workspace
    dependsOn: [
      bigDataPool_create
    ]
}

resource bigDataPool_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
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
output name string = bigDataPool_create.outputs.name

@description('The resource ID of the deployed Big Data Pool.')
output resourceId string = bigDataPool_create.outputs.resourceId

@description('The resource group of the deployed Big Data Pool.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

import {
  autoScaleType as bigDataPoolAutoScaleType
  dynamicExecutorAllocationType as bigDataPoolDynamicExecutorAllocationType
  sparkConfigPropertiesType as bigDataPoolSparkConfigPropertiesType
  libraryRequirementsType as bigDataPoolLibraryRequirementsType
  customLibraryType as bigDataPoolCustomLibraryType
} from '../modules/bigDataPool.bicep'

@export()
type autoScaleType = bigDataPoolAutoScaleType

@export()
type dynamicExecutorAllocationType = bigDataPoolDynamicExecutorAllocationType

@export()
type sparkConfigPropertiesType = bigDataPoolSparkConfigPropertiesType

@export()
type libraryRequirementsType = bigDataPoolLibraryRequirementsType

@export()
type customLibraryType = bigDataPoolCustomLibraryType
