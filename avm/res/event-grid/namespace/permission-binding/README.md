# Eventgrid Namespace Permissions Bindings `[Microsoft.EventGrid/namespaces/permissionBindings]`

This module deploys an Eventgrid Namespace Permission Binding.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventGrid/namespaces/permissionBindings` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/permissionBindings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientGroupName`](#parameter-clientgroupname) | string | The name of the client group resource that the permission is bound to. The client group needs to be a resource under the same namespace the permission binding is a part of. |
| [`name`](#parameter-name) | string | Name of the Permission Binding. |
| [`permission`](#parameter-permission) | string | The allowed permission. |
| [`topicSpaceName`](#parameter-topicspacename) | string | The name of the Topic Space resource that the permission is bound to. The Topic space needs to be a resource under the same namespace the permission binding is a part of. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Description of the Permission Binding. |

### Parameter: `clientGroupName`

The name of the client group resource that the permission is bound to. The client group needs to be a resource under the same namespace the permission binding is a part of.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the Permission Binding.

- Required: Yes
- Type: string

### Parameter: `permission`

The allowed permission.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Publisher'
    'Subscriber'
  ]
  ```

### Parameter: `topicSpaceName`

The name of the Topic Space resource that the permission is bound to. The Topic space needs to be a resource under the same namespace the permission binding is a part of.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

Description of the Permission Binding.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Permission Binding. |
| `resourceGroupName` | string | The name of the resource group the Permission Binding was created in. |
| `resourceId` | string | The resource ID of the Permission Binding. |
