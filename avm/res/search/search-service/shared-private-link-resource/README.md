# Search Services Private Link Resources `[Microsoft.Search/searchServices/sharedPrivateLinkResources]`

This module deploys a Search Service Private Link Resource.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2022-09-01/searchServices/sharedPrivateLinkResources) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-groupid) | string | The group ID from the provider of resource the shared private link resource is for. |
| [`name`](#parameter-name) | string | The name of the shared private link resource managed by the Azure Cognitive Search service within the specified resource group. |
| [`privateLinkResourceId`](#parameter-privatelinkresourceid) | string | The resource ID of the resource the shared private link resource is for. |
| [`requestMessage`](#parameter-requestmessage) | string | The request message for requesting approval of the shared private link resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`searchServiceName`](#parameter-searchservicename) | string | The name of the parent searchServices. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`resourceRegion`](#parameter-resourceregion) | string | Can be used to specify the Azure Resource Manager location of the resource to which a shared private link is to be created. This is only required for those resources whose DNS configuration are regional (such as Azure Kubernetes Service). |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `groupId`

The group ID from the provider of resource the shared private link resource is for.
- Required: Yes
- Type: string

### Parameter: `name`

The name of the shared private link resource managed by the Azure Cognitive Search service within the specified resource group.
- Required: Yes
- Type: string

### Parameter: `privateLinkResourceId`

The resource ID of the resource the shared private link resource is for.
- Required: Yes
- Type: string

### Parameter: `requestMessage`

The request message for requesting approval of the shared private link resource.
- Required: Yes
- Type: string

### Parameter: `resourceRegion`

Can be used to specify the Azure Resource Manager location of the resource to which a shared private link is to be created. This is only required for those resources whose DNS configuration are regional (such as Azure Kubernetes Service).
- Required: No
- Type: string
- Default: `''`

### Parameter: `searchServiceName`

The name of the parent searchServices. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the shared private link resource. |
| `resourceGroupName` | string | The name of the resource group the shared private link resource was created in. |
| `resourceId` | string | The resource ID of the shared private link resource. |

## Cross-referenced modules

_None_
