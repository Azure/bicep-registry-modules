# API Management Service Products `[Microsoft.ApiManagement/service/products]`

This module deploys an API Management Service Product.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/products` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/products) |
| `Microsoft.ApiManagement/service/products/apis` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/products/apis) |
| `Microsoft.ApiManagement/service/products/groups` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/products/groups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Product Name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apis`](#parameter-apis) | array | Array of Product APIs. |
| [`approvalRequired`](#parameter-approvalrequired) | bool | Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the products APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the products APIs. Can be present only if subscriptionRequired property is present and has a value of false. |
| [`description`](#parameter-description) | string | Product description. May include HTML formatting tags. |
| [`groups`](#parameter-groups) | array | Array of Product Groups. |
| [`state`](#parameter-state) | string | whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished. - notPublished or published. |
| [`subscriptionRequired`](#parameter-subscriptionrequired) | bool | Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true. |
| [`subscriptionsLimit`](#parameter-subscriptionslimit) | int | Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false. |
| [`terms`](#parameter-terms) | string | Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process. |

### Parameter: `name`

Product Name.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `apis`

Array of Product APIs.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `approvalRequired`

Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the products APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the products APIs. Can be present only if subscriptionRequired property is present and has a value of false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `description`

Product description. May include HTML formatting tags.

- Required: No
- Type: string
- Default: `''`

### Parameter: `groups`

Array of Product Groups.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `state`

whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished. - notPublished or published.

- Required: No
- Type: string
- Default: `'published'`

### Parameter: `subscriptionRequired`

Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `subscriptionsLimit`

Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false.

- Required: No
- Type: int
- Default: `1`

### Parameter: `terms`

Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `apiResourceIds` | array | The Resources IDs of the API management service product APIs. |
| `groupResourceIds` | array | The Resources IDs of the API management service product groups. |
| `name` | string | The name of the API management service product. |
| `resourceGroupName` | string | The resource group the API management service product was deployed into. |
| `resourceId` | string | The resource ID of the API management service product. |
