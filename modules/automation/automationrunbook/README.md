# Automation Runbook

Creates an Azure Automation Account with Runbook, Schedule and Jobs

## Description

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
| `schedulesToCreate`       | `array`  | No       | Which Automation Schedules to create                                                                                     |
| `runbookJobSchedule`      | `array`  | No       | The Runbook-Schedule Jobs to create                                                                                      |
| `runbookName`             | `string` | Yes      | The name of the runbook to create                                                                                        |
| `runbookType`             | `string` | No       | The type of runbook that is being imported                                                                               |
| `runbookUri`              | `string` | No       | The URI to import the runbook code from                                                                                  |

## Outputs

| Name                         | Type   | Description                         |
| :--------------------------- | :----: | :---------------------------------- |
| automationAccountPrincipalId | string | The Automation Account Principal Id |

## Examples

### Starting and Stopping Virtual Machines, for UTC time-zone

```bicep
```

### Starting and Stopping Virtual Machines, for a specific time-zone

```bicep
```

### Scaling up AKS Clusters

```bicep
```

### Starting and Stopping AKS Clusters

```bicep
```

### Creating an Automation Account and Schedules without Runbook

```bicep
```