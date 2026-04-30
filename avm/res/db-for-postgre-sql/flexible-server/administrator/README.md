# DBforPostgreSQL Flexible Server Administrators `[Microsoft.DBforPostgreSQL/flexibleServers/administrators]`

This module deploys a DBforPostgreSQL Flexible Server Administrator.

You can reference the module as follows:
```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server/administrator:<version>' = {
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
| `Microsoft.DBforPostgreSQL/flexibleServers/administrators` | 2026-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_administrators.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2026-01-01-preview/flexibleServers/administrators)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`tenantId`](#parameter-tenantid) | string | The tenantId of the Active Directory administrator. |

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

### Parameter: `flexibleServerName`

The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
