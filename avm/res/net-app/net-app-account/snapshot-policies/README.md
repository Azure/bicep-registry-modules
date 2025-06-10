# Azure NetApp Files Snapshot Policy `[Microsoft.NetApp/netAppAccounts/snapshotPolicies]`

This module deploys a Snapshot Policy for an Azure NetApp File.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/snapshotPolicies` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2025-01-01/netAppAccounts/snapshotPolicies) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailySchedule`](#parameter-dailyschedule) | object | Schedule for daily snapshots. |
| [`hourlySchedule`](#parameter-hourlyschedule) | object | Schedule for hourly snapshots. |
| [`location`](#parameter-location) | string | The location of the snapshot policy. |
| [`monthlySchedule`](#parameter-monthlyschedule) | object | Schedule for monthly snapshots. |
| [`name`](#parameter-name) | string | The name of the snapshot policy. |
| [`snapEnabled`](#parameter-snapenabled) | bool | Indicates whether the snapshot policy is enabled. |
| [`weeklySchedule`](#parameter-weeklyschedule) | object | Schedule for weekly snapshots. |

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `dailySchedule`

Schedule for daily snapshots.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hour`](#parameter-dailyschedulehour) | int | The daily snapshot hour. |
| [`minute`](#parameter-dailyscheduleminute) | int | The daily snapshot minute. |
| [`snapshotsToKeep`](#parameter-dailyschedulesnapshotstokeep) | int | Daily snapshot count to keep. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`usedBytes`](#parameter-dailyscheduleusedbytes) | int | Resource size in bytes, current storage usage for the volume in bytes. |

### Parameter: `dailySchedule.hour`

The daily snapshot hour.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 23

### Parameter: `dailySchedule.minute`

The daily snapshot minute.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 59

### Parameter: `dailySchedule.snapshotsToKeep`

Daily snapshot count to keep.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 255

### Parameter: `dailySchedule.usedBytes`

Resource size in bytes, current storage usage for the volume in bytes.

- Required: No
- Type: int

### Parameter: `hourlySchedule`

Schedule for hourly snapshots.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`minute`](#parameter-hourlyscheduleminute) | int | The hourly snapshot minute. |
| [`snapshotsToKeep`](#parameter-hourlyschedulesnapshotstokeep) | int | Hourly snapshot count to keep. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`usedBytes`](#parameter-hourlyscheduleusedbytes) | int | Resource size in bytes, current storage usage for the volume in bytes. |

### Parameter: `hourlySchedule.minute`

The hourly snapshot minute.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 59

### Parameter: `hourlySchedule.snapshotsToKeep`

Hourly snapshot count to keep.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 255

### Parameter: `hourlySchedule.usedBytes`

Resource size in bytes, current storage usage for the volume in bytes.

- Required: No
- Type: int

### Parameter: `location`

The location of the snapshot policy.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `monthlySchedule`

Schedule for monthly snapshots.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`daysOfMonth`](#parameter-monthlyscheduledaysofmonth) | string | Indicates which days of the month snapshot should be taken. A comma delimited string. E.g., '10,11,12'. |
| [`hour`](#parameter-monthlyschedulehour) | int | The monthly snapshot hour. |
| [`minute`](#parameter-monthlyscheduleminute) | int | The monthly snapshot minute. |
| [`snapshotsToKeep`](#parameter-monthlyschedulesnapshotstokeep) | int | Monthly snapshot count to keep. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`usedBytes`](#parameter-monthlyscheduleusedbytes) | int | Resource size in bytes, current storage usage for the volume in bytes. |

### Parameter: `monthlySchedule.daysOfMonth`

Indicates which days of the month snapshot should be taken. A comma delimited string. E.g., '10,11,12'.

- Required: Yes
- Type: string

### Parameter: `monthlySchedule.hour`

The monthly snapshot hour.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 23

### Parameter: `monthlySchedule.minute`

The monthly snapshot minute.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 59

### Parameter: `monthlySchedule.snapshotsToKeep`

Monthly snapshot count to keep.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 255

### Parameter: `monthlySchedule.usedBytes`

Resource size in bytes, current storage usage for the volume in bytes.

- Required: No
- Type: int

### Parameter: `name`

The name of the snapshot policy.

- Required: No
- Type: string
- Default: `'snapshotPolicy'`

### Parameter: `snapEnabled`

Indicates whether the snapshot policy is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `weeklySchedule`

Schedule for weekly snapshots.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`day`](#parameter-weeklyscheduleday) | string | The weekly snapshot day. |
| [`hour`](#parameter-weeklyschedulehour) | int | The weekly snapshot hour. |
| [`minute`](#parameter-weeklyscheduleminute) | int | The weekly snapshot minute. |
| [`snapshotsToKeep`](#parameter-weeklyschedulesnapshotstokeep) | int | Weekly snapshot count to keep. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`usedBytes`](#parameter-weeklyscheduleusedbytes) | int | Resource size in bytes, current storage usage for the volume in bytes. |

### Parameter: `weeklySchedule.day`

The weekly snapshot day.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Friday'
    'Monday'
    'Saturday'
    'Sunday'
    'Thursday'
    'Tuesday'
    'Wednesday'
  ]
  ```

### Parameter: `weeklySchedule.hour`

The weekly snapshot hour.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 23

### Parameter: `weeklySchedule.minute`

The weekly snapshot minute.

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 59

### Parameter: `weeklySchedule.snapshotsToKeep`

Weekly snapshot count to keep.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 255

### Parameter: `weeklySchedule.usedBytes`

Resource size in bytes, current storage usage for the volume in bytes.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Backup Policy. |
| `resourceGroupName` | string | The name of the Resource Group the Snapshot was created in. |
| `resourceId` | string | The resource IDs of the snapshot Policy created within volume. |
