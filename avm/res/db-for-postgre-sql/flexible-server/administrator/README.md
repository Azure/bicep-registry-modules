# DBforPostgreSQL Flexible Server Administrators `[Microsoft.DBforPostgreSQL/flexibleServers/administrators]`

This module deploys a DBforPostgreSQL Flexible Server Administrator.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforPostgreSQL/flexibleServers/administrators` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/administrators) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`objectId`](#parameter-objectid) | string | The objectId of the Active Directory administrator. |
| [`principalName`](#parameter-principalname) | string | Active Directory administrator principal name. |
| [`principalType`](#parameter-principaltype) | string | The principal type used to represent the type of Active Directory Administrator. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`tenantId`](#parameter-tenantid) | string | The tenantId of the Active Directory administrator. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `flexibleServerName`

The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `objectId`

The objectId of the Active Directory administrator.
- Required: Yes
- Type: string

### Parameter: `principalName`

Active Directory administrator principal name.
- Required: Yes
- Type: string

### Parameter: `principalType`

The principal type used to represent the type of Active Directory Administrator.
- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Group'
    'ServicePrincipal'
    'Unknown'
    'User'
  ]
  ```

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
