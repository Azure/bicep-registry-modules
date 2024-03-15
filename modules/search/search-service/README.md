<h1 style="color: steelblue;">⚠️ Upcoming changes ⚠️</h1>

This module has been replaced by the following equivalent module in Azure Verified Modules (AVM): [avm/res/search/search-service](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/search/search-service).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Azure Cognitive Search

Bicep module for simplified deployment of Azure Cognitive Search.

## Details

Azure Cognitive Search is a cloud service that provides capabilities for adding search functionality to your applications. This Bicep module allows for a flexible and efficient deployment of the Azure Cognitive Search service with multiple configuration options.

This module facilitates the creation of the Azure Cognitive Search instance with specified parameters like hosting mode, network rules, encryption settings, and more. It provides an efficient way to deploy, manage, and utilize the Azure Cognitive Search capabilities.

## Parameters

| Name                              | Type     | Required | Description                                                            |
| :-------------------------------- | :------: | :------: | :--------------------------------------------------------------------- |
| `prefix`                          | `string` | No       | Prefix of Azure Cognitive Search Resource Name                         |
| `name`                            | `string` | No       | Name of the Azure Cognitive Search Resource                            |
| `location`                        | `string` | No       | Location of the Azure Cognitive Search Resource                        |
| `tags`                            | `object` | No       | Tags of the Azure Cognitive Search Resource                            |
| `sku`                             | `object` | No       | SKU of the Azure Cognitive Search Resource                             |
| `authOptions`                     | `object` | No       | AuthOptions of the Azure Cognitive Search Resource                     |
| `disableLocalAuth`                | `bool`   | No       | DisableLocalAuth of the Azure Cognitive Search Resource                |
| `disabledDataExfiltrationOptions` | `array`  | No       | DisabledDataExfiltrationOptions of the Azure Cognitive Search Resource |
| `encryptionWithCmk`               | `object` | No       | EncryptionWithCmk of the Azure Cognitive Search Resource               |
| `hostingMode`                     | `string` | No       | HostingMode of the Azure Cognitive Search Resource                     |
| `networkRuleSet`                  | `object` | No       | NetworkRuleSet of the Azure Cognitive Search Resource                  |
| `partitionCount`                  | `int`    | No       | PartitionCount of the Azure Cognitive Search Resource                  |
| `publicNetworkAccess`             | `string` | No       | PublicNetworkAccess of the Azure Cognitive Search Resource             |
| `replicaCount`                    | `int`    | No       | ReplicaCount of the Azure Cognitive Search Resource                    |
| `semanticSearch`                  | `string` | No       | SemanticSearch of the Azure Cognitive Search Resource                  |

## Outputs

| Name       | Type     | Description                                     |
| :--------- | :------: | :---------------------------------------------- |
| `id`       | `string` | ID of the Azure Cognitive Search Resource       |
| `endpoint` | `string` | Endpoint of the Azure Cognitive Search Resource |
| `name`     | `string` | Name of the Azure Cognitive Search Resource     |

## Examples

### Example 1

Deploys a Azure Cognitive Search Service

```
param location string = 'eastus'

module searchService 'br/public:search/search-service:1.0.1' = {
  name: 'mySearchService'
  params: {
    location: location
    sku: {
      name: 'standard'
    }
    semanticSearch: 'free'
  }
}
```
