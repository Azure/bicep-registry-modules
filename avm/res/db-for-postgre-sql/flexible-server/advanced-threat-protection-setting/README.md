# DBforPostgreSQL Flexible Server Advanced Threat Protection `[Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings]`

This module deploys a DBforPostgreSQL Advanced Threat Protection.

You can reference the module as follows:
```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server/advanced-threat-protection-setting:<version>' = {
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
| `Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings` | 2026-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_advancedthreatprotectionsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2026-01-01-preview/flexibleServers/advancedThreatProtectionSettings)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverThreatProtection`](#parameter-serverthreatprotection) | string | Specifies the state of the Threat Protection, whether it is enabled or disabled or a state has not been applied yet on the specific server. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

### Parameter: `serverThreatProtection`

Specifies the state of the Threat Protection, whether it is enabled or disabled or a state has not been applied yet on the specific server.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `advancedTreatProtectionState` | string | The advanced threat protection state for the flexible server. |
| `name` | string | The resource id of the advanced threat protection state for the flexible server. |
| `resourceGroupName` | string | The resource group of the deployed administrator. |
| `resourceId` | string | The resource id of the advanced threat protection state for the flexible server. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
