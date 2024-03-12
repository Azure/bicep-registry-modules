metadata name = 'Service Bus Namespace Topic Subscription'
metadata description = 'This module deploys a Service Bus Namespace Topic Subscription.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the service bus namespace topic subscription.')
param name string

@description('Conditional. The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Conditional. The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment.')
param topicName string

@description('Optional. ISO 8601 timespan idle interval after which the subscription is automatically deleted. The minimum duration is 5 minutes.')
param autoDeleteOnIdle string = 'PT1H'

@description('Optional. The properties that are associated with a subscription that is client-affine.')
param clientAffineProperties object = {}

@description('Optional. A value that indicates whether a subscription has dead letter support when a message expires.')
param deadLetteringOnFilterEvaluationExceptions bool = false

@description('Optional. A value that indicates whether a subscription has dead letter support when a message expires.')
param deadLetteringOnMessageExpiration bool = false

@description('Optional. ISO 8601 timespan idle interval after which the message expires. The minimum duration is 5 minutes.')
param defaultMessageTimeToLive string = 'P10675199DT2H48M5.4775807S'

@description('Optional. ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes.')
param duplicateDetectionHistoryTimeWindow string = 'PT10M'

@description('Optional. A value that indicates whether server-side batched operations are enabled.')
param enableBatchedOperations bool = true

@description('Optional. The name of the recipient entity to which all the messages sent to the subscription are forwarded to.')
param forwardDeadLetteredMessagesTo string = ''

@description('Optional. The name of the recipient entity to which all the messages sent to the subscription are forwarded to.')
param forwardTo string = ''

@description('Optional. A value that indicates whether the subscription supports the concept of session.')
param isClientAffine bool = false

@description('Optional. ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.')
param lockDuration string = 'PT1M'

@description('Optional. Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10.')
param maxDeliveryCount int = 10

@description('Optional. A value that indicates whether the subscription supports the concept of session.')
param requiresSession bool = false

@description('Optional. Enumerates the possible values for the status of a messaging entity.')
@allowed([
  'Active'
  'Creating'
  'Deleting'
  'Disabled'
  'ReceiveDisabled'
  'Renaming'
  'Restoring'
  'SendDisabled'
  'Unknown'
])
param status string = 'Active'

resource namespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: namespaceName

  resource topic 'topics@2022-10-01-preview' existing = {
    name: topicName
  }
}

resource subscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2021-11-01' = {
  name: name
  parent: namespace::topic
  properties: {
    autoDeleteOnIdle: autoDeleteOnIdle
    clientAffineProperties: clientAffineProperties
    deadLetteringOnFilterEvaluationExceptions: deadLetteringOnFilterEvaluationExceptions
    deadLetteringOnMessageExpiration: deadLetteringOnMessageExpiration
    defaultMessageTimeToLive: defaultMessageTimeToLive
    duplicateDetectionHistoryTimeWindow: duplicateDetectionHistoryTimeWindow
    enableBatchedOperations: enableBatchedOperations
    forwardDeadLetteredMessagesTo: forwardDeadLetteredMessagesTo
    forwardTo: !empty(forwardTo) ? forwardTo : null
    isClientAffine: isClientAffine
    lockDuration: lockDuration
    maxDeliveryCount: maxDeliveryCount
    requiresSession: requiresSession
    status: status
  }
}

@description('The name of the topic subscription.')
output name string = subscription.name

@description('The Resource ID of the topic subscription.')
output resourceId string = subscription.id

@description('The name of the Resource Group the topic subscription was created in.')
output resourceGroupName string = resourceGroup().name
