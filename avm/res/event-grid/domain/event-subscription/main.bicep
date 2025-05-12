metadata name = 'Event Grid Domain Event Subscriptions'
metadata description = 'This module deploys an Event Grid Domain Event Subscription.'

@description('Required. The name of the Event Subscription.')
param name string

@description('Conditional. The name of the parent event grid domain. Required if the template is used in a standalone deployment.')
param domainName string

@description('Optional. Dead Letter Destination. See DeadLetterDestination objects for full shape.')
param deadLetterDestination object?

@description('Optional. Dead Letter with Resource Identity Configuration. See DeadLetterWithResourceIdentity objects for full shape.')
param deadLetterWithResourceIdentity object?

@description('Optional. Delivery with Resource Identity Configuration. See DeliveryWithResourceIdentity objects for full shape.')
param deliveryWithResourceIdentity object?

@description('Required. The destination for the event subscription. See EventSubscriptionDestination objects for full shape.')
param destination object

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

@description('Optional. The filter for the event subscription. See EventSubscriptionFilter objects for full shape.')
param filter object?

@description('Optional. The list of user defined labels.')
param labels array?

@description('Optional. The retry policy for events. See RetryPolicy objects for full shape.')
param retryPolicy object?

// Reference the existing Event Grid Domain
resource domain 'Microsoft.EventGrid/domains@2025-02-15' existing = {
  name: domainName
}

// Deploy the Event Subscription under that domain
resource eventSubscription 'Microsoft.EventGrid/domains/eventSubscriptions@2025-02-15' = {
  name: name
  parent: domain
  properties: {
    // Simple dead-letter
    deadLetterDestination: deadLetterDestination
    // Dead-letter with managed identity
    deadLetterWithResourceIdentity: deadLetterWithResourceIdentity
    // Delivery with managed identity
    deliveryWithResourceIdentity: deliveryWithResourceIdentity
    // Plain destination if no managed-identity delivery is used
    destination: empty(deliveryWithResourceIdentity) ? destination : null

    eventDeliverySchema: eventDeliverySchema
    expirationTimeUtc: expirationTimeUtc ?? ''

    filter: filter ?? {
      advancedFilters: []
      enableAdvancedFilteringOnArrays: false
      includedEventTypes: []
      isSubjectCaseSensitive: false
      subjectBeginsWith: ''
      subjectEndsWith: ''
    }

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
output location string = domain.location
