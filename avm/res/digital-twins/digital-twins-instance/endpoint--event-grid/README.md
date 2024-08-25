# Digital Twins Instance Event Grid Endpoints `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints]`

This module deploys a Digital Twins Instance Event Grid Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DigitalTwins/digitalTwinsInstances/endpoints` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DigitalTwins/2023-01-31/digitalTwinsInstances/endpoints) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventGridDomainResourceId`](#parameter-eventgriddomainresourceid) | string | The resource ID of the Event Grid to get access keys from. |
| [`topicEndpoint`](#parameter-topicendpoint) | string | EventGrid Topic Endpoint. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`digitalTwinInstanceName`](#parameter-digitaltwininstancename) | string | The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deadLetterSecret`](#parameter-deadlettersecret) | securestring | Dead letter storage secret for key-based authentication. Will be obfuscated during read. |
| [`deadLetterUri`](#parameter-deadletteruri) | string | Dead letter storage URL for identity-based authentication. |
| [`name`](#parameter-name) | string | The name of the Digital Twin Endpoint. |

### Parameter: `eventGridDomainResourceId`

The resource ID of the Event Grid to get access keys from.

- Required: Yes
- Type: string

### Parameter: `topicEndpoint`

EventGrid Topic Endpoint.

- Required: Yes
- Type: string

### Parameter: `digitalTwinInstanceName`

The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `deadLetterSecret`

Dead letter storage secret for key-based authentication. Will be obfuscated during read.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `deadLetterUri`

Dead letter storage URL for identity-based authentication.

- Required: No
- Type: string
- Default: `''`

### Parameter: `name`

The name of the Digital Twin Endpoint.

- Required: No
- Type: string
- Default: `'EventGridEndpoint'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Endpoint. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the Endpoint. |
