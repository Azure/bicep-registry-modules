# Azure Functions App

Deploy an Azure Function Application using this Bicep Module.

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                      | Type     | Required | Description                                                                                                                      |
| :------------------------ | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------- |
| `location`                | `string` | Yes      | Deployment Location                                                                                                              |
| `name`                    | `string` | No       | Name of Storage Account. Must be unique within Azure.                                                                            |
| `serverFarmName`          | `string` | No       | Name of the resource group that will contain the resources.                                                                      |
| `enableVNET`              | `bool`   | No       | Enables VNET integration. Default value is false.                                                                                |
| `skuName`                 | `string` | No       | Describes plan's pricing tier and instance size. Check details at https://azure.microsoft.com/en-us/pricing/details/app-service/ |
| `skuCapacity`             | `int`    | No       | Describes plan's instance count                                                                                                  |
| `runtime`                 | `string` | No       | The runtime that the function app is using. Default value is node.                                                               |
| `subnetID`                | `string` | No       | The subnet resource ID if VNET integration is enabled. Default value is empty.                                                   |
| `httpsOnly`               | `bool`   | No       | Enforces HTTPS-only access to the function app. Default value is true.                                                           |
| `minTlsVersion`           | `string` | No       | Specifies the minimum TLS version required for SSL requests. Default value is 1.2.                                               |
| `appInsightsLocation`     | `string` | No       | Location for Application Insights                                                                                                |
| `applicationInsightsName` | `string` | No       | Name of Application Insights. Must be unique within Azure.                                                                       |
| `storageAccountName`      | `string` | No       | Name of Storage Account. Must be unique within Azure.                                                                            |
| `storageAccountType`      | `string` | No       | Storage Account type                                                                                                             |

## Outputs

| Name | Type   | Description |
| :--- | :----: | :---------- |
| id   | string |             |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```