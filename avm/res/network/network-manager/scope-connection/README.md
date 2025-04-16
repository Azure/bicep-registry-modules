# Network Manager Scope Connections `[Microsoft.Network/networkManagers/scopeConnections]`

This module deploys a Network Manager Scope Connection.
Create a cross-tenant connection to manage a resource from another tenant.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/scopeConnections` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkManagers/scopeConnections) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the scope connection. |
| [`resourceId`](#parameter-resourceid) | string | Enter the subscription or management group resource ID that you want to add to this network manager's scope. |
| [`tenantId`](#parameter-tenantid) | string | Tenant ID of the subscription or management group that you want to manage. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkManagerName`](#parameter-networkmanagername) | string | The name of the parent network manager. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | A description of the scope connection. |

### Parameter: `name`

The name of the scope connection.

- Required: Yes
- Type: string

### Parameter: `resourceId`

Enter the subscription or management group resource ID that you want to add to this network manager's scope.

- Required: Yes
- Type: string

### Parameter: `tenantId`

Tenant ID of the subscription or management group that you want to manage.

- Required: Yes
- Type: string

### Parameter: `networkManagerName`

The name of the parent network manager. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

A description of the scope connection.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed scope connection. |
| `resourceGroupName` | string | The resource group the scope connection was deployed into. |
| `resourceId` | string | The resource ID of the deployed scope connection. |
