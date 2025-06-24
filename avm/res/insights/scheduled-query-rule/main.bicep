metadata name = 'Scheduled Query Rules'
metadata description = 'This module deploys a Scheduled Query Rule.'

@description('Required. The name of the Alert.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The description of the scheduled query rule.')
param alertDescription string = ''

@description('Optional. The display name of the scheduled query rule.')
param alertDisplayName string?

@description('Optional. The flag which indicates whether this scheduled query rule is enabled.')
param enabled bool = true

@description('Optional. Indicates the type of scheduled query rule.')
@allowed([
  'LogAlert'
  'LogToMetric'
])
param kind string = 'LogAlert'

@description('Optional. The flag that indicates whether the alert should be automatically resolved or not. Relevant only for rules of the kind LogAlert. Note, ResolveConfiguration can\'t be used together with AutoMitigate.')
param autoMitigate bool = true

@description('Optional. If specified (in ISO 8601 duration format) then overrides the query time range. Relevant only for rules of the kind LogAlert.')
param queryTimeRange string?

@description('Optional. The flag which indicates whether the provided query should be validated or not. Relevant only for rules of the kind LogAlert.')
param skipQueryValidation bool = false

@description('Optional. List of resource type of the target resource(s) on which the alert is created/updated. For example if the scope is a resource group and targetResourceTypes is Microsoft.Compute/virtualMachines, then a different alert will be fired for each virtual machine in the resource group which meet the alert criteria. Relevant only for rules of the kind LogAlert.')
param targetResourceTypes string[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Defines the configuration for resolving fired alerts. Relevant only for rules of the kind LogAlert. Note, ResolveConfiguration can\'t be used together with AutoMitigate.')
param ruleResolveConfiguration resourceInput<'Microsoft.Insights/scheduledQueryRules@2025-01-01-preview'>.properties.resolveConfiguration?

@description('Required. The list of resource IDs that this scheduled query rule is scoped to.')
param scopes string[]

@description('Optional. Severity of the alert. Should be an integer between [0-4]. Value of 0 is severest. Relevant and required only for rules of the kind LogAlert.')
@allowed([
  0
  1
  2
  3
  4
])
param severity int = 3

@description('Optional. How often the scheduled query rule is evaluated represented in ISO 8601 duration format. Relevant and required only for rules of the kind LogAlert.')
param evaluationFrequency string?

@description('Conditional. The period of time (in ISO 8601 duration format) on which the Alert query will be executed (bin size). Required if the kind is set to \'LogAlert\', otherwise not relevant.')
param windowSize string?

@description('Optional. Actions to invoke when the alert fires.')
param actions actionsType?

@description('Required. The rule criteria that defines the conditions of the scheduled query rule.')
param criterias resourceInput<'Microsoft.Insights/scheduledQueryRules@2025-01-01-preview'>.properties.criteria

@description('Optional. Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired. If set, autoMitigate must be disabled. Relevant only for rules of the kind LogAlert.')
param suppressForMinutes string?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Insights/scheduledQueryRules@2025-01-01-preview'>.tags?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource. You can only configure either a system-assigned or user-assigned identities, not both.')
param managedIdentities managedIdentityAllType?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds)
            ? fail('You can only configure either a system-assigned or user-assigned identities, not both.')
            : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.insights-scheduledqueryrule.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource queryRule 'Microsoft.Insights/scheduledQueryRules@2025-01-01-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  kind: kind
  properties: {
    actions: {
      actionGroups: actions.?actionGroupResourceIds
      actionProperties: actions.?actionProperties ?? {}
      customProperties: actions.?customProperties ?? {}
    }
    criteria: criterias
    description: alertDescription
    displayName: alertDisplayName ?? name
    enabled: enabled
    scopes: scopes
    ...(kind == 'LogAlert'
      ? {
          evaluationFrequency: evaluationFrequency
          overrideQueryTimeRange: queryTimeRange
          severity: severity
          skipQueryValidation: skipQueryValidation
          targetResourceTypes: targetResourceTypes
          windowSize: windowSize
          resolveConfiguration: ruleResolveConfiguration
          ...(empty(ruleResolveConfiguration)
            ? {
                autoMitigate: autoMitigate
                muteActionsDuration: suppressForMinutes
              }
            : {})
        }
      : {})
  }
}

resource queryRule_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: queryRule
}

resource queryRule_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(queryRule.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: queryRule
  }
]

@description('The Name of the created scheduled query rule.')
output name string = queryRule.name

@description('The resource ID of the created scheduled query rule.')
output resourceId string = queryRule.id

@description('The Resource Group of the created scheduled query rule.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = queryRule.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = queryRule.?identity.?principalId

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for an actions configuration.')
type actionsType = {
  @description('Optional. Action Group resource Ids to invoke when the alert fires.')
  actionGroupResourceIds: string[]?

  @description('Optional. The properties of an action properties.')
  actionProperties: {
    @description('Optional. A property of an action payload.')
    *: string
  }?

  @description('Optional. The properties of an alert payload.')
  customProperties: {
    @description('Optional. A custom property of an action payload.')
    *: string
  }?
}
