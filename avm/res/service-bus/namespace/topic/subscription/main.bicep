metadata name = 'Service Bus Namespace Topic Subscription'
metadata description = 'This module deploys a Service Bus Namespace Topic Subscription.'

@description('Required. The name of the service bus namespace topic subscription.')
@minLength(1)
@maxLength(50)
param name string

@description('Conditional. The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Conditional. The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment.')
param topicName string

@description('Optional. ISO 8601 timespan idle interval after which the subscription is automatically deleted. The minimum duration is 5 minutes.')
param autoDeleteOnIdle string = 'P10675198DT2H48M5.477S'

@description('Conditional. The properties that are associated with a subscription that is client-affine. Required if \'isClientAffine\' is set to true.')
param clientAffineProperties clientAffinePropertiesType?

@description('Optional. A value that indicates whether a subscription has dead letter support on filter evaluation exceptions.')
param deadLetteringOnFilterEvaluationExceptions bool = false

@description('Optional. A value that indicates whether a subscription has dead letter support when a message expires.')
param deadLetteringOnMessageExpiration bool = false

@description('Optional. ISO 8061 Default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.')
param defaultMessageTimeToLive string = 'P10675199DT2H48M5.4775807S'

@description('Optional. ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes.')
param duplicateDetectionHistoryTimeWindow string = 'PT10M'

@description('Optional. A value that indicates whether server-side batched operations are enabled.')
param enableBatchedOperations bool = true

@description('Optional. Queue/Topic name to forward the Dead Letter messages to.')
param forwardDeadLetteredMessagesTo string = ''

@description('Optional. Queue/Topic name to forward the messages to.')
param forwardTo string = ''

@description('Optional. A value that indicates whether the subscription has an affinity to the client id.')
param isClientAffine bool = false

@description('Optional. ISO 8061 lock duration timespan for the subscription. The default value is 1 minute.')
param lockDuration string = 'PT1M'

@description('Optional. Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10.')
param maxDeliveryCount int = 10

@description('Optional. A value that indicates whether the subscription supports the concept of sessions.')
param requiresSession bool = false

@description('Optional. The subscription rules.')
param rules ruleType[]?

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
    clientAffineProperties: !empty(clientAffineProperties)
      ? {
          clientId: clientAffineProperties.?clientId
          isDurable: clientAffineProperties.?isDurable ?? true
          isShared: clientAffineProperties.?isShared ?? false
        }
      : null
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

module subscription_rule 'rule/main.bicep' = [
  for (rule, index) in (rules ?? []): {
    name: '${deployment().name}-rule-${index}'
    params: {
      name: rule.name
      subscriptionName: subscription.name
      namespaceName: namespaceName
      topicName: topicName
      action: rule.?action
      correlationFilter: rule.?correlationFilter
      filterType: rule.filterType
      sqlFilter: rule.?sqlFilter
    }
  }
]

@description('The name of the topic subscription.')
output name string = subscription.name

@description('The Resource ID of the topic subscription.')
output resourceId string = subscription.id

@description('The name of the Resource Group the topic subscription was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

import { ruleType } from 'rule/main.bicep'

@export()
@description('Properties specific to client affine subscriptions.')
type clientAffinePropertiesType = {
  @description('Required. Indicates the Client ID of the application that created the client-affine subscription.')
  clientId: string

  @description('Optional. For client-affine subscriptions, this value indicates whether the subscription is durable or not. Defaults to true.')
  isDurable: bool?

  @description('Optional. For client-affine subscriptions, this value indicates whether the subscription is shared or not. Defaults to false.')
  isShared: bool?
}
