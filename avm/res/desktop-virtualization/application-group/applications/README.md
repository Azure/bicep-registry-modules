# Azure Virtual Desktop Application Group Application `[Microsoft.DesktopVirtualization/applicationGroups/applications]`

This module deploys an Azure Virtual Desktop Application Group Application.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DesktopVirtualization/applicationGroups/applications` | [2023-09-05](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/applicationGroups/applications) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`filePath`](#parameter-filepath) | string | Specifies a path for the executable file for the application. |
| [`friendlyName`](#parameter-friendlyname) | string | Friendly name of Application.. |
| [`name`](#parameter-name) | string | Name of the Application to be created in the Application Group. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationGroupName`](#parameter-applicationgroupname) | string | The name of the parent Application Group to create the application(s) in. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`commandLineArguments`](#parameter-commandlinearguments) | string | Command-Line Arguments for Application. |
| [`commandLineSetting`](#parameter-commandlinesetting) | string | Specifies whether this published application can be launched with command-line arguments provided by the client, command-line arguments specified at publish time, or no command-line arguments at all. |
| [`description`](#parameter-description) | string | Description of Application.. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable telemetry. |
| [`iconIndex`](#parameter-iconindex) | int | Index of the icon. |
| [`iconPath`](#parameter-iconpath) | string | Path to icon. |
| [`showInPortal`](#parameter-showinportal) | bool | Specifies whether to show the RemoteApp program in the RD Web Access server. |

### Parameter: `applicationGroupName`

The name of the parent Application Group to create the application(s) in. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `commandLineArguments`

Command-Line Arguments for Application.
- Required: No
- Type: string
- Default: `''`

### Parameter: `commandLineSetting`

Specifies whether this published application can be launched with command-line arguments provided by the client, command-line arguments specified at publish time, or no command-line arguments at all.
- Required: No
- Type: string
- Default: `'DoNotAllow'`
- Allowed:
  ```Bicep
  [
    'Allow'
    'DoNotAllow'
    'Require'
  ]
  ```

### Parameter: `description`

Description of Application..
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable telemetry.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `filePath`

Specifies a path for the executable file for the application.
- Required: Yes
- Type: string

### Parameter: `friendlyName`

Friendly name of Application..
- Required: Yes
- Type: string

### Parameter: `iconIndex`

Index of the icon.
- Required: No
- Type: int
- Default: `0`

### Parameter: `iconPath`

Path to icon.
- Required: No
- Type: string
- Default: `''`

### Parameter: `name`

Name of the Application to be created in the Application Group.
- Required: Yes
- Type: string

### Parameter: `showInPortal`

Specifies whether to show the RemoteApp program in the RD Web Access server.
- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the scaling plan. |
| `resourceGroupName` | string | The name of the resource group the scaling plan was created in. |
| `resourceId` | string | The resource ID of the application. |

## Cross-referenced modules

_None_
