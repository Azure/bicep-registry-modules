# Automation Runbook

Creates an Azure Automation Account with Runbook, Schedule and Jobs

## Details

This module creates an Azure Automation Account with Runbook, Schedule and Jobs to quickly facilitate automation practices.

Several common schedules are created, which can then optionally be linked to a Runbook.

- 8am - daily
- 8am - weekday
- 7pm - daily
- 7pm - weekday
- midnight - daily
- midnight - weekday

## Parameters

| Name                      | Type     | Required | Description                                                                                                              |
| :------------------------ | :------: | :------: | :----------------------------------------------------------------------------------------------------------------------- |
| `automationAccountName`   | `string` | Yes      | The name of the Automation Account                                                                                       |
| `location`                | `string` | No       | Deployment Location                                                                                                      |
| `today`                   | `string` | No       | Used to reference todays date                                                                                            |
| `timezone`                | `string` | No       | The timezone to align schedules to. (Eg. "Europe/London" or "America/Los_Angeles")                                       |
| `accountSku`              | `string` | No       | The Automation Account SKU. See https://learn.microsoft.com/en-us/azure/automation/overview#pricing-for-azure-automation |
| `loganalyticsWorkspaceId` | `string` | No       | For Automation job logging                                                                                               |
| `diagnosticCategories`    | `array`  | No       | Which logging categeories to log                                                                                         |
| `schedulesToCreate`       | `array`  | No       | Automation Schedules to create                                                                                           |
| `runbookJobSchedule`      | `array`  | Yes      | The Runbook-Schedule Jobs to create with workflow specific parameters                                                    |
| `runbookName`             | `string` | Yes      | The name of the runbook to create                                                                                        |
| `runbookType`             | `string` | No       | The type of runbook that is being imported                                                                               |
| `runbookUri`              | `string` | No       | The URI to import the runbook code from                                                                                  |
| `runbookDescription`      | `string` | No       | A description of what the runbook does                                                                                   |

## Outputs

| Name                           | Type     | Description                                  |
| :----------------------------- | :------: | :------------------------------------------- |
| `automationAccountName`        | `string` | The Automation Account name                  |
| `automationAccountId`          | `string` | The Automation Account resource Id           |
| `automationAccountPrincipalId` | `string` | The Automation Account identity Principal Id |

## Examples

### Starting Virtual Machines, for UTC time-zone

```bicep
module VmStartStop  'br/public:automation/automationrunbook:1.0.1' = {
  name: 'VmStart'
  params: {
    location: location
    automationAccountName: 'VmManagement'
    runbookName: 'StartAzureVMs'
    runbookUri: 'https://raw.githubusercontent.com/azureautomation/update-management-turn-on-vms/master/UpdateManagement-TurnOnVms.ps1'
    runbookType: ''
    runbookDescription: 'This Graphical PowerShell runbook connects to Azure using an Automation Run As account and starts all V2 VMs in an Azure subscription or in a resource group or a single named V2 VM. You can attach a recurring schedule to this runbook to run it at a specific time.'
    runbookJobSchedule: [
      {
        schedule: 'Weekday - 9am'
        parameters: {
          ResourceGroupName : 'myRG'
        }
      }
    ]
  }
}

```

### Starting and Stopping AKS Clusters

```bicep
module AksStartStop 'br/public:automation/automationrunbook:1.0.1' = {
  name: 'AksStartStop'
  params: {
    location: location
    automationAccountName: 'AksAutomation'
    runbookName: 'aks-cluster-changestate'
    runbookUri: 'https://raw.githubusercontent.com/finoops/aks-cluster-changestate/main/aks-cluster-changestate.ps1'
    runbookType: 'Script'
    runbookJobSchedule: [
      {
        Schedule: 'Weekday - 9am'
        parameters: {
          ResourceGroupName : 'myRG'
          AksClusterName : 'myVM'
          Operation: 'start'
        }
      }
      {
        Schedule: 'Weekday - 7pm'
        parameters: {
          ResourceGroupName : 'myRG'
          AksClusterName : 'myVM'
          Operation: 'stop'
        }
      }
    ]
  }
}

//Create RBAC so the Automation Account can actually start/stop AKS Clusters
var roleDefinitionId=subscriptionResourceId('Microsoft.Authorization/roleDefinitions' 'b24988ac-6180-42a0-ab88-20f7382dd24c'))
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id,roleDefinitionId)
  scope: resourceGroup()
  properties: {
    principalId: AksStartStop.outputs.automationAccountPrincipalId
    roleDefinitionId: roleDefinitionId
    principalType: 'ServicePrincipal'
  }
}
```

### Creating an Automation Account and Schedules without Runbook

```bicep
module noRunbook 'br/public:automation/automationrunbook:1.0.1' = {
  name: 'noRunbook'
  params: {
    location: location
    automationAccountName: 'Automatron'
    runbookName: ''
  }
}
```

### Creating an Automation Account and custom Schedules without Runbook

```bicep
@description('Pacific Standard Time')
var pst = '00-07:00'

module customSchedule 'br/public:automation/automationrunbook:1.0.1' = {
  name: 'customSchedule'
  params: {
    location: location
    automationAccountName: 'noRunbook'
    runbookName: '' //empty will skip runbook creation
    runbookJobSchedule: [] //with no runbook being created, we'll skip job creation too.
    timezone: pst
    schedulesToCreate: [
      {
        frequency:'Day'
        hour:8
        minute:30
      }
    ]
  }
}
```