# Azure NetApp Files Snapshot Policy `[Microsoft.NetApp/netAppAccounts/snapshotPolicies]`

This module deploys a Snapshot Policy for an Azure NetApp File.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/snapshotPolicies` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/snapshotPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyHour`](#parameter-dailyhour) | int | The daily snapshot hour. |
| [`dailyMinute`](#parameter-dailyminute) | int | The daily snapshot minute. |
| [`dailySnapshotsToKeep`](#parameter-dailysnapshotstokeep) | int | Daily snapshot count to keep. |
| [`dailyUsedBytes`](#parameter-dailyusedbytes) | int | Daily snapshot used bytes. |
| [`daysOfMonth`](#parameter-daysofmonth) | string | The monthly snapshot day. |
| [`hourlyMinute`](#parameter-hourlyminute) | int | The hourly snapshot minute. |
| [`hourlySnapshotsToKeep`](#parameter-hourlysnapshotstokeep) | int | Hourly snapshot count to keep. |
| [`hourlyUsedBytes`](#parameter-hourlyusedbytes) | int | Hourly snapshot used bytes. |
| [`monthlyHour`](#parameter-monthlyhour) | int | The monthly snapshot hour. |
| [`monthlyMinute`](#parameter-monthlyminute) | int | The monthly snapshot minute. |
| [`monthlySnapshotsToKeep`](#parameter-monthlysnapshotstokeep) | int | Monthly snapshot count to keep. |
| [`monthlyUsedBytes`](#parameter-monthlyusedbytes) | int | Monthly snapshot used bytes. |
| [`snapshotPolicyName`](#parameter-snapshotpolicyname) | string | The name of the snapshot policy. |
| [`weeklyDay`](#parameter-weeklyday) | string | The weekly snapshot day. |
| [`weeklyHour`](#parameter-weeklyhour) | int | The weekly snapshot hour. |
| [`weeklyMinute`](#parameter-weeklyminute) | int | The weekly snapshot minute. |
| [`weeklySnapshotsToKeep`](#parameter-weeklysnapshotstokeep) | int | Weekly snapshot count to keep. |
| [`weeklyUsedBytes`](#parameter-weeklyusedbytes) | int | Weekly snapshot used bytes. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`snapEnabled`](#parameter-snapenabled) | bool | Indicates whether the snapshot policy is enabled. |
| [`snapshotPolicyLocation`](#parameter-snapshotpolicylocation) | string | The location of the snapshot policy. |

### Parameter: `dailyHour`

The daily snapshot hour.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `dailyMinute`

The daily snapshot minute.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `dailySnapshotsToKeep`

Daily snapshot count to keep.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `dailyUsedBytes`

Daily snapshot used bytes.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `daysOfMonth`

The monthly snapshot day.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `hourlyMinute`

The hourly snapshot minute.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `hourlySnapshotsToKeep`

Hourly snapshot count to keep.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `hourlyUsedBytes`

Hourly snapshot used bytes.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `monthlyHour`

The monthly snapshot hour.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `monthlyMinute`

The monthly snapshot minute.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `monthlySnapshotsToKeep`

Monthly snapshot count to keep.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `monthlyUsedBytes`

Monthly snapshot used bytes.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `snapshotPolicyName`

The name of the snapshot policy.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `weeklyDay`

The weekly snapshot day.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `weeklyHour`

The weekly snapshot hour.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `weeklyMinute`

The weekly snapshot minute.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `weeklySnapshotsToKeep`

Weekly snapshot count to keep.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `weeklyUsedBytes`

Weekly snapshot used bytes.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `snapEnabled`

Indicates whether the snapshot policy is enabled.

- Required: No
- Type: bool
- Nullable: No
- Default: `True`

### Parameter: `snapshotPolicyLocation`

The location of the snapshot policy.

- Required: No
- Type: string
- Nullable: No
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Backup Policy. |
| `resourceGroupName` | string | The name of the Resource Group the Snapshot was created in. |
| `resourceId` | string | The resource IDs of the snapshot Policy created within volume. |
