metadata name = 'Log Analytics Workspace Tables'
metadata description = 'This module deploys a Log Analytics Workspace Table.'

// ============== //
//   Parameters   //
// ============== //

@description('Required. The name of the table.')
param name string

@description('Conditional. The name of the parent workspaces. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Optional. Instruct the system how to handle and charge the logs ingested to this table.')
@allowed([
  'Basic'
  'Analytics'
])
param plan string = 'Analytics'

@description('Optional. Restore parameters.')
param restoredLogs restoredLogsType?

@description('Optional. The table retention in days, between 4 and 730. Setting this property to -1 will default to the workspace retention.')
@minValue(-1)
@maxValue(730)
param retentionInDays int = -1

@description('Optional. Table\'s schema.')
param schema schemaType?

@description('Optional. Parameters of the search job that initiated this table.')
param searchResults searchResultsType?

@description('Optional. The table total retention in days, between 4 and 2555. Setting this property to -1 will default to table retention.')
@minValue(-1)
@maxValue(2555)
param totalRetentionInDays int = -1

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Log Analytics Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  )
  'Log Analytics Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '73c42c96-874c-492b-b04d-ab87d138a893'
  )
  'Monitoring Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  )
  'Monitoring Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
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

// =============== //
//   Deployments   //
// =============== //

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspaceName
}

resource table 'Microsoft.OperationalInsights/workspaces/tables@2022-10-01' = {
  parent: workspace
  name: name
  properties: {
    plan: plan
    restoredLogs: restoredLogs
    retentionInDays: retentionInDays
    schema: schema
    searchResults: searchResults
    totalRetentionInDays: totalRetentionInDays
  }
}

resource table_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(table.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: table
  }
]

// =========== //
//   Outputs   //
// =========== //

@description('The name of the table.')
output name string = table.name

@description('The resource ID of the table.')
output resourceId string = table.id

@description('The name of the resource group the table was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The parameters of the restore operation that initiated the table.')
type restoredLogsType = {
  @description('Optional. The table to restore data from.')
  sourceTable: string?
  @description('Optional. The timestamp to start the restore from (UTC).')
  startRestoreTime: string?
  @description('Optional. The timestamp to end the restore by (UTC).')
  endRestoreTime: string?
}

@export()
@description('The table schema.')
type schemaType = {
  @description('Required. The table name.')
  name: string
  @description('Required. A list of table custom columns.')
  columns: columnType[]
  @description('Optional. The table description.')
  description: string?
  @description('Optional. The table display name.')
  displayName: string?
}

@export()
@description('The parameters of the table column.')
type columnType = {
  @description('Required. The column name.')
  name: string
  @description('Required. The column type.')
  type: 'boolean' | 'dateTime' | 'dynamic' | 'guid' | 'int' | 'long' | 'real' | 'string'
  @description('Optional. The column data type logical hint.')
  dataTypeHint: 'armPath' | 'guid' | 'ip' | 'uri'?
  @description('Optional. The column description.')
  description: string?
  @description('Optional. Column display name.')
  displayName: string?
}

@export()
@description('The parameters of the search job that initiated the table.')
type searchResultsType = {
  @description('Required. The search job query.')
  query: string
  @description('Optional. The search description.')
  description: string?
  @description('Optional. Limit the search job to return up to specified number of rows.')
  limit: int?
  @description('Optional. The timestamp to start the search from (UTC).')
  startSearchTime: string?
  @description('Optional. The timestamp to end the search by (UTC).')
  endSearchTime: string?
}
