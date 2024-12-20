# DevTest Lab Artifact Sources `[Microsoft.DevTestLab/labs/artifactsources]`

This module deploys a DevTest Lab Artifact Source.

An artifact source allows you to create custom artifacts for the VMs in the lab, or use Azure Resource Manager templates to create a custom test environment. You must add a private Git repository for the artifacts or Resource Manager templates that your team creates. The repository can be hosted on GitHub or on Azure DevOps Services.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevTestLab/labs/artifactsources` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/artifactsources) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the artifact source. |
| [`uri`](#parameter-uri) | string | The artifact source's URI. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`armTemplateFolderPath`](#parameter-armtemplatefolderpath) | string | The folder containing Azure Resource Manager templates. Required if "folderPath" is empty. |
| [`folderPath`](#parameter-folderpath) | string | The folder containing artifacts. At least one folder path is required. Required if "armTemplateFolderPath" is empty. |
| [`labName`](#parameter-labname) | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`branchRef`](#parameter-branchref) | string | The artifact source's branch reference (e.g. main or master). |
| [`displayName`](#parameter-displayname) | string | The artifact source's display name. Default is the name of the artifact source. |
| [`securityToken`](#parameter-securitytoken) | securestring | The security token to authenticate to the artifact source. |
| [`sourceType`](#parameter-sourcetype) | string | The artifact source's type. |
| [`status`](#parameter-status) | string | Indicates if the artifact source is enabled (values: Enabled, Disabled). Default is "Enabled". |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

The name of the artifact source.

- Required: Yes
- Type: string

### Parameter: `uri`

The artifact source's URI.

- Required: Yes
- Type: string

### Parameter: `armTemplateFolderPath`

The folder containing Azure Resource Manager templates. Required if "folderPath" is empty.

- Required: No
- Type: string

### Parameter: `folderPath`

The folder containing artifacts. At least one folder path is required. Required if "armTemplateFolderPath" is empty.

- Required: No
- Type: string

### Parameter: `labName`

The name of the parent lab. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `branchRef`

The artifact source's branch reference (e.g. main or master).

- Required: No
- Type: string

### Parameter: `displayName`

The artifact source's display name. Default is the name of the artifact source.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `securityToken`

The security token to authenticate to the artifact source.

- Required: No
- Type: securestring

### Parameter: `sourceType`

The artifact source's type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'GitHub'
    'StorageAccount'
    'VsoGit'
  ]
  ```

### Parameter: `status`

Indicates if the artifact source is enabled (values: Enabled, Disabled). Default is "Enabled".

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the artifact source. |
| `resourceGroupName` | string | The name of the resource group the artifact source was created in. |
| `resourceId` | string | The resource ID of the artifact source. |
