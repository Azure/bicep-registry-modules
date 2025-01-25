# DBforPostgreSQL Flexible Server Advanced Threat Protection `[Microsoft.DBforPostgreSQL/flexibleServers]`

This module deploys a DBforPostgreSQL Advanced Threat Protection.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings` | [2024-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2024-08-01/flexibleServers/advancedThreatProtectionSettings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverThreatProtection`](#parameter-serverthreatprotection) | string | Specifies the state of the Threat Protection, whether it is enabled or disabled or a state has not been applied yet on the specific server. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment. |

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `advancedTreatProtectionState` | string | The advanced threat protection state for the flexible server. |
| `name` | string | The resource id of the advanced threat protection state for the flexible server. |
| `resourceGroupName` | string | The resource group of the deployed administrator. |
| `resourceId` | string | The resource id of the advanced threat protection state for the flexible server. |
