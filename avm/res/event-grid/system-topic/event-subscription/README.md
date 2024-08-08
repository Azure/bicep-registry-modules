# Event Grid System Topic Event Subscriptions `[Microsoft.EventGrid/systemTopics/eventSubscriptions]`

This module deploys an Event Grid System Topic Event Subscription.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventGrid/systemTopics/eventSubscriptions` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/systemTopics/eventSubscriptions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-destination) | object | The destination for the event subscription. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#eventsubscriptiondestination-objects for more information). |
| [`name`](#parameter-name) | string | The name of the Event Subscription. |
| [`systemTopicName`](#parameter-systemtopicname) | string | Name of the Event Grid System Topic. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deadLetterDestination`](#parameter-deadletterdestination) | object | Dead Letter Destination. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterdestination-objects for more information). |
| [`deadLetterWithResourceIdentity`](#parameter-deadletterwithresourceidentity) | object | Dead Letter with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterwithresourceidentity-objects for more information). |
| [`deliveryWithResourceIdentity`](#parameter-deliverywithresourceidentity) | object | Delivery with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deliverywithresourceidentity-objects for more information). |
| [`eventDeliverySchema`](#parameter-eventdeliveryschema) | string | The event delivery schema for the event subscription. |
| [`expirationTimeUtc`](#parameter-expirationtimeutc) | string | The expiration time for the event subscription. Format is ISO-8601 (yyyy-MM-ddTHH:mm:ssZ). |
| [`filter`](#parameter-filter) | object | The filter for the event subscription. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#eventsubscriptionfilter for more information). |
| [`labels`](#parameter-labels) | array | The list of user defined labels. |
| [`retryPolicy`](#parameter-retrypolicy) | object | The retry policy for events. This can be used to configure the TTL and maximum number of delivery attempts and time to live for events. |

### Parameter: `destination`

The destination for the event subscription. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#eventsubscriptiondestination-objects for more information).

- Required: Yes
- Type: object

### Parameter: `name`

The name of the Event Subscription.

- Required: Yes
- Type: string

### Parameter: `systemTopicName`

Name of the Event Grid System Topic.

- Required: Yes
- Type: string

### Parameter: `deadLetterDestination`

Dead Letter Destination. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterdestination-objects for more information).

- Required: No
- Type: object
- Default: `{}`

### Parameter: `deadLetterWithResourceIdentity`

Dead Letter with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deadletterwithresourceidentity-objects for more information).

- Required: No
- Type: object
- Default: `{}`

### Parameter: `deliveryWithResourceIdentity`

Delivery with Resource Identity Configuration. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#deliverywithresourceidentity-objects for more information).

- Required: No
- Type: object
- Default: `{}`

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
- Default: `''`

### Parameter: `filter`

The filter for the event subscription. (See https://learn.microsoft.com/en-us/azure/templates/microsoft.eventgrid/eventsubscriptions?pivots=deployment-language-bicep#eventsubscriptionfilter for more information).

- Required: No
- Type: object
- Default: `{}`

### Parameter: `labels`

The list of user defined labels.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `retryPolicy`

The retry policy for events. This can be used to configure the TTL and maximum number of delivery attempts and time to live for events.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the event subscription. |
| `resourceGroupName` | string | The name of the resource group the event subscription was deployed into. |
| `resourceId` | string | The resource ID of the event subscription. |
