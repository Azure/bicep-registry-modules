# DevTest Lab Schedules `[Microsoft.DevTestLab/labs/schedules]`

This module deploys a DevTest Lab Schedule.

Lab schedules are used to modify the settings for auto-shutdown, auto-start for lab virtual machines.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/schedules` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/schedules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the schedule. |
| [`taskType`](#parameter-tasktype) | string | The task type of the schedule (e.g. LabVmsShutdownTask, LabVmsStartupTask). |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labName`](#parameter-labname) | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyRecurrence`](#parameter-dailyrecurrence) | object | If the schedule will occur once each day of the week, specify the daily recurrence. |
| [`hourlyRecurrence`](#parameter-hourlyrecurrence) | object | If the schedule will occur multiple times a day, specify the hourly recurrence. |
| [`notificationSettingsStatus`](#parameter-notificationsettingsstatus) | string | If notifications are enabled for this schedule (i.e. Enabled, Disabled). |
| [`notificationSettingsTimeInMinutes`](#parameter-notificationsettingstimeinminutes) | int | Time in minutes before event at which notification will be sent. Optional if "notificationSettingsStatus" is set to "Enabled". Default is 30 minutes. |
| [`status`](#parameter-status) | string | The status of the schedule (i.e. Enabled, Disabled). |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`targetResourceId`](#parameter-targetresourceid) | string | The resource ID to which the schedule belongs. |
| [`timeZoneId`](#parameter-timezoneid) | string | The time zone ID (e.g. Pacific Standard time). |
| [`weeklyRecurrence`](#parameter-weeklyrecurrence) | object | If the schedule will occur only some days of the week, specify the weekly recurrence. |

### Parameter: `name`

The name of the schedule.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'LabVmAutoStart'
    'LabVmsShutdown'
  ]
  ```

### Parameter: `taskType`

The task type of the schedule (e.g. LabVmsShutdownTask, LabVmsStartupTask).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'LabVmsShutdownTask'
    'LabVmsStartupTask'
  ]
  ```

### Parameter: `labName`

The name of the parent lab. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `dailyRecurrence`

If the schedule will occur once each day of the week, specify the daily recurrence.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `hourlyRecurrence`

If the schedule will occur multiple times a day, specify the hourly recurrence.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `notificationSettingsStatus`

If notifications are enabled for this schedule (i.e. Enabled, Disabled).

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `notificationSettingsTimeInMinutes`

Time in minutes before event at which notification will be sent. Optional if "notificationSettingsStatus" is set to "Enabled". Default is 30 minutes.

- Required: No
- Type: int
- Default: `30`

### Parameter: `status`

The status of the schedule (i.e. Enabled, Disabled).

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `targetResourceId`

The resource ID to which the schedule belongs.

- Required: No
- Type: string
- Default: `''`

### Parameter: `timeZoneId`

The time zone ID (e.g. Pacific Standard time).

- Required: No
- Type: string
- Default: `'Pacific Standard time'`

### Parameter: `weeklyRecurrence`

If the schedule will occur only some days of the week, specify the weekly recurrence.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the schedule. |
| `resourceGroupName` | string | The name of the resource group the schedule was created in. |
| `resourceId` | string | The resource ID of the schedule. |
