metadata name = 'Event Grid System Topics'
metadata description = 'This module deploys an Event Grid System Topic.'

@description('Required. The name of the Event Grid Topic.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. Source for the system topic.')
param source string

@description('Required. TopicType for the system topic.')
param topicType string

@description('Optional. Event subscriptions to deploy.')
param eventSubscriptions eventSubscriptionType[]?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Array of role assignments to create on external resources. This is useful for scenarios where the system topic needs permissions on delivery or dead letter destinations (e.g., Storage Account, Service Bus). Each assignment specifies the target resource ID and role definition ID (GUID).')
param externalResourceRoleAssignments externalResourceRoleAssignmentType[] = []

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.EventGrid/systemTopics@2025-02-15'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'EventGrid Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1e241071-0855-49ea-94dc-649edcd759de'
  )
  'EventGrid Data Sender': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'd5a91429-5739-47e2-a06b-3470a27159e7'
  )
  'EventGrid EventSubscription Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '428e0ff0-5e57-4d9c-a221-2c70d0e0a443'
  )
  'EventGrid EventSubscription Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '2414bbcf-6497-4faf-8c65-045460748405'
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

var formattedExternalResourceRoleAssignments = [
  for (assignment, index) in (externalResourceRoleAssignments ?? []): union(assignment, {
    roleDefinitionId: contains(assignment.roleDefinitionId, '/providers/Microsoft.Authorization/roleDefinitions/')
      ? assignment.roleDefinitionId
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', assignment.roleDefinitionId)
  })
]

var enableReferencedModulesTelemetry = false

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.eventgrid-systemtopic.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

resource systemTopic 'Microsoft.EventGrid/systemTopics@2025-02-15' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    source: source
    topicType: topicType
  }
}

// Event subscriptions
module systemTopics_eventSubscriptions 'event-subscription/main.bicep' = [
  for (eventSubscription, index) in eventSubscriptions ?? []: {
    name: '${uniqueString(deployment().name, location)}-EventGrid-SysTopics-EventSubs-${index}'
    params: {
      destination: empty(eventSubscription.?deliveryWithResourceIdentity) ? eventSubscription.?destination : null
      systemTopicName: systemTopic.name
      name: eventSubscription.name
      deadLetterDestination: eventSubscription.?deadLetterDestination
      deadLetterWithResourceIdentity: eventSubscription.?deadLetterWithResourceIdentity
      deliveryWithResourceIdentity: eventSubscription.?deliveryWithResourceIdentity
      eventDeliverySchema: eventSubscription.?eventDeliverySchema
      expirationTimeUtc: eventSubscription.?expirationTimeUtc
      filter: eventSubscription.?filter
      labels: eventSubscription.?labels
      retryPolicy: eventSubscription.?retryPolicy
    }
    dependsOn: [
      systemTopic_externalResourceRoleAssignments
    ]
  }
]

resource systemTopic_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: systemTopic
}

resource systemTopic_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: systemTopic
  }
]

resource systemTopic_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(systemTopic.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: systemTopic
  }
]

// External resource role assignments using the pattern template
module systemTopic_externalResourceRoleAssignments 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = [
  for (assignment, index) in formattedExternalResourceRoleAssignments: if (managedIdentities.?systemAssigned ?? false) {
    name: '${uniqueString(deployment().name, location)}-EventGrid-SysTopic-ExtRoleAssign-${index}'
    params: {
      resourceId: assignment.resourceId
      roleDefinitionId: assignment.roleDefinitionId
      principalId: systemTopic.identity.principalId
      principalType: 'ServicePrincipal'
      description: assignment.?description ?? 'Role assignment for Event Grid System Topic ${systemTopic.name}'
      roleName: assignment.?roleName ?? assignment.roleDefinitionId
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

@description('The name of the event grid system topic.')
output name string = systemTopic.name

@description('The resource ID of the event grid system topic.')
output resourceId string = systemTopic.id

@description('The name of the resource group the event grid system topic was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = (managedIdentities.?systemAssigned ?? false) ? systemTopic.identity.principalId : null

@description('The location the resource was deployed into.')
output location string = systemTopic.location

// ================ //
// Definitions      //
// ================ //


@description('Event subscription configuration.')
type eventSubscriptionType = {
  @description('Required. The name of the event subscription.')
  name: string
  
  @description('Optional. Dead Letter Destination.')
  deadLetterDestination: resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.deadLetterDestination?
  
  @description('Optional. Dead Letter with Resource Identity Configuration.')
  deadLetterWithResourceIdentity: resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.deadLetterWithResourceIdentity?
  
  @description('Optional. Delivery with Resource Identity Configuration.')
  deliveryWithResourceIdentity: resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.deliveryWithResourceIdentity?
  
  @description('Conditional. Required if deliveryWithResourceIdentity is not provided. The destination for the event subscription.')
  destination: resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.destination?
  
  @description('Optional. The event delivery schema for the event subscription.')
  eventDeliverySchema: 'CloudEventSchemaV1_0' | 'CustomInputSchema' | 'EventGridSchema' | 'EventGridEvent'?
  
  @description('Optional. The expiration time for the event subscription. Format is ISO-8601 (yyyy-MM-ddTHH:mm:ssZ).')
  expirationTimeUtc: string?
  
  @description('Optional. The filter for the event subscription.')
  filter: resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.filter?
  
  @description('Optional. The list of user defined labels.')
  labels: string[]?
  
  @description('Optional. The retry policy for events.')
  retryPolicy: resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.retryPolicy?
}

@description('External resource role assignment configuration.')
type externalResourceRoleAssignmentType = {
  @description('Required. The resource ID of the target resource to assign permissions to.')
  resourceId: string
  
  @description('Required. The role definition ID (GUID) or full role definition resource ID. Example: "ba92f5b4-2d11-453d-a403-e96b0029c9fe" or "/subscriptions/{sub}/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe".')
  roleDefinitionId: string
  
  @description('Optional. Description of the role assignment.')
  description: string?
  
  @description('Optional. Name of the role for logging purposes.')
  roleName: string?
}
