# Storage Account Blob Container Immutability Policies `[Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies]`

This module deploys a Storage Account Blob Container Immutability Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
