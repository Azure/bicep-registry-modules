# Application Gateway for Containers Frontend `[Microsoft.ServiceNetworking/trafficControllers/frontends]`

This module deploys an Application Gateway for Containers Frontend

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceNetworking/trafficControllers/frontends` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceNetworking/2023-11-01/trafficControllers/frontends) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the frontend to create. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`trafficControllerName`](#parameter-trafficcontrollername) | string | The name of the parent Application Gateway for Containers instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all Resources. |

### Parameter: `name`

Name of the frontend to create.

- Required: Yes
- Type: string

### Parameter: `trafficControllerName`

The name of the parent Application Gateway for Containers instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `fqdn` | string | The FQDN of the frontend. |
| `name` | string | The name of the frontend. |
| `resourceGroupName` | string | The name of the resource group the resource was created in. |
| `resourceId` | string | The resource ID of the frontend. |
