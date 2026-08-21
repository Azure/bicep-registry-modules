# Dev Center Project Catalog `[Microsoft.DevCenter/projects/catalogs]`

This module deploys a Dev Center Project Catalog.

You can reference the module as follows:
```bicep
module project 'br/public:avm/res/dev-center/project/catalog:<version>' = {
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
| `Microsoft.DevCenter/projects/catalogs` | 2025-02-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devcenter_projects_catalogs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/catalogs)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
