metadata name = 'Synapse Workspaces SQL Pools'
metadata description = 'This module deploys a Synapse Workspaces SQL Pool.'

// ================ //
// Parameters       //
// ================ //

@description('Conditional. The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. The name of the SQL Pool.')
param name string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. The collation of the SQL pool.')
param collation string?

@description('Optional. The max size of the SQL pool in bytes.')
param maxSizeBytes int?

@description('Optional. The performance level of the SQL pool.')
param sku (
    | 'DW100c'
    | 'DW200c'
    | 'DW300c'
    | 'DW400c'
    | 'DW500c'
    | 'DW1000c'
    | 'DW1500c'
    | 'DW2000c'
    | 'DW2500c'
    | 'DW3000c'
    | 'DW5000c'
    | 'DW6000c'
    | 'DW7500c'
    | 'DW10000c'
    | 'DW15000c'
    | 'DW30000c')?

@description('Optional. The restore point in time to restore from (ISO8601 format).')
param restorePointInTime string?

@description('Optional. The recoverable database resource ID to restore from.')
param recoverableDatabaseResourceId string?

@description('Optional. The storage account type to use for the SQL pool.')
param storageAccountType (
    | 'GRS'
    | 'LRS'
    | 'ZRS') = 'GRS'

@description('Optional. Enable database transparent data encryption.')
param transparentDataEncryption (
    | 'Enabled'
    | 'Disabled') = 'Disabled'

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
param tags resourceInput<'Microsoft.Synapse/workspaces/sqlPools@2021-06-01'>.tags?

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

resource sqlPool 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
  name: name
  parent: workspace
  location: location
  tags: tags
  sku: !empty(sku) ? {
    name: sku
  } : null
  properties: {
    collation: collation
    maxSizeBytes: maxSizeBytes
    recoverableDatabaseId: recoverableDatabaseResourceId
    restorePointInTime: restorePointInTime
    storageAccountType: storageAccountType
  }
}

resource sqlPool_transparentDataEncryption 'Microsoft.Synapse/workspaces/sqlPools/transparentDataEncryption@2021-06-01' = {
  name: 'current'
  parent: sqlPool
  properties: {
    status: transparentDataEncryption
  }
}

resource sqlPool_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: sqlPool
}

resource sqlPool_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: sqlPool
  }
]

resource sqlPool_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(sqlPool.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: sqlPool
  }
]

@description('The name of the deployed SQL Pool.')
output name string = sqlPool.name

@description('The resource ID of the deployed SQL Pool.')
output resourceId string = sqlPool.id

@description('The resource group of the deployed SQL Pool.')
output resourceGroupName string = resourceGroup().name
