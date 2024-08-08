# API Management Service Subscriptions `[Microsoft.ApiManagement/service/subscriptions]`

This module deploys an API Management Service Subscription.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/subscriptions` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/subscriptions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Subscription name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowTracing`](#parameter-allowtracing) | bool | Determines whether tracing can be enabled. |
| [`ownerId`](#parameter-ownerid) | string | User (user ID path) for whom subscription is being created in form /users/{userId}. |
| [`primaryKey`](#parameter-primarykey) | string | Primary subscription key. If not specified during request key will be generated automatically. |
| [`scope`](#parameter-scope) | string | Scope type to choose between a product, "allAPIs" or a specific API. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}". |
| [`secondaryKey`](#parameter-secondarykey) | string | Secondary subscription key. If not specified during request key will be generated automatically. |
| [`state`](#parameter-state) | string | Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are "*" active "?" the subscription is active, "*" suspended "?" the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled. |

### Parameter: `name`

Subscription name.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `allowTracing`

Determines whether tracing can be enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `ownerId`

User (user ID path) for whom subscription is being created in form /users/{userId}.

- Required: No
- Type: string

### Parameter: `primaryKey`

Primary subscription key. If not specified during request key will be generated automatically.

- Required: No
- Type: string

### Parameter: `scope`

Scope type to choose between a product, "allAPIs" or a specific API. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}".

- Required: No
- Type: string
- Default: `'/apis'`

### Parameter: `secondaryKey`

Secondary subscription key. If not specified during request key will be generated automatically.

- Required: No
- Type: string

### Parameter: `state`

Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are "*" active "?" the subscription is active, "*" suspended "?" the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service subscription. |
| `resourceGroupName` | string | The resource group the API management service subscription was deployed into. |
| `resourceId` | string | The resource ID of the API management service subscription. |
