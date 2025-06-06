# Dev Center Project Pool Schedule `[Microsoft.DevCenter/projects/pools/schedules]`

This module deploys a Dev Center Project Pool Schedule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevCenter/projects/pools/schedules` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/pools/schedules) |

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
