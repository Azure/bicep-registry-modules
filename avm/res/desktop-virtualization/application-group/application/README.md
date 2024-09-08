# Azure Virtual Desktop Application Group Application `[Microsoft.DesktopVirtualization/applicationGroups/applications]`

This module deploys an Azure Virtual Desktop Application Group Application.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DesktopVirtualization/applicationGroups/applications` | [2023-09-05](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DesktopVirtualization/2023-09-05/applicationGroups/applications) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`filePath`](#parameter-filepath) | string | Specifies a path for the executable file for the Application. |
| [`friendlyName`](#parameter-friendlyname) | string | Friendly name of the Application. |
| [`name`](#parameter-name) | string | Name of the Application to be created in the Application Group. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationGroupName`](#parameter-applicationgroupname) | string | The name of the parent Application Group to create the application(s) in. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`commandLineArguments`](#parameter-commandlinearguments) | string | Command-Line Arguments for the Application. |
| [`commandLineSetting`](#parameter-commandlinesetting) | string | Specifies whether this published Application can be launched with command-line arguments provided by the client, command-line arguments specified at publish time, or no command-line arguments at all. |
| [`description`](#parameter-description) | string | Description of the Application. |
| [`iconIndex`](#parameter-iconindex) | int | Index of the icon. |
| [`iconPath`](#parameter-iconpath) | string | Path to icon. |
| [`showInPortal`](#parameter-showinportal) | bool | Specifies whether to show the RemoteApp program in the RD Web Access server. |

### Parameter: `filePath`

Specifies a path for the executable file for the Application.

- Required: Yes
- Type: string

### Parameter: `friendlyName`

Friendly name of the Application.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the Application to be created in the Application Group.

- Required: Yes
- Type: string

### Parameter: `applicationGroupName`

The name of the parent Application Group to create the application(s) in. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `commandLineArguments`

Command-Line Arguments for the Application.

- Required: No
- Type: string
- Default: `''`

### Parameter: `commandLineSetting`

Specifies whether this published Application can be launched with command-line arguments provided by the client, command-line arguments specified at publish time, or no command-line arguments at all.

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

Description of the Application.

- Required: No
- Type: string
- Default: `''`

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

### Parameter: `showInPortal`

Specifies whether to show the RemoteApp program in the RD Web Access server.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Application. |
| `resourceGroupName` | string | The name of the resource group the Application was created in. |
| `resourceId` | string | The resource ID of the Application. |
