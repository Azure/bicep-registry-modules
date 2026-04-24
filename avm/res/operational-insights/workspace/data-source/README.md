# Log Analytics Workspace Datasources `[Microsoft.OperationalInsights/workspaces/dataSources]`

This module deploys a Log Analytics Workspace Data Source.

You can reference the module as follows:
```bicep
module workspace 'br/public:avm/res/operational-insights/workspace/data-source:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/dataSources` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_datasources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/dataSources)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
