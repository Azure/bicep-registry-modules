# Log Analytics Workspace Datasources `[Microsoft.OperationalInsights/workspaces/dataSources]`

This module deploys a Log Analytics Workspace Data Source.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the data source. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsWorkspaceName`](#parameter-loganalyticsworkspacename) | string | The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`counterName`](#parameter-countername) | string | Counter name to configure when kind is WindowsPerformanceCounter. |
| [`eventLogName`](#parameter-eventlogname) | string | Windows event log name to configure when kind is WindowsEvent. |
| [`eventTypes`](#parameter-eventtypes) | array | Windows event types to configure when kind is WindowsEvent. |
| [`instanceName`](#parameter-instancename) | string | Name of the instance to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| [`intervalSeconds`](#parameter-intervalseconds) | int | Interval in seconds to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| [`kind`](#parameter-kind) | string | The kind of the data source. |
| [`linkedResourceId`](#parameter-linkedresourceid) | string | Resource ID of the resource to be linked. |
| [`objectName`](#parameter-objectname) | string | Name of the object to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject. |
| [`performanceCounters`](#parameter-performancecounters) | array | List of counters to configure when the kind is LinuxPerformanceObject. |
| [`state`](#parameter-state) | string | State to configure when kind is IISLogs or LinuxSyslogCollection or LinuxPerformanceCollection. |
| [`syslogName`](#parameter-syslogname) | string | System log to configure when kind is LinuxSyslog. |
| [`syslogSeverities`](#parameter-syslogseverities) | array | Severities to configure when kind is LinuxSyslog. |
| [`tags`](#parameter-tags) | object | Tags to configure in the resource. |

### Parameter: `name`

Name of the data source.

- Required: Yes
- Type: string

### Parameter: `logAnalyticsWorkspaceName`

The name of the parent Log Analytics workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `counterName`

Counter name to configure when kind is WindowsPerformanceCounter.

- Required: No
- Type: string

### Parameter: `eventLogName`

Windows event log name to configure when kind is WindowsEvent.

- Required: No
- Type: string

### Parameter: `eventTypes`

Windows event types to configure when kind is WindowsEvent.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `instanceName`

Name of the instance to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject.

- Required: No
- Type: string
- Default: `'*'`

### Parameter: `intervalSeconds`

Interval in seconds to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject.

- Required: No
- Type: int
- Default: `60`

### Parameter: `kind`

The kind of the data source.

- Required: No
- Type: string
- Default: `'AzureActivityLog'`
- Allowed:
  ```Bicep
  [
    'AzureActivityLog'
    'IISLogs'
    'LinuxPerformanceCollection'
    'LinuxPerformanceObject'
    'LinuxSyslog'
    'LinuxSyslogCollection'
    'WindowsEvent'
    'WindowsPerformanceCounter'
  ]
  ```

### Parameter: `linkedResourceId`

Resource ID of the resource to be linked.

- Required: No
- Type: string

### Parameter: `objectName`

Name of the object to configure when kind is WindowsPerformanceCounter or LinuxPerformanceObject.

- Required: No
- Type: string

### Parameter: `performanceCounters`

List of counters to configure when the kind is LinuxPerformanceObject.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `state`

State to configure when kind is IISLogs or LinuxSyslogCollection or LinuxPerformanceCollection.

- Required: No
- Type: string

### Parameter: `syslogName`

System log to configure when kind is LinuxSyslog.

- Required: No
- Type: string

### Parameter: `syslogSeverities`

Severities to configure when kind is LinuxSyslog.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags to configure in the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed data source. |
| `resourceGroupName` | string | The resource group where the data source is deployed. |
| `resourceId` | string | The resource ID of the deployed data source. |
