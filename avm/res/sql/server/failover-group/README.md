# Azure SQL Server failover group `[Microsoft.Sql/servers/failoverGroups]`

This module deploys Azure SQL Server failover group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/failoverGroups` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/servers/failoverGroups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databases`](#parameter-databases) | array | List of databases in the failover group. |
| [`name`](#parameter-name) | string | The name of the failover group. |
| [`partnerServers`](#parameter-partnerservers) | array | List of the partner servers for the failover group. |
| [`readWriteEndpoint`](#parameter-readwriteendpoint) | object | Read-write endpoint of the failover group instance. |
| [`secondaryType`](#parameter-secondarytype) | string | Databases secondary type on partner server. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverName`](#parameter-servername) | string | The Name of SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`readOnlyEndpoint`](#parameter-readonlyendpoint) | object | Read-only endpoint of the failover group instance. |

### Parameter: `databases`

List of databases in the failover group.

- Required: Yes
- Type: array

### Parameter: `name`

The name of the failover group.

- Required: Yes
- Type: string

### Parameter: `partnerServers`

List of the partner servers for the failover group.

- Required: Yes
- Type: array

### Parameter: `readWriteEndpoint`

Read-write endpoint of the failover group instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`failoverPolicy`](#parameter-readwriteendpointfailoverpolicy) | string | Failover policy of the read-write endpoint for the failover group. If failoverPolicy is Automatic then failoverWithDataLossGracePeriodMinutes is required. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`failoverWithDataLossGracePeriodMinutes`](#parameter-readwriteendpointfailoverwithdatalossgraceperiodminutes) | int | Grace period before failover with data loss is attempted for the read-write endpoint. |

### Parameter: `readWriteEndpoint.failoverPolicy`

Failover policy of the read-write endpoint for the failover group. If failoverPolicy is Automatic then failoverWithDataLossGracePeriodMinutes is required.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Automatic'
    'Manual'
  ]
  ```

### Parameter: `readWriteEndpoint.failoverWithDataLossGracePeriodMinutes`

Grace period before failover with data loss is attempted for the read-write endpoint.

- Required: No
- Type: int

### Parameter: `secondaryType`

Databases secondary type on partner server.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Geo'
    'Standby'
  ]
  ```

### Parameter: `serverName`

The Name of SQL Server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `readOnlyEndpoint`

Read-only endpoint of the failover group instance.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`failoverPolicy`](#parameter-readonlyendpointfailoverpolicy) | string | Failover policy of the read-only endpoint for the failover group. |
| [`targetServer`](#parameter-readonlyendpointtargetserver) | string | The target partner server where the read-only endpoint points to. |

### Parameter: `readOnlyEndpoint.failoverPolicy`

Failover policy of the read-only endpoint for the failover group.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `readOnlyEndpoint.targetServer`

The target partner server where the read-only endpoint points to.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed failover group. |
| `resourceGroupName` | string | The resource group of the deployed failover group. |
| `resourceId` | string | The resource ID of the deployed failover group. |
