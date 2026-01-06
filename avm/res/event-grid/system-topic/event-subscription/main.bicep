metadata name = 'Event Grid System Topic Event Subscriptions'
metadata description = 'This module deploys an Event Grid System Topic Event Subscription.'

@description('Required. The name of the Event Subscription.')
param name string

@description('Required. Name of the Event Grid System Topic.')
param systemTopicName string

@description('Optional. Dead Letter Destination.')
param deadLetterDestination resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.deadLetterDestination?

@description('Optional. Dead Letter with Resource Identity Configuration.')
param deadLetterWithResourceIdentity resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.deadLetterWithResourceIdentity?

@description('Optional. Delivery with Resource Identity Configuration.')
param deliveryWithResourceIdentity resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.deliveryWithResourceIdentity?

@description('Conditional. Required if deliveryWithResourceIdentity is not provided. The destination for the event subscription.')
param destination resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.destination?

@description('Optional. The event delivery schema for the event subscription.')
@allowed([
  'CloudEventSchemaV1_0'
  'CustomInputSchema'
  'EventGridSchema'
  'EventGridEvent'
])
param eventDeliverySchema string = 'EventGridSchema'

@description('Optional. The expiration time for the event subscription. Format is ISO-8601 (yyyy-MM-ddTHH:mm:ssZ).')
param expirationTimeUtc string?

@description('Optional. The filter for the event subscription.')
param filter resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.filter?

@description('Optional. The list of user defined labels.')
param labels string[]?

@description('Optional. The retry policy for events.')
param retryPolicy resourceInput<'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15'>.properties.retryPolicy?

resource systemTopic 'Microsoft.EventGrid/systemTopics@2025-02-15' existing = {
  name: systemTopicName
}

resource eventSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2025-02-15' = {
  name: name
  parent: systemTopic
  properties: {
    deadLetterDestination: deadLetterDestination
    deadLetterWithResourceIdentity: deadLetterWithResourceIdentity
    deliveryWithResourceIdentity: deliveryWithResourceIdentity
    destination: empty(deliveryWithResourceIdentity) ? destination : null
    eventDeliverySchema: eventDeliverySchema
    expirationTimeUtc: expirationTimeUtc ?? ''
    filter: filter ?? {}
    labels: labels ?? []
    retryPolicy: retryPolicy
  }
}

@description('The name of the event subscription.')
output name string = eventSubscription.name

@description('The resource ID of the event subscription.')
output resourceId string = eventSubscription.id

@description('The name of the resource group the event subscription was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = systemTopic.location

