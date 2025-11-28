# DBforMySQL Flexible Server Advanced Threat Protection `[Microsoft.DBforMySQL/flexibleServers]`

This module enables Advanced Threat Protection for DBforMySQL Flexible Server.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed threat protection. |
| `resourceGroupName` | string | The resource group of the deployed threat protection. |
| `resourceId` | string | The resource ID of the deployed threat protection. |
