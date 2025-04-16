# Storage Account Blob Container Immutability Policies `[Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies]`

This module deploys a Storage Account Blob Container Immutability Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerName`](#parameter-containername) | string | The name of the parent container to apply the policy to. Required if the template is used in a standalone deployment. |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowProtectedAppendWrites`](#parameter-allowprotectedappendwrites) | bool | This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. |
| [`allowProtectedAppendWritesAll`](#parameter-allowprotectedappendwritesall) | bool | This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to both "Append and Block Blobs" while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. The "allowProtectedAppendWrites" and "allowProtectedAppendWritesAll" properties are mutually exclusive. |
| [`immutabilityPeriodSinceCreationInDays`](#parameter-immutabilityperiodsincecreationindays) | int | The immutability period for the blobs in the container since the policy creation, in days. |

### Parameter: `containerName`

The name of the parent container to apply the policy to. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `storageAccountName`

The name of the parent Storage Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `allowProtectedAppendWrites`

This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `allowProtectedAppendWritesAll`

This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to both "Append and Block Blobs" while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. The "allowProtectedAppendWrites" and "allowProtectedAppendWritesAll" properties are mutually exclusive.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `immutabilityPeriodSinceCreationInDays`

The immutability period for the blobs in the container since the policy creation, in days.

- Required: No
- Type: int
- Default: `365`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed immutability policy. |
| `resourceGroupName` | string | The resource group of the deployed immutability policy. |
| `resourceId` | string | The resource ID of the deployed immutability policy. |
