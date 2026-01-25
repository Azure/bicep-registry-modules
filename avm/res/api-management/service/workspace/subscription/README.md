# API Management Workspace Subscriptions `[Microsoft.ApiManagement/service/workspaces/subscriptions]`

This module deploys a Subscription in an API Management Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/service/workspaces/subscriptions` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_subscriptions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/subscriptions)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | API Management Service Subscriptions name. |
| [`name`](#parameter-name) | string | Subscription name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowTracing`](#parameter-allowtracing) | bool | Determines whether tracing can be enabled. |
| [`ownerId`](#parameter-ownerid) | string | User (user ID path) for whom subscription is being created in form /users/{userId}. |
| [`primaryKey`](#parameter-primarykey) | securestring | Primary subscription key. If not specified during request key will be generated automatically. |
| [`scope`](#parameter-scope) | string | Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}". |
| [`secondaryKey`](#parameter-secondarykey) | securestring | Secondary subscription key. If not specified during request key will be generated automatically. |
| [`state`](#parameter-state) | string | Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are:<p>* active - the subscription is active<p>* suspended - the subscription is blocked, and the subscriber cannot call any APIs of the product<p>* submitted - the subscription request has been made by the developer, but has not yet been approved or rejected<p>* rejected - the subscription request has been denied by an administrator<p>* cancelled - the subscription has been cancelled by the developer or administrator<p>* expired - the subscription reached its expiration date and was deactivated. |

### Parameter: `displayName`

API Management Service Subscriptions name.

- Required: Yes
- Type: string

### Parameter: `name`

Subscription name.

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
- Type: securestring

### Parameter: `scope`

Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}".

- Required: No
- Type: string
- Default: `'/apis'`

### Parameter: `secondaryKey`

Secondary subscription key. If not specified during request key will be generated automatically.

- Required: No
- Type: securestring

### Parameter: `state`

Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are:<p>* active - the subscription is active<p>* suspended - the subscription is blocked, and the subscriber cannot call any APIs of the product<p>* submitted - the subscription request has been made by the developer, but has not yet been approved or rejected<p>* rejected - the subscription request has been denied by an administrator<p>* cancelled - the subscription has been cancelled by the developer or administrator<p>* expired - the subscription reached its expiration date and was deactivated.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'active'
    'cancelled'
    'expired'
    'rejected'
    'submitted'
    'suspended'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the workspace subscription. |
| `resourceGroupName` | string | The resource group the workspace subscription was deployed into. |
| `resourceId` | string | The resource ID of the workspace subscription. |
