# Bing Resource

This module deploys Azure Bing Resource

## Description

Azure Bing resource refers to the integration of Bing's search capabilities into the Azure platform. Azure provides the Azure Cognitive Search service, which allows you to incorporate powerful search functionality, including web search, image search, news search, video search, and more, using Bing's search algorithms.
This Bicep Module helps to create Bing Search Kind resource. You may need to register Microsoft/Bing resource provider for your subscription before using this module.

## Parameters

| Name                | Type     | Required | Description                                                                                                 |
| :------------------ | :------: | :------: | :---------------------------------------------------------------------------------------------------------- |
| `prefix`            | `string` | No       | Prefix of Resource Name. Not used if name is provided                                                       |
| `location`          | `string` | No       | The location into which your Azure resources should be deployed.                                            |
| `name`              | `string` | No       | The name of the Bing Service.                                                                               |
| `kind`              | `string` | No       | Optional. This parameter will define Bing search kind.                                                      |
| `skuName`           | `string` | No       | Optional. The name of the SKU, F* (free) and S* (standard). Supported SKUs will differ based on search kind |
| `statisticsEnabled` | `bool`   | No       | Optional. Enable or disable Bing statistics.                                                                |
| `tags`              | `object` | No       | Optional. Tags of the resource.                                                                             |

## Outputs

| Name       | Type     | Description     |
| :--------- | :------: | :-------------- |
| `id`       | `string` | Bing account ID |
| `endpoint` | `string` | Bing Endpoint   |

## Examples

### Example 1

Deploy a Bing Search v7 resource with the free SKU

```
module bing-search-resource 'br/public:ai/bing-resource:1.0.1' = {
  name: 'bing-search-resource'
  params: {
     kind: 'Bing.Search.v7'
     location: 'global'
     name: 'bing-search-resource-name-01'
     skuName: 'S1'
  }
}
```

### Example 2

Deploy a Bing Custom Search resource with the standard SKU

```
module bing-search-resource 'br/public:ai/bing-resource:1.0.1' = {
  name: 'bing-search-resource'
  params: {
     kind: 'Bing.CustomSearch'
     location: 'global'
     name: 'bing-search-resource-name-02'
     skuName: 'S1'
  }
}
```