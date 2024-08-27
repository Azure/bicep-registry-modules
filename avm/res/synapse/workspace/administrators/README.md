# Synapse Workspaces Administrators `[Microsoft.Synapse/workspaces/administrators]`

This module deploys Synapse Workspaces Administrators.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Synapse/workspaces/administrators` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/administrators) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorType`](#parameter-administratortype) | string | Workspace active directory administrator type. |
| [`login`](#parameter-login) | securestring | Login of the workspace active directory administrator. |
| [`sid`](#parameter-sid) | securestring | Object ID of the workspace active directory administrator. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tenantId`](#parameter-tenantid) | string | Tenant ID of the workspace active directory administrator. |

### Parameter: `administratorType`

Workspace active directory administrator type.

- Required: Yes
- Type: string

### Parameter: `login`

Login of the workspace active directory administrator.

- Required: Yes
- Type: securestring

### Parameter: `sid`

Object ID of the workspace active directory administrator.

- Required: Yes
- Type: securestring

### Parameter: `workspaceName`

The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `tenantId`

Tenant ID of the workspace active directory administrator.

- Required: No
- Type: string
- Default: `[tenant().tenantId]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed administrator. |
| `resourceGroupName` | string | The resource group of the deployed administrator. |
| `resourceId` | string | The resource ID of the deployed administrator. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
