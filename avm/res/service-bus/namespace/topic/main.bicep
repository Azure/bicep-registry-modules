metadata name = 'Service Bus Namespace Topic'
metadata description = 'This module deploys a Service Bus Namespace Topic.'

@description('Conditional. The name of the parent Service Bus Namespace for the Service Bus Topic. Required if the template is used in a standalone deployment.')
@minLength(1)
@maxLength(260)
param namespaceName string

@description('Required. Name of the Service Bus Topic.')
@minLength(1)
@maxLength(260)
param name string

@description('Optional. The maximum size of the topic in megabytes, which is the size of memory allocated for the topic. Default is 1024.')
param maxSizeInMegabytes int = 1024

@description('Optional. A value indicating if this topic requires duplicate detection.')
param requiresDuplicateDetection bool = true

@description('Optional. ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.')
param defaultMessageTimeToLive string = 'P14D'

@description('Optional. Value that indicates whether server-side batched operations are enabled.')
param enableBatchedOperations bool = true

@description('Optional. ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.')
param duplicateDetectionHistoryTimeWindow string = 'PT10M'

@description('Optional. Maximum size (in KB) of the message payload that can be accepted by the topic. This property is only used in Premium today and default is 1024. This property is only used if the `service-bus/namespace` sku is Premium.')
param maxMessageSizeInKilobytes int = 1024

@description('Optional. Value that indicates whether the topic supports ordering.')
param supportOrdering bool = false

@description('Optional. ISO 8601 timespan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes.')
param autoDeleteOnIdle string?

@description('Optional. Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown.')
@allowed([
  'Active'
  'Disabled'
  'Restoring'
  'SendDisabled'
  'ReceiveDisabled'
  'Creating'
  'Deleting'
  'Renaming'
  'Unknown'
])
param status string = 'Active'

@description('Optional. A value that indicates whether the topic is to be partitioned across multiple message brokers.')
param enablePartitioning bool = false

@description('Optional. A value that indicates whether Express Entities are enabled. An express topic holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium.')
param enableExpress bool = false

@description('Optional. Authorization Rules for the Service Bus Topic.')
param authorizationRules array = []

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. The subscriptions of the topic.')
param subscriptions subscriptionType[]?

var builtInRoleNames = {
  'Azure Service Bus Data Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '090c5cfd-751d-490a-894a-3ce6f1109419'
  )
  'Azure Service Bus Data Receiver': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4f6d3b9b-027b-4f4c-9142-0e5a2a2247e0'
  )
  'Azure Service Bus Data Sender': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '69a216fc-b8fb-44d8-bc22-1f3c2cd27a39'
  )
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

resource namespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: namespaceName
}

resource topic 'Microsoft.ServiceBus/namespaces/topics@2022-10-01-preview' = {
  name: name
  parent: namespace
  properties: union(
    {
      autoDeleteOnIdle: autoDeleteOnIdle
      defaultMessageTimeToLive: defaultMessageTimeToLive
      duplicateDetectionHistoryTimeWindow: duplicateDetectionHistoryTimeWindow
      enableBatchedOperations: enableBatchedOperations
      enablePartitioning: enablePartitioning
      requiresDuplicateDetection: requiresDuplicateDetection
      status: status
      supportOrdering: supportOrdering
      maxSizeInMegabytes: maxSizeInMegabytes
    },
    (namespace.sku.name == 'Premium')
      ? {
          enableExpress: enableExpress
          maxMessageSizeInKilobytes: maxMessageSizeInKilobytes
        }
      : {}
  )
}

module topic_authorizationRules 'authorization-rule/main.bicep' = [
  for (authorizationRule, index) in authorizationRules: {
    name: '${deployment().name}-AuthRule-${index}'
    params: {
      namespaceName: namespaceName
      topicName: topic.name
      name: authorizationRule.name
      rights: authorizationRule.?rights ?? []
    }
  }
]

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

module topic_subscription 'subscription/main.bicep' = [
  for (subscription, index) in (subscriptions ?? []): {
    name: '${deployment().name}-subscription-${index}'
    params: {
      name: subscription.name
      namespaceName: namespace.name
      topicName: topic.name
      autoDeleteOnIdle: subscription.?autoDeleteOnIdle
      defaultMessageTimeToLive: subscription.?defaultMessageTimeToLive ?? 'P14D'
      duplicateDetectionHistoryTimeWindow: subscription.?duplicateDetectionHistoryTimeWindow
      enableBatchedOperations: subscription.?enableBatchedOperations
      clientAffineProperties: subscription.?clientAffineProperties
      deadLetteringOnFilterEvaluationExceptions: subscription.?deadLetteringOnFilterEvaluationExceptions ?? true
      deadLetteringOnMessageExpiration: subscription.?deadLetteringOnMessageExpiration
      forwardDeadLetteredMessagesTo: subscription.?forwardDeadLetteredMessagesTo
      forwardTo: subscription.?forwardTo
      isClientAffine: subscription.?isClientAffine
      lockDuration: subscription.?lockDuration
      maxDeliveryCount: subscription.?maxDeliveryCount
      requiresSession: subscription.?requiresSession
      rules: subscription.?rules
      status: subscription.?status
    }
  }
]

@description('The name of the deployed topic.')
output name string = topic.name

@description('The resource ID of the deployed topic.')
output resourceId string = topic.id

@description('The resource group of the deployed topic.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

import { ruleType } from 'subscription/main.bicep'
@export()
@description('The type for a subscription.')
type subscriptionType = {
  @description('Required. The name of the service bus namespace topic subscription.')
  name: string

  @description('Optional. ISO 8601 timespan idle interval after which the syubscription is automatically deleted. The minimum duration is 5 minutes.')
  autoDeleteOnIdle: string?

  @description('Optional. The properties that are associated with a subscription that is client-affine.')
  clientAffineProperties: {
    @description('Required. Indicates the Client ID of the application that created the client-affine subscription.')
    clientId: string

    @description('Optional. For client-affine subscriptions, this value indicates whether the subscription is durable or not.')
    isDurable: bool?

    @description('Optional. For client-affine subscriptions, this value indicates whether the subscription is shared or not.')
    isShared: bool?
  }?

  @description('Optional. A value that indicates whether a subscription has dead letter support when a message expires.')
  deadLetteringOnMessageExpiration: bool?

  @description('Optional. A value that indicates whether a subscription has dead letter support when a message expires.')
  deadLetteringOnFilterEvaluationExceptions: bool?

  @description('Optional. ISO 8601 timespan idle interval after which the message expires. The minimum duration is 5 minutes.')
  defaultMessageTimeToLive: string?

  @description('Optional. ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes.')
  duplicateDetectionHistoryTimeWindow: string?

  @description('Optional. A value that indicates whether server-side batched operations are enabled.')
  enableBatchedOperations: bool?

  @description('Optional. The name of the recipient entity to which all the messages sent to the subscription are forwarded to.')
  forwardDeadLetteredMessagesTo: string?

  @description('Optional. The name of the recipient entity to which all the messages sent to the subscription are forwarded to.')
  forwardTo: string?

  @description('Optional. A value that indicates whether the subscription supports the concept of session.')
  isClientAffine: bool?

  @description('Optional. ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.')
  lockDuration: string?

  @description('Optional. Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10.')
  maxDeliveryCount: int?

  @description('Optional. A value that indicates whether the subscription supports the concept of session.')
  requiresSession: bool?

  @description('Optional. The subscription rules.')
  rules: ruleType[]?

  @description('Optional. Enumerates the possible values for the status of a messaging entity.')
  status: (
    | 'Active'
    | 'Disabled'
    | 'Restoring'
    | 'SendDisabled'
    | 'ReceiveDisabled'
    | 'Creating'
    | 'Deleting'
    | 'Renaming'
    | 'Unknown')?
}
