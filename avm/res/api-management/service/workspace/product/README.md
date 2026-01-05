# API Management Workspace Products `[Microsoft.ApiManagement/service/workspaces/products]`

This module deploys a Product in an API Management Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/service/workspaces/products` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_products.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/products)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/products/apiLinks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_products_apilinks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/products/apiLinks)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/products/groupLinks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_products_grouplinks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/products/groupLinks)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/products/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_products_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/products/policies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | Product display name. |
| [`name`](#parameter-name) | string | Product Name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiLinks`](#parameter-apilinks) | array | Names of Product API Links. |
| [`approvalRequired`](#parameter-approvalrequired) | bool | Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product's APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product's APIs. Can be present only if subscriptionRequired property is present and has a value of false. |
| [`description`](#parameter-description) | string | Product description. May include HTML formatting tags. |
| [`groupLinks`](#parameter-grouplinks) | array | Names of Product Group Links. |
| [`policies`](#parameter-policies) | array | Array of Policies to apply to the Product. |
| [`state`](#parameter-state) | string | Whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. |
| [`subscriptionRequired`](#parameter-subscriptionrequired) | bool | Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true. |
| [`subscriptionsLimit`](#parameter-subscriptionslimit) | int | Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false. |
| [`terms`](#parameter-terms) | string | Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process. |

### Parameter: `displayName`

Product display name.

- Required: Yes
- Type: string

### Parameter: `name`

Product Name.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `workspaceName`

The name of the parent Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `apiLinks`

Names of Product API Links.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiResourceId`](#parameter-apilinksapiresourceid) | string | Full resource Id of an API. |
| [`name`](#parameter-apilinksname) | string | The name of the API link. |

### Parameter: `apiLinks.apiResourceId`

Full resource Id of an API.

- Required: Yes
- Type: string

### Parameter: `apiLinks.name`

The name of the API link.

- Required: Yes
- Type: string

### Parameter: `approvalRequired`

Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product's APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product's APIs. Can be present only if subscriptionRequired property is present and has a value of false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `description`

Product description. May include HTML formatting tags.

- Required: No
- Type: string
- Default: `''`

### Parameter: `groupLinks`

Names of Product Group Links.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupResourceId`](#parameter-grouplinksgroupresourceid) | string | Full resource Id of a Group. |
| [`name`](#parameter-grouplinksname) | string | The name of the Product Group link. |

### Parameter: `groupLinks.groupResourceId`

Full resource Id of a Group.

- Required: Yes
- Type: string

### Parameter: `groupLinks.name`

The name of the Product Group link.

- Required: Yes
- Type: string

### Parameter: `policies`

Array of Policies to apply to the Product.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-policiesvalue) | string | Contents of the Policy as defined by the format. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-policiesformat) | string | Format of the policyContent. |
| [`name`](#parameter-policiesname) | string | The name of the policy. |

### Parameter: `policies.value`

Contents of the Policy as defined by the format.

- Required: Yes
- Type: string

### Parameter: `policies.format`

Format of the policyContent.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'rawxml'
    'rawxml-link'
    'xml'
    'xml-link'
  ]
  ```

### Parameter: `policies.name`

The name of the policy.

- Required: No
- Type: string

### Parameter: `state`

Whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators.

- Required: No
- Type: string
- Default: `'published'`
- Allowed:
  ```Bicep
  [
    'notPublished'
    'published'
  ]
  ```

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the workspace product. |
| `resourceGroupName` | string | The resource group the workspace product was deployed into. |
| `resourceId` | string | The resource ID of the workspace product. |
