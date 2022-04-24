# Storage Account blob services `[Microsoft.Storage/storageAccounts/blobServices]`

This module can be used to deploy a blob service into a storage account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2021-04-01-preview |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview |
| `Microsoft.Storage/storageAccounts/blobServices` | 2021-06-01 |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2019-06-01 |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2019-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `storageAccountName` | string | Name of the Storage Account. |

**Optional parameters**
| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `automaticSnapshotPolicyEnabled` | bool | `False` |  | Automatic Snapshot is enabled if set to true. |
| `containers` | _[containers](containers/readme.md)_ array | `[]` |  | Blob containers to create. |
| `deleteRetentionPolicy` | bool | `True` |  | Indicates whether DeleteRetentionPolicy is enabled for the Blob service. |
| `deleteRetentionPolicyDays` | int | `7` |  | Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365. |
| `diagnosticEventHubAuthorizationRuleId` | string | `''` |  | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `diagnosticEventHubName` | string | `''` |  | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `diagnosticLogCategoriesToEnable` | array | `[StorageRead, StorageWrite, StorageDelete]` | `[StorageRead, StorageWrite, StorageDelete]` | The name of logs that will be streamed. |
| `diagnosticLogsRetentionInDays` | int | `365` |  | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticMetricsToEnable` | array | `[Transaction]` | `[Transaction]` | The name of metrics that will be streamed. |
| `diagnosticSettingsName` | string | `[format('{0}-diagnosticSettings', parameters('name'))]` |  | The name of the diagnostic setting, if deployed. |
| `diagnosticStorageAccountId` | string | `''` |  | Resource ID of the diagnostic storage account. |
| `diagnosticWorkspaceId` | string | `''` |  | Resource ID of a log analytics workspace. |
| `enableDefaultTelemetry` | bool | `True` |  | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `name` | string | `'default'` |  | The name of the blob service |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed blob service |
| `resourceGroupName` | string | The name of the deployed blob service |
| `resourceId` | string | The resource ID of the deployed blob service |

## Template references

- [Diagnosticsettings](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)
- [Roleassignments](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments)
- [Storageaccounts/Blobservices](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-06-01/storageAccounts/blobServices)
- [Storageaccounts/Blobservices/Containers](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices/containers)
- [Storageaccounts/Blobservices/Containers/Immutabilitypolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices/containers/immutabilityPolicies)
