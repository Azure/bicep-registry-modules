metadata name = 'Eventgrid Namespace Topics'
metadata description = 'This module deploys an Eventgrid Namespace Topic.'

@description('Conditional. The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Required. Name of the topic.')
param name string

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@minValue(1)
@maxValue(7)
@description('Optional. Event retention for the namespace topic expressed in days.')
param eventRetentionInDays int = 1

@description('Optional. This determines the format that is expected for incoming events published to the topic.')
param inputSchema string = 'CloudEventSchemaV1_0'

@description('Optional. Publisher type of the namespace topic.')
param publisherType string = 'Custom'

@description('Optional. All event subscriptions to create.')
param eventSubscriptions array?

var builtInRoleNames = {
  'Azure Resource Notifications System Topics Subscriber': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0b962ed2-6d56-471c-bd5f-3477d83a7ba4'
  )
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'EventGrid Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1e241071-0855-49ea-94dc-649edcd759de'
  )
  'EventGrid Data Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1d8c3fe3-8864-474b-8749-01e3783e8157'
  )
  'EventGrid Data Receiver': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '78cbd9e7-9798-4e2e-9b5a-547d9ebb31fb'
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
  'EventGrid TopicSpaces Publisher': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a12b0b94-b317-4dcd-84a8-502ce99884c6'
  )
  'EventGrid TopicSpaces Subscriber': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4b0f2fd7-60b4-4eca-896f-4435034f8bf5'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
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

// ============== //
// Resources      //
// ============== //

resource namespace 'Microsoft.EventGrid/namespaces@2023-12-15-preview' existing = {
  name: namespaceName
}

resource topic 'Microsoft.EventGrid/namespaces/topics@2023-12-15-preview' = {
  name: name
  parent: namespace
  properties: {
    eventRetentionInDays: eventRetentionInDays
    inputSchema: inputSchema
    publisherType: publisherType
  }
}

resource topic_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: topic
}

resource topic_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(topic.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: topic
  }
]

module topic_eventSubscriptions 'event-subscription/main.bicep' = [
  for (eventSubscription, index) in (eventSubscriptions ?? []): {
    name: '${uniqueString(deployment().name, topic.name)}-Topic-EventSubscription-${index}'
    params: {
      name: eventSubscription.name
      namespaceName: namespace.name
      topicName: topic.name
      deliveryConfiguration: eventSubscription.?deliveryConfiguration
      eventDeliverySchema: eventSubscription.?eventDeliverySchema
      filtersConfiguration: eventSubscription.?filtersConfiguration
      roleAssignments: eventSubscription.?roleAssignments
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the Namespace Topic.')
output resourceId string = topic.id

@description('The name of the Namespace Topic.')
output name string = topic.name

@description('The name of the resource group the Namespace Topic was created in.')
output resourceGroupName string = resourceGroup().name
