# Network Manager Scope Connections `[Microsoft.Network/networkManagers/scopeConnections]`

This module deploys a Network Manager Scope Connection.
Create a cross-tenant connection to manage a resource from another tenant.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkManagers/scopeConnections` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkManagers/scopeConnections) |

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


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed scope connection. |
| `resourceGroupName` | string | The resource group the scope connection was deployed into. |
| `resourceId` | string | The resource ID of the deployed scope connection. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
