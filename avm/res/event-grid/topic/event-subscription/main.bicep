metadata name = 'EventGrid Topic Event Subscriptions'
metadata description = 'This module deploys an Event Grid Topic Event Subscription.'

@description('Required. The name of the Event Subscription.')
param name string

@description('Required. Name of the Event Grid Topic.')
param topicName string

@description('Optional. Dead Letter Destination. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterdestination-objects for more information).')
param deadLetterDestination resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.deadLetterDestination?

@description('Optional. Dead Letter with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterwithresourceidentity-objects for more information).')
param deadLetterWithResourceIdentity resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.deadLetterWithResourceIdentity?

@description('Optional. Delivery with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deliverywithresourceidentity-objects for more information).')
param deliveryWithResourceIdentity resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.deliveryWithResourceIdentity?

@description('Conditional. Required if deliveryWithResourceIdentity is not provided. The destination for the event subscription. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#eventsubscriptiondestination-objects for more information).')
param destination resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.destination?

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

@description('Optional. The filter for the event subscription. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#eventsubscriptionfilter for more information).')
param filter resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.filter?

@description('Optional. The list of user defined labels.')
param labels string[]?

@description('Optional. The retry policy for events. This can be used to configure the TTL and maximum number of delivery attempts and time to live for events.')
param retryPolicy resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.retryPolicy?

resource topic 'Microsoft.EventGrid/topics@2025-04-01-preview' existing = {
  name: topicName
}

resource eventSubscription 'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview' = {
  name: name
  parent: topic
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
output location string = topic.location
