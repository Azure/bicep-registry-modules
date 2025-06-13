# Event Grid System Topic Event Subscriptions `[Microsoft.EventGrid/systemTopics/eventSubscriptions]`

This module deploys an Event Grid System Topic Event Subscription.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventGrid/systemTopics/eventSubscriptions` | [2025-02-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2025-02-15/systemTopics/eventSubscriptions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Event Subscription. |
| [`systemTopicName`](#parameter-systemtopicname) | string | Name of the Event Grid System Topic. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-destination) | object | Required if deliveryWithResourceIdentity is not provided. The destination for the event subscription. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deadLetterDestination`](#parameter-deadletterdestination) | object | Dead Letter Destination. |
| [`deadLetterWithResourceIdentity`](#parameter-deadletterwithresourceidentity) | object | Dead Letter with Resource Identity Configuration. |
| [`deliveryWithResourceIdentity`](#parameter-deliverywithresourceidentity) | object | Delivery with Resource Identity Configuration. |
| [`eventDeliverySchema`](#parameter-eventdeliveryschema) | string | The event delivery schema for the event subscription. |
| [`expirationTimeUtc`](#parameter-expirationtimeutc) | string | The expiration time for the event subscription. Format is ISO-8601 (yyyy-MM-ddTHH:mm:ssZ). |
| [`filter`](#parameter-filter) | object | The filter for the event subscription. |
| [`labels`](#parameter-labels) | array | The list of user defined labels. |
| [`retryPolicy`](#parameter-retrypolicy) | object | The retry policy for events. |

### Parameter: `name`

The name of the Event Subscription.

- Required: Yes
- Type: string

### Parameter: `systemTopicName`

Name of the Event Grid System Topic.

- Required: Yes
- Type: string

### Parameter: `destination`

Required if deliveryWithResourceIdentity is not provided. The destination for the event subscription.

- Required: No
- Type: object

### Parameter: `deadLetterDestination`

Dead Letter Destination.

- Required: No
- Type: object

### Parameter: `deadLetterWithResourceIdentity`

Dead Letter with Resource Identity Configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deadLetterDestination`](#parameter-deadletterwithresourceidentitydeadletterdestination) | object | The dead letter destination configuration. Should contain endpointType and properties matching the Azure Event Grid dead letter destination schema. |
| [`identity`](#parameter-deadletterwithresourceidentityidentity) | object | The identity configuration for dead letter. |

### Parameter: `deadLetterWithResourceIdentity.deadLetterDestination`

The dead letter destination configuration. Should contain endpointType and properties matching the Azure Event Grid dead letter destination schema.

- Required: Yes
- Type: object

### Parameter: `deadLetterWithResourceIdentity.identity`

The identity configuration for dead letter.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-deadletterwithresourceidentityidentitytype) | string | The type of identity to use. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedIdentity`](#parameter-deadletterwithresourceidentityidentityuserassignedidentity) | string | Required if type is UserAssigned. The user assigned identity resource ID. |

### Parameter: `deadLetterWithResourceIdentity.identity.type`

The type of identity to use.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'SystemAssigned'
    'UserAssigned'
  ]
  ```

### Parameter: `deadLetterWithResourceIdentity.identity.userAssignedIdentity`

Required if type is UserAssigned. The user assigned identity resource ID.

- Required: No
- Type: string

### Parameter: `deliveryWithResourceIdentity`

Delivery with Resource Identity Configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-deliverywithresourceidentitydestination) | object | The destination configuration for delivery. Should contain endpointType and properties matching the Azure Event Grid destination schema. |
| [`identity`](#parameter-deliverywithresourceidentityidentity) | object | The identity configuration for delivery. |

### Parameter: `deliveryWithResourceIdentity.destination`

The destination configuration for delivery. Should contain endpointType and properties matching the Azure Event Grid destination schema.

- Required: Yes
- Type: object

### Parameter: `deliveryWithResourceIdentity.identity`

The identity configuration for delivery.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-deliverywithresourceidentityidentitytype) | string | The type of identity to use. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedIdentity`](#parameter-deliverywithresourceidentityidentityuserassignedidentity) | string | Required if type is UserAssigned. The user assigned identity resource ID. |

### Parameter: `deliveryWithResourceIdentity.identity.type`

The type of identity to use.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'SystemAssigned'
    'UserAssigned'
  ]
  ```

### Parameter: `deliveryWithResourceIdentity.identity.userAssignedIdentity`

Required if type is UserAssigned. The user assigned identity resource ID.

- Required: No
- Type: string

### Parameter: `eventDeliverySchema`

The event delivery schema for the event subscription.

- Required: No
- Type: string
- Default: `'EventGridSchema'`
- Allowed:
  ```Bicep
  [
    'CloudEventSchemaV1_0'
    'CustomInputSchema'
    'EventGridEvent'
    'EventGridSchema'
  ]
  ```

### Parameter: `expirationTimeUtc`

The expiration time for the event subscription. Format is ISO-8601 (yyyy-MM-ddTHH:mm:ssZ).

- Required: No
- Type: string

### Parameter: `filter`

The filter for the event subscription.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`advancedFilters`](#parameter-filteradvancedfilters) | array | A list of advanced filters. Each filter should contain operatorType, key, and value/values properties. |
| [`enableAdvancedFilteringOnArrays`](#parameter-filterenableadvancedfilteringonarrays) | bool | Allows advanced filters to be evaluated against an array of values instead of expecting a singular value. |
| [`includedEventTypes`](#parameter-filterincludedeventtypes) | array | A list of applicable event types that can be filtered. |
| [`isSubjectCaseSensitive`](#parameter-filterissubjectcasesensitive) | bool | Defines if the subject field should be compared in a case sensitive manner. |
| [`subjectBeginsWith`](#parameter-filtersubjectbeginswith) | string | An optional string to filter events for an event subscription based on a resource path prefix. |
| [`subjectEndsWith`](#parameter-filtersubjectendswith) | string | An optional string to filter events for an event subscription based on a resource path suffix. |

### Parameter: `filter.advancedFilters`

A list of advanced filters. Each filter should contain operatorType, key, and value/values properties.

- Required: No
- Type: array

### Parameter: `filter.enableAdvancedFilteringOnArrays`

Allows advanced filters to be evaluated against an array of values instead of expecting a singular value.

- Required: No
- Type: bool

### Parameter: `filter.includedEventTypes`

A list of applicable event types that can be filtered.

- Required: No
- Type: array

### Parameter: `filter.isSubjectCaseSensitive`

Defines if the subject field should be compared in a case sensitive manner.

- Required: No
- Type: bool

### Parameter: `filter.subjectBeginsWith`

An optional string to filter events for an event subscription based on a resource path prefix.

- Required: No
- Type: string

### Parameter: `filter.subjectEndsWith`

An optional string to filter events for an event subscription based on a resource path suffix.

- Required: No
- Type: string

### Parameter: `labels`

The list of user defined labels.

- Required: No
- Type: array

### Parameter: `retryPolicy`

The retry policy for events.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventTimeToLiveInMinutes`](#parameter-retrypolicyeventtimetoliveinminutes) | int | Time in minutes that determines how long to continue attempting delivery. |
| [`maxDeliveryAttempts`](#parameter-retrypolicymaxdeliveryattempts) | int | The maximum number of delivery attempts for events. |

### Parameter: `retryPolicy.eventTimeToLiveInMinutes`

Time in minutes that determines how long to continue attempting delivery.

- Required: No
- Type: int

### Parameter: `retryPolicy.maxDeliveryAttempts`

The maximum number of delivery attempts for events.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the event subscription. |
| `resourceGroupName` | string | The name of the resource group the event subscription was deployed into. |
| `resourceId` | string | The resource ID of the event subscription. |
