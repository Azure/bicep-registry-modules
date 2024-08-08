# Private Link Scope Scoped Resources `[Microsoft.Insights/privateLinkScopes/scopedResources]`

This module deploys a Private Link Scope Scoped Resource.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Insights/privateLinkScopes/scopedResources` | [2021-07-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-07-01-preview/privateLinkScopes/scopedResources) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`linkedResourceId`](#parameter-linkedresourceid) | string | The resource ID of the scoped Azure monitor resource. |
| [`name`](#parameter-name) | string | Name of the private link scoped resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateLinkScopeName`](#parameter-privatelinkscopename) | string | The name of the parent private link scope. Required if the template is used in a standalone deployment. |

### Parameter: `linkedResourceId`

The resource ID of the scoped Azure monitor resource.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the private link scoped resource.

- Required: Yes
- Type: string

### Parameter: `privateLinkScopeName`

The name of the parent private link scope. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The full name of the deployed Scoped Resource. |
| `resourceGroupName` | string | The name of the resource group where the resource has been deployed. |
| `resourceId` | string | The resource ID of the deployed scopedResource. |
