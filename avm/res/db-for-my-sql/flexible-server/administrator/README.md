# DBforMySQL Flexible Server Administrators `[Microsoft.DBforMySQL/flexibleServers/administrators]`

This module deploys a DBforMySQL Flexible Server Administrator.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforMySQL/flexibleServers/administrators` | [2023-06-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2023-06-30/flexibleServers/administrators) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identityResourceId`](#parameter-identityresourceid) | string | The resource ID of the identity used for AAD Authentication. |
| [`login`](#parameter-login) | string | Login name of the server administrator. |
| [`sid`](#parameter-sid) | string | SID (object ID) of the server administrator. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent DBforMySQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tenantId`](#parameter-tenantid) | string | The tenantId of the Active Directory administrator. |

### Parameter: `identityResourceId`

The resource ID of the identity used for AAD Authentication.

- Required: Yes
- Type: string

### Parameter: `login`

Login name of the server administrator.

- Required: Yes
- Type: string

### Parameter: `sid`

SID (object ID) of the server administrator.

- Required: Yes
- Type: string

### Parameter: `flexibleServerName`

The name of the parent DBforMySQL flexible server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `tenantId`

The tenantId of the Active Directory administrator.

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
