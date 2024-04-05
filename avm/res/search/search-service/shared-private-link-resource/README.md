# Search Services Private Link Resources `[Microsoft.Search/searchServices/sharedPrivateLinkResources]`

This module deploys a Search Service Private Link Resource.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Search/searchServices/sharedPrivateLinkResources` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Search/2023-11-01/searchServices/sharedPrivateLinkResources) |

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
| [`resourceRegion`](#parameter-resourceregion) | string | Can be used to specify the Azure Resource Manager location of the resource to which a shared private link is to be created. This is only required for those resources whose DNS configuration are regional (such as Azure Kubernetes Service). |

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

### Parameter: `searchServiceName`

The name of the parent searchServices. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `resourceRegion`

Can be used to specify the Azure Resource Manager location of the resource to which a shared private link is to be created. This is only required for those resources whose DNS configuration are regional (such as Azure Kubernetes Service).

- Required: No
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the shared private link resource. |
| `resourceGroupName` | string | The name of the resource group the shared private link resource was created in. |
| `resourceId` | string | The resource ID of the shared private link resource. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
