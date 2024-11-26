# DBforPostgreSQL Flexible Server Administrators `[Microsoft.DBforPostgreSQL/flexibleServers]`

This module deploys a DBforPostgreSQL Flexible Server Administrator.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings` | [2024-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2024-08-01/flexibleServers/advancedThreatProtectionSettings) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverThreatProtection`](#parameter-serverthreatprotection) | string | Specifies the state of the Threat Protection, whether it is enabled or disabled or a state has not been applied yet on the specific server. |

### Parameter: `flexibleServerName`

The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The resource group of the deployed administrator. |
