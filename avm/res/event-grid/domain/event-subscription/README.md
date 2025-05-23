# Event Grid Domain Event Subscriptions `[Microsoft.EventGrid/domains/eventSubscriptions]`

This module deploys an Event Grid Domain Event Subscription.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventGrid/domains/eventSubscriptions` | [2025-02-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2025-02-15/domains/eventSubscriptions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-destination) | object | The destination for the event subscription. See EventSubscriptionDestination objects for full shape. |
| [`name`](#parameter-name) | string | The name of the Event Subscription. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainName`](#parameter-domainname) | string | The name of the parent event grid domain. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deadLetterDestination`](#parameter-deadletterdestination) | object | Dead Letter Destination. See DeadLetterDestination objects for full shape. |
| [`deadLetterWithResourceIdentity`](#parameter-deadletterwithresourceidentity) | object | Dead Letter with Resource Identity Configuration. See DeadLetterWithResourceIdentity objects for full shape. |
| [`deliveryWithResourceIdentity`](#parameter-deliverywithresourceidentity) | object | Delivery with Resource Identity Configuration. See DeliveryWithResourceIdentity objects for full shape. |
| [`eventDeliverySchema`](#parameter-eventdeliveryschema) | string | The event delivery schema for the event subscription. |
| [`expirationTimeUtc`](#parameter-expirationtimeutc) | string | The expiration time for the event subscription. Format is ISO-8601 (yyyy-MM-ddTHH:mm:ssZ). |
| [`filter`](#parameter-filter) | object | The filter for the event subscription. See EventSubscriptionFilter objects for full shape. |
| [`labels`](#parameter-labels) | array | The list of user defined labels. |
| [`retryPolicy`](#parameter-retrypolicy) | object | The retry policy for events. See RetryPolicy objects for full shape. |

### Parameter: `destination`

The destination for the event subscription. See EventSubscriptionDestination objects for full shape.

- Required: Yes
- Type: object

### Parameter: `name`

The name of the Event Subscription.

- Required: Yes
- Type: string

### Parameter: `domainName`

The name of the parent event grid domain. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `deadLetterDestination`

Dead Letter Destination. See DeadLetterDestination objects for full shape.

- Required: No
- Type: object

### Parameter: `deadLetterWithResourceIdentity`

Dead Letter with Resource Identity Configuration. See DeadLetterWithResourceIdentity objects for full shape.

- Required: No
- Type: object

### Parameter: `deliveryWithResourceIdentity`

Delivery with Resource Identity Configuration. See DeliveryWithResourceIdentity objects for full shape.

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

The filter for the event subscription. See EventSubscriptionFilter objects for full shape.

- Required: No
- Type: object

### Parameter: `labels`

The list of user defined labels.

- Required: No
- Type: array

### Parameter: `retryPolicy`

The retry policy for events. See RetryPolicy objects for full shape.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the event subscription. |
| `resourceGroupName` | string | The name of the resource group the event subscription was deployed into. |
| `resourceId` | string | The resource ID of the event subscription. |
