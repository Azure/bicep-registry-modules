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

### Parameter: `deliveryWithResourceIdentity`

Delivery with Resource Identity Configuration.

- Required: No
- Type: object

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

### Parameter: `labels`

The list of user defined labels.

- Required: No
- Type: array

### Parameter: `retryPolicy`

The retry policy for events.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the event subscription. |
| `resourceGroupName` | string | The name of the resource group the event subscription was deployed into. |
| `resourceId` | string | The resource ID of the event subscription. |
