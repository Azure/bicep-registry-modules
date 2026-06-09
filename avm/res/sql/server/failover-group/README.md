# Azure SQL Server failover group `[Microsoft.Sql/servers/failoverGroups]`

This module deploys Azure SQL Server failover group.

You can reference the module as follows:
```bicep
module server 'br/public:avm/res/sql/server/failover-group:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Sql/servers/failoverGroups` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_servers_failovergroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2025-01-01/servers/failoverGroups)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databases`](#parameter-databases) | array | List of databases in the failover group. |
| [`name`](#parameter-name) | string | The name of the failover group. |
| [`partnerServerResourceIds`](#parameter-partnerserverresourceids) | array | List of the partner server Resource Ids for the failover group. |
| [`readWriteEndpoint`](#parameter-readwriteendpoint) | object | Read-write endpoint of the failover group instance. |
| [`secondaryType`](#parameter-secondarytype) | string | Databases secondary type on partner server. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverName`](#parameter-servername) | string | The Name of SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`readOnlyEndpoint`](#parameter-readonlyendpoint) | object | Read-only endpoint of the failover group instance. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `databases`

List of databases in the failover group.

- Required: Yes
- Type: array

### Parameter: `name`

The name of the failover group.

- Required: Yes
- Type: string

### Parameter: `partnerServerResourceIds`

List of the partner server Resource Ids for the failover group.

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed failover group. |
| `resourceGroupName` | string | The resource group of the deployed failover group. |
| `resourceId` | string | The resource ID of the deployed failover group. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
