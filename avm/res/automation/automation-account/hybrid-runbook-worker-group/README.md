# Automation Account Hybrid Runbook Worker Groups `[Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups]`

This module deploys an Azure Automation Account Hybrid Runbook Worker Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups` | 2024-10-23 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automation_automationaccounts_hybridrunbookworkergroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2024-10-23/automationAccounts/hybridRunbookWorkerGroups)</li></ul> |
| `Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups/hybridRunbookWorkers` | 2024-10-23 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automation_automationaccounts_hybridrunbookworkergroups_hybridrunbookworkers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2024-10-23/automationAccounts/hybridRunbookWorkerGroups/hybridRunbookWorkers)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Hybrid Runbook Worker Group. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentialName`](#parameter-credentialname) | string | Gets or sets the name of the credential. |
| [`hybridRunbookWorkerGroupWorkers`](#parameter-hybridrunbookworkergroupworkers) | array | An array of Hybrid Runbook Worker Group Workers to deploy with the Hybrid Runbook Worker Group. |

### Parameter: `name`

Name of the Hybrid Runbook Worker Group.

- Required: Yes
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `credentialName`

Gets or sets the name of the credential.

- Required: No
- Type: string

### Parameter: `hybridRunbookWorkerGroupWorkers`

An array of Hybrid Runbook Worker Group Workers to deploy with the Hybrid Runbook Worker Group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`vmResourceId`](#parameter-hybridrunbookworkergroupworkersvmresourceid) | string | Azure Resource Manager Id for a virtual machine. |

### Parameter: `hybridRunbookWorkerGroupWorkers.vmResourceId`

Azure Resource Manager Id for a virtual machine.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed hybrid runbook worker group. |
| `resourceGroupName` | string | The resource group of the deployed hybrid runbook worker group. |
| `resourceId` | string | The resource ID of the deployed hybrid runbook worker group. |
