# DevTest Lab Costs `[Microsoft.DevTestLab/labs/costs]`

This module deploys a DevTest Lab Cost.

Manage lab costs by setting a spending target that can be viewed in the Monthly Estimated Cost Trend chart. DevTest Labs can send a notification when spending reaches the specified target threshold.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/costs` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/costs) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cycleType`](#parameter-cycletype) | string | Reporting cycle type. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cycleEndDateTime`](#parameter-cycleenddatetime) | string | Reporting cycle end date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom". |
| [`cycleStartDateTime`](#parameter-cyclestartdatetime) | string | Reporting cycle start date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom". |
| [`labName`](#parameter-labname) | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`currencyCode`](#parameter-currencycode) | string | The currency code of the cost. |
| [`status`](#parameter-status) | string | Target cost status. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`target`](#parameter-target) | int | Lab target cost (e.g. 100). The target cost will appear in the "Cost trend" chart to allow tracking lab spending relative to the target cost for the current reporting cycleSetting the target cost to 0 will disable all thresholds. |
| [`thresholdValue100DisplayOnChart`](#parameter-thresholdvalue100displayonchart) | string | Target Cost threshold at 100% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| [`thresholdValue100SendNotificationWhenExceeded`](#parameter-thresholdvalue100sendnotificationwhenexceeded) | string | Target cost threshold at 100% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| [`thresholdValue125DisplayOnChart`](#parameter-thresholdvalue125displayonchart) | string | Target Cost threshold at 125% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| [`thresholdValue125SendNotificationWhenExceeded`](#parameter-thresholdvalue125sendnotificationwhenexceeded) | string | Target cost threshold at 125% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| [`thresholdValue25DisplayOnChart`](#parameter-thresholdvalue25displayonchart) | string | Target Cost threshold at 25% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| [`thresholdValue25SendNotificationWhenExceeded`](#parameter-thresholdvalue25sendnotificationwhenexceeded) | string | Target cost threshold at 25% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| [`thresholdValue50DisplayOnChart`](#parameter-thresholdvalue50displayonchart) | string | Target Cost threshold at 50% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| [`thresholdValue50SendNotificationWhenExceeded`](#parameter-thresholdvalue50sendnotificationwhenexceeded) | string | Target cost threshold at 50% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| [`thresholdValue75DisplayOnChart`](#parameter-thresholdvalue75displayonchart) | string | Target Cost threshold at 75% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| [`thresholdValue75SendNotificationWhenExceeded`](#parameter-thresholdvalue75sendnotificationwhenexceeded) | string | Target cost threshold at 75% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |

### Parameter: `cycleType`

Reporting cycle type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CalendarMonth'
    'Custom'
  ]
  ```

### Parameter: `cycleEndDateTime`

Reporting cycle end date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom".

- Required: No
- Type: string

### Parameter: `cycleStartDateTime`

Reporting cycle start date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom".

- Required: No
- Type: string

### Parameter: `labName`

The name of the parent lab. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `currencyCode`

The currency code of the cost.

- Required: No
- Type: string
- Default: `'USD'`

### Parameter: `status`

Target cost status.

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

### Parameter: `target`

Lab target cost (e.g. 100). The target cost will appear in the "Cost trend" chart to allow tracking lab spending relative to the target cost for the current reporting cycleSetting the target cost to 0 will disable all thresholds.

- Required: No
- Type: int
- Default: `0`

### Parameter: `thresholdValue100DisplayOnChart`

Target Cost threshold at 100% display on chart. Indicates whether this threshold will be displayed on cost charts.

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

### Parameter: `thresholdValue100SendNotificationWhenExceeded`

Target cost threshold at 100% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.

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

### Parameter: `thresholdValue125DisplayOnChart`

Target Cost threshold at 125% display on chart. Indicates whether this threshold will be displayed on cost charts.

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

### Parameter: `thresholdValue125SendNotificationWhenExceeded`

Target cost threshold at 125% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.

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

### Parameter: `thresholdValue25DisplayOnChart`

Target Cost threshold at 25% display on chart. Indicates whether this threshold will be displayed on cost charts.

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

### Parameter: `thresholdValue25SendNotificationWhenExceeded`

Target cost threshold at 25% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.

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

### Parameter: `thresholdValue50DisplayOnChart`

Target Cost threshold at 50% display on chart. Indicates whether this threshold will be displayed on cost charts.

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

### Parameter: `thresholdValue50SendNotificationWhenExceeded`

Target cost threshold at 50% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.

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

### Parameter: `thresholdValue75DisplayOnChart`

Target Cost threshold at 75% display on chart. Indicates whether this threshold will be displayed on cost charts.

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

### Parameter: `thresholdValue75SendNotificationWhenExceeded`

Target cost threshold at 75% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the cost. |
| `resourceGroupName` | string | The name of the resource group the cost was created in. |
| `resourceId` | string | The resource ID of the cost. |
