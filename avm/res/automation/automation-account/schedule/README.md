# Automation Account Schedules `[Microsoft.Automation/automationAccounts/schedules]`

This module deploys an Azure Automation Account Schedule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
