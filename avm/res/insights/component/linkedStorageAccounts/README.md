# Application Insights Linked Storage Account `[microsoft.insights/components/linkedStorageAccounts]`

This component deploys an Application Insights Linked Storage Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `microsoft.insights/components/linkedStorageAccounts` | [2020-03-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | Linked storage account resource ID. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appInsightsName`](#parameter-appinsightsname) | string | The name of the parent Application Insights instance. Required if the template is used in a standalone deployment. |

### Parameter: `storageAccountResourceId`

Linked storage account resource ID.

- Required: Yes
- Type: string

### Parameter: `appInsightsName`

The name of the parent Application Insights instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Linked Storage Account. |
| `resourceGroupName` | string | The resource group the agent pool was deployed into. |
| `resourceId` | string | The resource ID of the Linked Storage Account. |
