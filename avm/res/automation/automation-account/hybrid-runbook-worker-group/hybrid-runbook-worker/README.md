# Automation Account Hybrid Runbook Worker Group Workers `[Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups/hybridRunbookWorkers]`

This module deploys an Azure Automation Account Hybrid Runbook Worker Group Worker.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups/hybridRunbookWorkers` | 2024-10-23 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automation_automationaccounts_hybridrunbookworkergroups_hybridrunbookworkers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2024-10-23/automationAccounts/hybridRunbookWorkerGroups/hybridRunbookWorkers)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Hybrid Runbook Worker Group Worker. |
| [`vmResourceId`](#parameter-vmresourceid) | string | Azure Resource Manager Id for a virtual machine. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |
| [`hybridRunbookWorkerGroupName`](#parameter-hybridrunbookworkergroupname) | string | The name of the parent Hybrid Runbook Worker Group. Required if the template is used in a standalone deployment. |

### Parameter: `name`

Name of the Hybrid Runbook Worker Group Worker.

- Required: Yes
- Type: string

### Parameter: `vmResourceId`

Azure Resource Manager Id for a virtual machine.

- Required: Yes
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `hybridRunbookWorkerGroupName`

The name of the parent Hybrid Runbook Worker Group. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed hybrid runbook worker. |
| `resourceGroupName` | string | The resource group of the deployed hybrid runbook worker. |
| `resourceId` | string | The resource ID of the deployed hybrid runbook worker. |
