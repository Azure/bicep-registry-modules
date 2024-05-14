# Automation Account Software Update Configurations `[Microsoft.Automation/automationAccounts/softwareUpdateConfigurations]`

This module deploys an Azure Automation Account Software Update Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/softwareUpdateConfigurations` | [2019-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/softwareUpdateConfigurations) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`frequency`](#parameter-frequency) | string | The frequency of the deployment schedule. When using 'Hour', 'Day', 'Week' or 'Month', an interval needs to be provided. |
| [`name`](#parameter-name) | string | The name of the Deployment schedule. |
| [`operatingSystem`](#parameter-operatingsystem) | string | The operating system to be configured by the deployment schedule. |
| [`rebootSetting`](#parameter-rebootsetting) | string | Reboot setting for the deployment schedule. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureVirtualMachines`](#parameter-azurevirtualmachines) | array | List of azure resource IDs for azure virtual machines in scope for the deployment schedule. |
| [`excludeUpdates`](#parameter-excludeupdates) | array | KB numbers or Linux packages excluded in the deployment schedule. |
| [`expiryTime`](#parameter-expirytime) | string | The end time of the deployment schedule in ISO 8601 format. YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00. |
| [`expiryTimeOffsetMinutes`](#parameter-expirytimeoffsetminutes) | int | The expiry time's offset in minutes. |
| [`includeUpdates`](#parameter-includeupdates) | array | KB numbers or Linux packages included in the deployment schedule. |
| [`interval`](#parameter-interval) | int | The interval of the frequency for the deployment schedule. 1 Hour is every hour, 2 Day is every second day, etc. |
| [`isEnabled`](#parameter-isenabled) | bool | Enables the deployment schedule. |
| [`maintenanceWindow`](#parameter-maintenancewindow) | string | Maximum time allowed for the deployment schedule to run. Duration needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601. |
| [`monthDays`](#parameter-monthdays) | array | Can be used with frequency 'Month'. Provides the specific days of the month to run the deployment schedule. |
| [`monthlyOccurrences`](#parameter-monthlyoccurrences) | array | Can be used with frequency 'Month'. Provides the pattern/cadence for running the deployment schedule in a month. Takes objects formed like this {occurance(int),day(string)}. Day is the name of the day to run the deployment schedule, the occurance specifies which occurance of that day to run the deployment schedule. |
| [`nextRun`](#parameter-nextrun) | string | The next time the deployment schedule runs in ISO 8601 format. YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00. |
| [`nextRunOffsetMinutes`](#parameter-nextrunoffsetminutes) | int | The next run's offset in minutes. |
| [`nonAzureComputerNames`](#parameter-nonazurecomputernames) | array | List of names of non-azure machines in scope for the deployment schedule. |
| [`nonAzureQueries`](#parameter-nonazurequeries) | array | Array of functions from a Log Analytics workspace, used to scope the deployment schedule. |
| [`postTaskParameters`](#parameter-posttaskparameters) | object | Parameters provided to the task running after the deployment schedule. |
| [`postTaskSource`](#parameter-posttasksource) | string | The source of the task running after the deployment schedule. |
| [`preTaskParameters`](#parameter-pretaskparameters) | object | Parameters provided to the task running before the deployment schedule. |
| [`preTaskSource`](#parameter-pretasksource) | string | The source of the task running before the deployment schedule. |
| [`scheduleDescription`](#parameter-scheduledescription) | string | The schedules description. |
| [`scopeByLocations`](#parameter-scopebylocations) | array | Specify locations to which to scope the deployment schedule to. |
| [`scopeByResources`](#parameter-scopebyresources) | array | Specify the resources to scope the deployment schedule to. |
| [`scopeByTags`](#parameter-scopebytags) | object | Specify tags to which to scope the deployment schedule to. |
| [`scopeByTagsOperation`](#parameter-scopebytagsoperation) | string | Enables the scopeByTags to require All (Tag A and Tag B) or Any (Tag A or Tag B). |
| [`startTime`](#parameter-starttime) | string | The start time of the deployment schedule in ISO 8601 format. To specify a specific time use YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00. For schedules where we want to start the deployment as soon as possible, specify the time segment only in 24 hour format, HH:MM, 22:00. |
| [`timeZone`](#parameter-timezone) | string | Time zone for the deployment schedule. IANA ID or a Windows Time Zone ID. |
| [`updateClassifications`](#parameter-updateclassifications) | array | Update classification included in the deployment schedule. |
| [`weekDays`](#parameter-weekdays) | array | Required when used with frequency 'Week'. Specified the day of the week to run the deployment schedule. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Do not touch. Is used to provide the base time for time comparison for startTime. If startTime is specified in HH:MM format, baseTime is used to check if the provided startTime has passed, adding one day before setting the deployment schedule. |

### Parameter: `frequency`

The frequency of the deployment schedule. When using 'Hour', 'Day', 'Week' or 'Month', an interval needs to be provided.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Day'
    'Hour'
    'Month'
    'OneTime'
    'Week'
  ]
  ```

### Parameter: `name`

The name of the Deployment schedule.

- Required: Yes
- Type: string

### Parameter: `operatingSystem`

The operating system to be configured by the deployment schedule.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `rebootSetting`

Reboot setting for the deployment schedule.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Always'
    'IfRequired'
    'Never'
    'RebootOnly'
  ]
  ```

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `azureVirtualMachines`

List of azure resource IDs for azure virtual machines in scope for the deployment schedule.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `excludeUpdates`

KB numbers or Linux packages excluded in the deployment schedule.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `expiryTime`

The end time of the deployment schedule in ISO 8601 format. YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00.

- Required: No
- Type: string
- Default: `''`

### Parameter: `expiryTimeOffsetMinutes`

The expiry time's offset in minutes.

- Required: No
- Type: int
- Default: `0`

### Parameter: `includeUpdates`

KB numbers or Linux packages included in the deployment schedule.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `interval`

The interval of the frequency for the deployment schedule. 1 Hour is every hour, 2 Day is every second day, etc.

- Required: No
- Type: int
- Default: `1`

### Parameter: `isEnabled`

Enables the deployment schedule.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `maintenanceWindow`

Maximum time allowed for the deployment schedule to run. Duration needs to be specified using the format PT[n]H[n]M[n]S as per ISO8601.

- Required: No
- Type: string
- Default: `'PT2H'`

### Parameter: `monthDays`

Can be used with frequency 'Month'. Provides the specific days of the month to run the deployment schedule.

- Required: No
- Type: array
- Default: `[]`
- Allowed:
  ```Bicep
  [
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
  ]
  ```

### Parameter: `monthlyOccurrences`

Can be used with frequency 'Month'. Provides the pattern/cadence for running the deployment schedule in a month. Takes objects formed like this {occurance(int),day(string)}. Day is the name of the day to run the deployment schedule, the occurance specifies which occurance of that day to run the deployment schedule.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `nextRun`

The next time the deployment schedule runs in ISO 8601 format. YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00.

- Required: No
- Type: string
- Default: `''`

### Parameter: `nextRunOffsetMinutes`

The next run's offset in minutes.

- Required: No
- Type: int
- Default: `0`

### Parameter: `nonAzureComputerNames`

List of names of non-azure machines in scope for the deployment schedule.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `nonAzureQueries`

Array of functions from a Log Analytics workspace, used to scope the deployment schedule.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `postTaskParameters`

Parameters provided to the task running after the deployment schedule.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `postTaskSource`

The source of the task running after the deployment schedule.

- Required: No
- Type: string
- Default: `''`

### Parameter: `preTaskParameters`

Parameters provided to the task running before the deployment schedule.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `preTaskSource`

The source of the task running before the deployment schedule.

- Required: No
- Type: string
- Default: `''`

### Parameter: `scheduleDescription`

The schedules description.

- Required: No
- Type: string
- Default: `''`

### Parameter: `scopeByLocations`

Specify locations to which to scope the deployment schedule to.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `scopeByResources`

Specify the resources to scope the deployment schedule to.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    '[subscription().id]'
  ]
  ```

### Parameter: `scopeByTags`

Specify tags to which to scope the deployment schedule to.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `scopeByTagsOperation`

Enables the scopeByTags to require All (Tag A and Tag B) or Any (Tag A or Tag B).

- Required: No
- Type: string
- Default: `'All'`
- Allowed:
  ```Bicep
  [
    'All'
    'Any'
  ]
  ```

### Parameter: `startTime`

The start time of the deployment schedule in ISO 8601 format. To specify a specific time use YYYY-MM-DDTHH:MM:SS, 2021-12-31T23:00:00. For schedules where we want to start the deployment as soon as possible, specify the time segment only in 24 hour format, HH:MM, 22:00.

- Required: No
- Type: string
- Default: `''`

### Parameter: `timeZone`

Time zone for the deployment schedule. IANA ID or a Windows Time Zone ID.

- Required: No
- Type: string
- Default: `'UTC'`

### Parameter: `updateClassifications`

Update classification included in the deployment schedule.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'Critical'
    'Security'
  ]
  ```
- Allowed:
  ```Bicep
  [
    'Critical'
    'Definition'
    'FeaturePack'
    'Other'
    'Security'
    'ServicePack'
    'Tools'
    'UpdateRollup'
    'Updates'
  ]
  ```

### Parameter: `weekDays`

Required when used with frequency 'Week'. Specified the day of the week to run the deployment schedule.

- Required: No
- Type: array
- Default: `[]`
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

### Parameter: `baseTime`

Do not touch. Is used to provide the base time for time comparison for startTime. If startTime is specified in HH:MM format, baseTime is used to check if the provided startTime has passed, adding one day before setting the deployment schedule.

- Required: No
- Type: string
- Default: `[utcNow('u')]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed softwareUpdateConfiguration. |
| `resourceGroupName` | string | The resource group of the deployed softwareUpdateConfiguration. |
| `resourceId` | string | The resource ID of the deployed softwareUpdateConfiguration. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
