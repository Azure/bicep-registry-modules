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
- Default:
  ```Bicep
  {
      hour: 0
      minute: 0
      snapshotsToKeep: 0
      usedBytes: 0
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hour`](#parameter-dailyschedulehour) | int | The daily snapshot hour. |
| [`minute`](#parameter-dailyscheduleminute) | int | The daily snapshot minute. |
| [`snapshotsToKeep`](#parameter-dailyschedulesnapshotstokeep) | int | Daily snapshot count to keep. |
| [`usedBytes`](#parameter-dailyscheduleusedbytes) | int | Daily snapshot used bytes. |

### Parameter: `dailySchedule.hour`

The daily snapshot hour.

- Required: No
- Type: int

### Parameter: `dailySchedule.minute`

The daily snapshot minute.

- Required: No
- Type: int

### Parameter: `dailySchedule.snapshotsToKeep`

Daily snapshot count to keep.

- Required: No
- Type: int

### Parameter: `dailySchedule.usedBytes`

Daily snapshot used bytes.

- Required: No
- Type: int

### Parameter: `hourlySchedule`

Schedule for hourly snapshots.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      minute: 0
      snapshotsToKeep: 0
      usedBytes: 0
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`minute`](#parameter-hourlyscheduleminute) | int | The hourly snapshot minute. |
| [`snapshotsToKeep`](#parameter-hourlyschedulesnapshotstokeep) | int | Hourly snapshot count to keep. |
| [`usedBytes`](#parameter-hourlyscheduleusedbytes) | int | Hourly snapshot used bytes. |

### Parameter: `hourlySchedule.minute`

The hourly snapshot minute.

- Required: No
- Type: int

### Parameter: `hourlySchedule.snapshotsToKeep`

Hourly snapshot count to keep.

- Required: No
- Type: int

### Parameter: `hourlySchedule.usedBytes`

Hourly snapshot used bytes.

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
- Default:
  ```Bicep
  {
      daysOfMonth: ''
      hour: 0
      minute: 0
      snapshotsToKeep: 0
      usedBytes: 0
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`daysOfMonth`](#parameter-monthlyscheduledaysofmonth) | string | The monthly snapshot day. |
| [`hour`](#parameter-monthlyschedulehour) | int | The monthly snapshot hour. |
| [`minute`](#parameter-monthlyscheduleminute) | int | The monthly snapshot minute. |
| [`snapshotsToKeep`](#parameter-monthlyschedulesnapshotstokeep) | int | Monthly snapshot count to keep. |
| [`usedBytes`](#parameter-monthlyscheduleusedbytes) | int | Monthly snapshot used bytes. |

### Parameter: `monthlySchedule.daysOfMonth`

The monthly snapshot day.

- Required: No
- Type: string

### Parameter: `monthlySchedule.hour`

The monthly snapshot hour.

- Required: No
- Type: int

### Parameter: `monthlySchedule.minute`

The monthly snapshot minute.

- Required: No
- Type: int

### Parameter: `monthlySchedule.snapshotsToKeep`

Monthly snapshot count to keep.

- Required: No
- Type: int

### Parameter: `monthlySchedule.usedBytes`

Monthly snapshot used bytes.

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
- Default:
  ```Bicep
  {
      day: ''
      hour: 0
      minute: 0
      snapshotsToKeep: 0
      usedBytes: 0
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`day`](#parameter-weeklyscheduleday) | string | The weekly snapshot day. |
| [`hour`](#parameter-weeklyschedulehour) | int | The weekly snapshot hour. |
| [`minute`](#parameter-weeklyscheduleminute) | int | The weekly snapshot minute. |
| [`snapshotsToKeep`](#parameter-weeklyschedulesnapshotstokeep) | int | Weekly snapshot count to keep. |
| [`usedBytes`](#parameter-weeklyscheduleusedbytes) | int | Weekly snapshot used bytes. |

### Parameter: `weeklySchedule.day`

The weekly snapshot day.

- Required: No
- Type: string

### Parameter: `weeklySchedule.hour`

The weekly snapshot hour.

- Required: No
- Type: int

### Parameter: `weeklySchedule.minute`

The weekly snapshot minute.

- Required: No
- Type: int

### Parameter: `weeklySchedule.snapshotsToKeep`

Weekly snapshot count to keep.

- Required: No
- Type: int

### Parameter: `weeklySchedule.usedBytes`

Weekly snapshot used bytes.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Backup Policy. |
| `resourceGroupName` | string | The name of the Resource Group the Snapshot was created in. |
| `resourceId` | string | The resource IDs of the snapshot Policy created within volume. |
