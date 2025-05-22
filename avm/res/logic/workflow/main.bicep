metadata name = 'Logic Apps (Workflows)'
metadata description = 'This module deploys a Logic App (Workflow).'

@description('Required. The logic app workflow name.')
param name string

@description('Optional. The access control configuration for workflow actions.')
param actionsAccessControlConfiguration object?

@description('Optional. The endpoints configuration:  Access endpoint and outgoing IP addresses for the connector.')
param connectorEndpointsConfiguration object?

@description('Optional. The access control configuration for accessing workflow run contents.')
param contentsAccessControlConfiguration object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Parameters for the definition template.')
param definitionParameters object?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.')
param managedIdentities managedIdentityAllType?

@description('Optional. The integration account.')
param integrationAccount object?

@description('Optional. The integration service environment settings.')
param integrationServiceEnvironment integrationServiceEnvironmentType?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. The state. - NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended.')
@allowed([
  'NotSpecified'
  'Completed'
  'Enabled'
  'Disabled'
  'Deleted'
  'Suspended'
])
param state string = 'Enabled'

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The access control configuration for invoking workflow triggers.')
param triggersAccessControlConfiguration object?

@description('Optional. The definitions for one or more actions to execute at workflow runtime.')
param workflowActions object = {}

@description('Optional. The endpoints configuration:  Access endpoint and outgoing IP addresses for the workflow.')
param workflowEndpointsConfiguration object?

@description('Optional. The access control configuration for workflow management.')
param workflowManagementAccessControlConfiguration object?

@description('Optional. The definitions for the outputs to return from a workflow run.')
param workflowOutputs object = {}

@description('Optional. The definitions for one or more parameters that pass the values to use at your logic app\'s runtime.')
param workflowParameters object?

@description('Optional. The definitions for one or more static results returned by actions as mock outputs when static results are enabled on those actions. In each action definition, the runtimeConfiguration.staticResult.name attribute references the corresponding definition inside staticResults.')
param workflowStaticResults object?

@description('Optional. The definitions for one or more triggers that instantiate your workflow. You can define more than one trigger, but only with the Workflow Definition Language, not visually through the Logic Apps Designer.')
param workflowTriggers object = {}

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? 'SystemAssigned'
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Logic App Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '87a39d53-fc1b-424a-814c-f7e04687dc9e'
  )
  'Logic App Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '515c2055-d9d4-4321-b1b9-bd0c9a0f79fe'
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
  name: '46d3xbcp.res.logic-workflow.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    state: state
    endpointsConfiguration: {
      workflow: workflowEndpointsConfiguration
      connector: connectorEndpointsConfiguration
    }
    accessControl: {
      triggers: triggersAccessControlConfiguration
      contents: contentsAccessControlConfiguration
      actions: actionsAccessControlConfiguration
      workflowManagement: workflowManagementAccessControlConfiguration
    }
    integrationAccount: integrationAccount
    integrationServiceEnvironment: integrationServiceEnvironment
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      actions: workflowActions
      contentVersion: '1.0.0.0'
      outputs: workflowOutputs
      parameters: workflowParameters
      staticResults: workflowStaticResults
      triggers: workflowTriggers
    }
    parameters: definitionParameters
  }
}

resource logicApp_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: logicApp
}

resource logicApp_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: logicApp
  }
]

resource logicApp_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(logicApp.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: logicApp
  }
]

@description('The name of the logic app.')
output name string = logicApp.name

@description('The resource group the logic app was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the logic app.')
output resourceId string = logicApp.id

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = logicApp.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = logicApp.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for the integration service environment.')
type integrationServiceEnvironmentType = {
  @description('Optional. The integration service environment Id.')
  id: string?
}
