# Dev Center Project Catalog `[Microsoft.DevCenter/projects/catalogs]`

This module deploys a Dev Center Project Catalog.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DevCenter/projects/catalogs` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/catalogs) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the catalog. Must be between 3 and 63 characters and can contain alphanumeric characters, hyphens, underscores, and periods. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`projectName`](#parameter-projectname) | string | The name of the parent dev center project. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adoGit`](#parameter-adogit) | object | Azure DevOps Git repository configuration for the catalog. |
| [`gitHub`](#parameter-github) | object | GitHub repository configuration for the catalog. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`syncType`](#parameter-synctype) | string | Indicates the type of sync that is configured for the catalog. Defaults to "Scheduled". |
| [`tags`](#parameter-tags) | object | Resource tags to apply to the catalog. |

### Parameter: `name`

The name of the catalog. Must be between 3 and 63 characters and can contain alphanumeric characters, hyphens, underscores, and periods.

- Required: Yes
- Type: string

### Parameter: `projectName`

The name of the parent dev center project. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `adoGit`

Azure DevOps Git repository configuration for the catalog.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`uri`](#parameter-adogituri) | string | The Git repository URI. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`branch`](#parameter-adogitbranch) | string | The Git branch to use. Defaults to "main". |
| [`path`](#parameter-adogitpath) | string | The folder path within the repository. Defaults to "/". |
| [`secretIdentifier`](#parameter-adogitsecretidentifier) | string | A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center. |

### Parameter: `adoGit.uri`

The Git repository URI.

- Required: Yes
- Type: string

### Parameter: `adoGit.branch`

The Git branch to use. Defaults to "main".

- Required: No
- Type: string

### Parameter: `adoGit.path`

The folder path within the repository. Defaults to "/".

- Required: No
- Type: string

### Parameter: `adoGit.secretIdentifier`

A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center.

- Required: No
- Type: string

### Parameter: `gitHub`

GitHub repository configuration for the catalog.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`uri`](#parameter-githuburi) | string | The Git repository URI. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`branch`](#parameter-githubbranch) | string | The Git branch to use. Defaults to "main". |
| [`path`](#parameter-githubpath) | string | The folder path within the repository. Defaults to "/". |
| [`secretIdentifier`](#parameter-githubsecretidentifier) | string | A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center. |

### Parameter: `gitHub.uri`

The Git repository URI.

- Required: Yes
- Type: string

### Parameter: `gitHub.branch`

The Git branch to use. Defaults to "main".

- Required: No
- Type: string

### Parameter: `gitHub.path`

The folder path within the repository. Defaults to "/".

- Required: No
- Type: string

### Parameter: `gitHub.secretIdentifier`

A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center.

- Required: No
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `syncType`

Indicates the type of sync that is configured for the catalog. Defaults to "Scheduled".

- Required: No
- Type: string
- Default: `'Scheduled'`
- Allowed:
  ```Bicep
  [
    'Manual'
    'Scheduled'
  ]
  ```

### Parameter: `tags`

Resource tags to apply to the catalog.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the catalog. |
| `resourceGroupName` | string | The name of the resource group the catalog was created in. |
| `resourceId` | string | The resource ID of the catalog. |
