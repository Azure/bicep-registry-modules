# Automation Account Hybrid Runbook Worker Groups `[Microsoft.Automation/automationAccounts/hybridRunbookWorkerGroups]`

This module deploys an Azure Automation Account Hybrid Runbook Worker Group.

You can reference the module as follows:
```bicep
module automationAccount 'br/public:avm/res/automation/automation-account/hybrid-runbook-worker-group:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
