# Integration Account Assemblies `[Microsoft.Logic/integrationAccounts/assemblies]`

This module deploys an Integration Account Assembly.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Logic/integrationAccounts/assemblies` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_assemblies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/assemblies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assemblyName`](#parameter-assemblyname) | string | The assembly name. |
| [`content`](#parameter-content) | securestring | The Base64-encoded assembly content. |
| [`name`](#parameter-name) | string | The Name of the assembly resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`integrationAccountName`](#parameter-integrationaccountname) | string | The name of the parent integration account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-contenttype) | string | The assembly content type. |
| [`location`](#parameter-location) | string | Resource location. |
| [`metadata`](#parameter-metadata) |  | The assembly metadata. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `assemblyName`

The assembly name.

- Required: Yes
- Type: string

### Parameter: `content`

The Base64-encoded assembly content.

- Required: Yes
- Type: securestring

### Parameter: `name`

The Name of the assembly resource.

- Required: Yes
- Type: string

### Parameter: `integrationAccountName`

The name of the parent integration account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `contentType`

The assembly content type.

- Required: No
- Type: string
- Default: `'application/octet-stream'`

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `metadata`

The assembly metadata.

- Required: No
- Type: 

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the integration account assembly. |
| `resourceGroupName` | string | The resource group the integration account assembly was deployed into. |
| `resourceId` | string | The resource ID of the integration account assembly. |
