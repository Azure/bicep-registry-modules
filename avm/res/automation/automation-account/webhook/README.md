# Automation Account Webhook `[Microsoft.Automation/automationAccounts/webhooks]`

This module deploys an Azure Automation Account Webhook.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Automation/automationAccounts/webhooks` | 2024-10-23 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automation_automationaccounts_webhooks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2024-10-23/automationAccounts/webhooks)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the webhook. |
| [`runbookName`](#parameter-runbookname) | string | The runbook in which the webhook will be used. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`expiryTime`](#parameter-expirytime) | string | The expiration time of the webhook. |
| [`parameters`](#parameter-parameters) | object | List of job properties. |
| [`runOn`](#parameter-runon) | string | The hybrid worker group that the scheduled job should run on. |

### Parameter: `name`

The name of the webhook.

- Required: Yes
- Type: string

### Parameter: `runbookName`

The runbook in which the webhook will be used.

- Required: Yes
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `expiryTime`

The expiration time of the webhook.

- Required: No
- Type: string
- Default: `[utcNow()]`

### Parameter: `parameters`

List of job properties.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `runOn`

The hybrid worker group that the scheduled job should run on.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed variable. |
| `resourceGroupName` | string | The resource group of the deployed variable. |
| `resourceId` | string | The resource ID of the deployed variable. |
| `uri` | string | The URI of the deployed webhook. |
