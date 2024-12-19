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
| [`notificationSettings`](#parameter-notificationsettings) | object | The notification settings for the schedule. |
| [`status`](#parameter-status) | string | The status of the schedule (i.e. Enabled, Disabled). |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`targetResourceId`](#parameter-targetresourceid) | string | The resource ID to which the schedule belongs. |
| [`timeZoneId`](#parameter-timezoneid) | string | The time zone ID (e.g. Pacific Standard time). |
| [`weeklyRecurrence`](#parameter-weeklyrecurrence) | object | If the schedule will occur only some days of the week, specify the weekly recurrence. |

### Parameter: `name`

The name of the schedule.

- Required: Yes
- Type: string
- Nullable: No
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
- Nullable: No
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
- Nullable: No

### Parameter: `dailyRecurrence`

If the schedule will occur once each day of the week, specify the daily recurrence.

- Required: No
- Type: object
- Nullable: No

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`time`](#parameter-dailyrecurrencetime) | string | The time of day the schedule will occur. |

### Parameter: `dailyRecurrence.time`

The time of day the schedule will occur.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `hourlyRecurrence`

If the schedule will occur multiple times a day, specify the hourly recurrence.

- Required: No
- Type: object
- Nullable: No

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`minute`](#parameter-hourlyrecurrenceminute) | int | Minutes of the hour the schedule will run. |

### Parameter: `hourlyRecurrence.minute`

Minutes of the hour the schedule will run.

- Required: Yes
- Type: int
- Nullable: No

### Parameter: `notificationSettings`

The notification settings for the schedule.

- Required: No
- Type: object
- Nullable: No

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailRecipient`](#parameter-notificationsettingsemailrecipient) | string | The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty. |
| [`webHookUrl`](#parameter-notificationsettingswebhookurl) | string | The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`notificationLocale`](#parameter-notificationsettingsnotificationlocale) | string | The locale to use when sending a notification (fallback for unsupported languages is EN). |
| [`status`](#parameter-notificationsettingsstatus) | string | If notifications are enabled for this schedule (i.e. Enabled, Disabled). Default is Disabled. |
| [`timeInMinutes`](#parameter-notificationsettingstimeinminutes) | int | Time in minutes before event at which notification will be sent. Default is 30 minutes if status is Enabled and not specified. |

### Parameter: `notificationSettings.emailRecipient`

The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty.

- Required: No
- Type: string
- Nullable: Yes

### Parameter: `notificationSettings.webHookUrl`

The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty.

- Required: No
- Type: string
- Nullable: Yes

### Parameter: `notificationSettings.notificationLocale`

The locale to use when sending a notification (fallback for unsupported languages is EN).

- Required: No
- Type: string
- Nullable: Yes

### Parameter: `notificationSettings.status`

If notifications are enabled for this schedule (i.e. Enabled, Disabled). Default is Disabled.

- Required: No
- Type: string
- Nullable: Yes
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `notificationSettings.timeInMinutes`

Time in minutes before event at which notification will be sent. Default is 30 minutes if status is Enabled and not specified.

- Required: No
- Type: int
- Nullable: Yes

### Parameter: `status`

The status of the schedule (i.e. Enabled, Disabled).

- Required: No
- Type: string
- Nullable: No
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
- Nullable: Yes

### Parameter: `targetResourceId`

The resource ID to which the schedule belongs.

- Required: No
- Type: string
- Nullable: Yes

### Parameter: `timeZoneId`

The time zone ID (e.g. Pacific Standard time).

- Required: No
- Type: string
- Nullable: No
- Default: `'Pacific Standard time'`

### Parameter: `weeklyRecurrence`

If the schedule will occur only some days of the week, specify the weekly recurrence.

- Required: No
- Type: object
- Nullable: No

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`time`](#parameter-weeklyrecurrencetime) | string | The time of day the schedule will occur. |
| [`weekdays`](#parameter-weeklyrecurrenceweekdays) | array | The days of the week for which the schedule is set (e.g. Sunday, Monday, Tuesday, etc.). |

### Parameter: `weeklyRecurrence.time`

The time of day the schedule will occur.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `weeklyRecurrence.weekdays`

The days of the week for which the schedule is set (e.g. Sunday, Monday, Tuesday, etc.).

- Required: Yes
- Type: array
- Nullable: No

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the schedule. |
| `resourceGroupName` | string | The name of the resource group the schedule was created in. |
| `resourceId` | string | The resource ID of the schedule. |
