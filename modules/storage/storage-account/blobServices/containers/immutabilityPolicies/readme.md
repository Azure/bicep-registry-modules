# Blob Container Immutability Policy `[Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies]`

This module deploys an Immutability Policy for a blob container

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2019-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `containerName` | string | Name of the container to apply the policy to |
| `storageAccountName` | string | Name of the Storage Account. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `allowProtectedAppendWrites` | bool | `True` | This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API |
| `blobServicesName` | string | `'default'` | Name of the blob service. |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `immutabilityPeriodSinceCreationInDays` | int | `365` | The immutability period for the blobs in the container since the policy creation, in days. |
| `name` | string | `'default'` | Name of the immutable policy. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed immutability policy. |
| `resourceGroupName` | string | The resource group of the deployed immutability policy. |
| `resourceId` | string | The resource ID of the deployed immutability policy. |

## Template references

- [Storageaccounts/Blobservices/Containers/Immutabilitypolicies](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2019-06-01/storageAccounts/blobServices/containers/immutabilityPolicies)
