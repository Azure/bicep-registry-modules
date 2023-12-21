# DBforMySQL Flexible Server Administrators `[Microsoft.DBforMySQL/flexibleServers/administrators]`

This module deploys a DBforMySQL Flexible Server Administrator.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforMySQL/flexibleServers/administrators` | [2022-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2022-01-01/flexibleServers/administrators) |

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
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
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

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

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
