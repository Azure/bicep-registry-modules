# Automation Account Schedules `[Microsoft.Automation/automationAccounts/schedules]`

This module deploys an Azure Automation Account Schedule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/schedules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/schedules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Automation Account schedule. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`advancedSchedule`](#parameter-advancedschedule) | object | The properties of the create Advanced Schedule. |
| [`description`](#parameter-description) | string | The description of the schedule. |
| [`expiryTime`](#parameter-expirytime) | string | The end time of the schedule. |
| [`frequency`](#parameter-frequency) | string | The frequency of the schedule. |
| [`interval`](#parameter-interval) | int | Anything. |
| [`startTime`](#parameter-starttime) | string | The start time of the schedule. |
| [`timeZone`](#parameter-timezone) | string | The time zone of the schedule. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Time used as a basis for e.g. the schedule start date. |

### Parameter: `name`

Name of the Automation Account schedule.

- Required: Yes
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `advancedSchedule`

The properties of the create Advanced Schedule.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `description`

The description of the schedule.

- Required: No
- Type: string
- Default: `''`

### Parameter: `expiryTime`

The end time of the schedule.

- Required: No
- Type: string
- Default: `''`

### Parameter: `frequency`

The frequency of the schedule.

- Required: No
- Type: string
- Default: `'OneTime'`
- Allowed:
  ```Bicep
  [
    'Day'
    'Hour'
    'Minute'
    'Month'
    'OneTime'
    'Week'
  ]
  ```

### Parameter: `interval`

Anything.

- Required: No
- Type: int
- Default: `0`

### Parameter: `startTime`

The start time of the schedule.

- Required: No
- Type: string
- Default: `''`

### Parameter: `timeZone`

The time zone of the schedule.

- Required: No
- Type: string
- Default: `''`

### Parameter: `baseTime`

Time used as a basis for e.g. the schedule start date.

- Required: No
- Type: string
- Default: `[utcNow('u')]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed schedule. |
| `resourceGroupName` | string | The resource group of the deployed schedule. |
| `resourceId` | string | The resource ID of the deployed schedule. |
