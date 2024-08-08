# Azure Container Registry (ACR) Webhooks `[Microsoft.ContainerRegistry/registries/webhooks]`

This module deploys an Azure Container Registry (ACR) Webhook.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serviceUri`](#parameter-serviceuri) | string | The service URI for the webhook to post notifications. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`registryName`](#parameter-registryname) | string | The name of the parent registry. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-action) | array | The list of actions that trigger the webhook to post notifications. |
| [`customHeaders`](#parameter-customheaders) | object | Custom headers that will be added to the webhook notifications. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`name`](#parameter-name) | string | The name of the registry webhook. |
| [`scope`](#parameter-scope) | string | The scope of repositories where the event can be triggered. For example, 'foo:*' means events for all tags under repository 'foo'. 'foo:bar' means events for 'foo:bar' only. 'foo' is equivalent to 'foo:latest'. Empty means all events. |
| [`status`](#parameter-status) | string | The status of the webhook at the time the operation was called. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `serviceUri`

The service URI for the webhook to post notifications.

- Required: Yes
- Type: string

### Parameter: `registryName`

The name of the parent registry. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `action`

The list of actions that trigger the webhook to post notifications.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'chart_delete'
    'chart_push'
    'delete'
    'push'
    'quarantine'
  ]
  ```

### Parameter: `customHeaders`

Custom headers that will be added to the webhook notifications.

- Required: No
- Type: object

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `name`

The name of the registry webhook.

- Required: No
- Type: string
- Default: `[format('{0}webhook', parameters('registryName'))]`

### Parameter: `scope`

The scope of repositories where the event can be triggered. For example, 'foo:*' means events for all tags under repository 'foo'. 'foo:bar' means events for 'foo:bar' only. 'foo' is equivalent to 'foo:latest'. Empty means all events.

- Required: No
- Type: string

### Parameter: `status`

The status of the webhook at the time the operation was called.

- Required: No
- Type: string
- Default: `'enabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `actions` | array | The actions of the webhook. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the webhook. |
| `provistioningState` | string | The provisioning state of the webhook. |
| `resourceGroupName` | string | The name of the Azure container registry. |
| `resourceId` | string | The resource ID of the webhook. |
| `status` | string | The status of the webhook. |
