metadata name = 'Service Bus Namespace Queue'
metadata description = 'This module deploys a Service Bus Namespace Queue.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment.')
@minLength(1)
@maxLength(260)
param namespaceName string

@description('Required. Name of the Service Bus Queue.')
@minLength(1)
@maxLength(260)
param name string

@description('Optional. ISO 8061 timeSpan idle interval after which the queue is automatically deleted. The minimum duration is 5 minutes (PT5M).')
param autoDeleteOnIdle string?

@description('Optional. Queue/Topic name to forward the Dead Letter message.')
param forwardDeadLetteredMessagesTo string?

@description('Optional. Queue/Topic name to forward the messages.')
param forwardTo string?

@description('Optional. ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.')
param lockDuration string = 'PT1M'

@description('Optional. The maximum size of the queue in megabytes, which is the size of memory allocated for the queue. Default is 1024.')
param maxSizeInMegabytes int = 1024

@description('Optional. A value indicating if this queue requires duplicate detection.')
param requiresDuplicateDetection bool = false

@description('Optional. A value that indicates whether the queue supports the concept of sessions.')
param requiresSession bool = false

@description('Optional. ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.')
param defaultMessageTimeToLive string = 'P14D'

@description('Optional. A value that indicates whether this queue has dead letter support when a message expires.')
param deadLetteringOnMessageExpiration bool = true

@description('Optional. Value that indicates whether server-side batched operations are enabled.')
param enableBatchedOperations bool = true

@description('Optional. ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.')
param duplicateDetectionHistoryTimeWindow string = 'PT10M'

@description('Optional. The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10.')
param maxDeliveryCount int = 10

@description('Optional. Maximum size (in KB) of the message payload that can be accepted by the queue. This property is only used in Premium today and default is 1024.')
param maxMessageSizeInKilobytes int = 1024

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

@description('Optional. A value that indicates whether the queue is to be partitioned across multiple message brokers.')
param enablePartitioning bool = false

@description('Optional. A value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium.')
param enableExpress bool = false

@description('Optional. Authorization Rules for the Service Bus Queue.')
param authorizationRules array = []

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

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

resource namespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: namespaceName
}

resource queue 'Microsoft.ServiceBus/namespaces/queues@2022-10-01-preview' = {
  name: name
  parent: namespace
  properties: {
    autoDeleteOnIdle: !empty(autoDeleteOnIdle) ? autoDeleteOnIdle : null
    defaultMessageTimeToLive: defaultMessageTimeToLive
    deadLetteringOnMessageExpiration: deadLetteringOnMessageExpiration
    duplicateDetectionHistoryTimeWindow: duplicateDetectionHistoryTimeWindow
    enableBatchedOperations: enableBatchedOperations
    enableExpress: enableExpress
    enablePartitioning: enablePartitioning
    forwardDeadLetteredMessagesTo: !empty(forwardDeadLetteredMessagesTo) ? forwardDeadLetteredMessagesTo : null
    forwardTo: !empty(forwardTo) ? forwardTo : null
    lockDuration: lockDuration
    maxDeliveryCount: maxDeliveryCount
    maxMessageSizeInKilobytes: namespace.sku.name == 'Premium' ? maxMessageSizeInKilobytes : null
    maxSizeInMegabytes: maxSizeInMegabytes
    requiresDuplicateDetection: requiresDuplicateDetection
    requiresSession: requiresSession
    status: status
  }
}

module queue_authorizationRules 'authorization-rule/main.bicep' = [
  for (authorizationRule, index) in authorizationRules: {
    name: '${deployment().name}-AuthRule-${index}'
    params: {
      namespaceName: namespaceName
      queueName: queue.name
      name: authorizationRule.name
      rights: authorizationRule.?rights ?? []
    }
  }
]

resource queue_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: queue
}

resource queue_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(queue.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: queue
  }
]

@description('The name of the deployed queue.')
output name string = queue.name

@description('The resource ID of the deployed queue.')
output resourceId string = queue.id

@description('The resource group of the deployed queue.')
output resourceGroupName string = resourceGroup().name

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
