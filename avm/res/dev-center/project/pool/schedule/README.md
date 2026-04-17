# Dev Center Project Pool Schedule `[Microsoft.DevCenter/projects/pools/schedules]`

This module deploys a Dev Center Project Pool Schedule.

You can reference the module as follows:
```bicep
module project 'br/public:avm/res/dev-center/project/pool/schedule:<version>' = {
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
| `Microsoft.DevCenter/projects/pools/schedules` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devcenter_projects_pools_schedules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/pools/schedules)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-state) | string | Indicates whether or not this scheduled task is enabled. Allowed values: Disabled, Enabled. |
| [`time`](#parameter-time) | string | The target time to trigger the action. The format is HH:MM. For example, "14:30" for 2:30 PM. |
| [`timeZone`](#parameter-timezone) | string | The IANA timezone id at which the schedule should execute. For example, "Australia/Sydney", "Canada/Central". |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`poolName`](#parameter-poolname) | string | The name of the parent dev center project pool. Required if the template is used in a standalone deployment. |
| [`projectName`](#parameter-projectname) | string | The name of the parent dev center project. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`tags`](#parameter-tags) | object | Resource tags to apply to the pool. |

### Parameter: `state`

Indicates whether or not this scheduled task is enabled. Allowed values: Disabled, Enabled.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `time`

The target time to trigger the action. The format is HH:MM. For example, "14:30" for 2:30 PM.

- Required: Yes
- Type: string

### Parameter: `timeZone`

The IANA timezone id at which the schedule should execute. For example, "Australia/Sydney", "Canada/Central".

- Required: Yes
- Type: string

### Parameter: `poolName`

The name of the parent dev center project pool. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `projectName`

The name of the parent dev center project. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Resource tags to apply to the pool.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed schedule. |
| `resourceGroupName` | string | The resource group the schedule was deployed into. |
| `resourceId` | string | The resource ID of the deployed schedule. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
