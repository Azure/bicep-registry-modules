# DBforMySQL Flexible Server Advanced Threat Protection `[Microsoft.DBforMySQL/flexibleServers]`

This module enables Advanced Threat Protection for DBforMySQL Flexible Server.

You can reference the module as follows:
```bicep
module flexibleServer 'br/public:avm/res/db-for-my-sql/flexible-server/advanced-threat-protection:<version>' = {
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
| `Microsoft.DBforMySQL/flexibleServers/advancedThreatProtectionSettings` | 2024-12-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbformysql_flexibleservers_advancedthreatprotectionsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2024-12-30/flexibleServers/advancedThreatProtectionSettings)</li></ul> |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent DBforMySQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`advancedThreatProtection`](#parameter-advancedthreatprotection) | string | The state of the advanced threat protection. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

### Parameter: `flexibleServerName`

The name of the parent DBforMySQL flexible server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `advancedThreatProtection`

The state of the advanced threat protection.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed threat protection. |
| `resourceGroupName` | string | The resource group of the deployed threat protection. |
| `resourceId` | string | The resource ID of the deployed threat protection. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
