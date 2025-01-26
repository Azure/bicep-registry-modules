# Digital Twins Instance Endpoint `[Microsoft.DigitalTwins/digitalTwinsInstances/endpoints]`

This module deploys a Digital Twins Instance Endpoint.

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
| [`name`](#parameter-name) | string | The name of the Digital Twin Endpoint. |
| [`properties`](#parameter-properties) | object | The properties of the endpoint. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`digitalTwinInstanceName`](#parameter-digitaltwininstancename) | string | The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment. |

### Parameter: `name`

The name of the Digital Twin Endpoint.

- Required: Yes
- Type: string

### Parameter: `properties`

The properties of the endpoint.

- Required: Yes
- Type: object

### Parameter: `digitalTwinInstanceName`

The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Endpoint. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the Endpoint. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. Note: As of 2024-03 is not exported by API. |
