# Dev Center Attached Network `[Microsoft.DevCenter/devcenters/attachednetworks]`

This module deploys a Dev Center Attached Network.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevCenter/devcenters/attachednetworks` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/attachednetworks) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the attached network. |
| [`networkConnectionResourceId`](#parameter-networkconnectionresourceid) | string | The resource ID of the Network Connection you want to attach to the Dev Center. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devcenterName`](#parameter-devcentername) | string | The name of the parent dev center. Required if the template is used in a standalone deployment. |

### Parameter: `name`

The name of the attached network.

- Required: Yes
- Type: string

### Parameter: `networkConnectionResourceId`

The resource ID of the Network Connection you want to attach to the Dev Center.

- Required: Yes
- Type: string

### Parameter: `devcenterName`

The name of the parent dev center. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Dev Center Attached Network. |
| `resourceGroupName` | string | The name of the resource group the Dev Center Attached Network was created in. |
| `resourceId` | string | The resource ID of the Dev Center Attached Network. |
