# DBforPostgreSQL Flexible Server Databases `[Microsoft.DBforPostgreSQL/flexibleServers/databases]`

This module deploys a DBforPostgreSQL Flexible Server Database.

You can reference the module as follows:
```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server/database:<version>' = {
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
| `Microsoft.DBforPostgreSQL/flexibleServers/databases` | 2026-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_databases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2026-01-01-preview/flexibleServers/databases)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`charset`](#parameter-charset) | string | The charset of the database. |
| [`collation`](#parameter-collation) | string | The collation of the database. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

### Parameter: `name`

The name of the database.

- Required: Yes
- Type: string

### Parameter: `flexibleServerName`

The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `charset`

The charset of the database.

- Required: No
- Type: string

### Parameter: `collation`

The collation of the database.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed database. |
| `resourceGroupName` | string | The resource group name of the deployed database. |
| `resourceId` | string | The resource ID of the deployed database. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
