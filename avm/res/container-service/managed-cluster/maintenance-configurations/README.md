# Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations `[Microsoft.ContainerService/managedClusters/maintenanceConfigurations]`

This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` | 2025-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerservice_managedclusters_maintenanceconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2025-09-01/managedClusters/maintenanceConfigurations)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maintenanceWindow`](#parameter-maintenancewindow) | object | Maintenance window for the maintenance configuration. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedClusterName`](#parameter-managedclustername) | string | The name of the parent managed cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the maintenance configuration. |
| [`notAllowedTime`](#parameter-notallowedtime) | array | Time slots on which upgrade is not allowed. |
| [`timeInWeek`](#parameter-timeinweek) | array | Time slots during the week when planned maintenance is allowed to proceed. |

### Parameter: `maintenanceWindow`

Maintenance window for the maintenance configuration.

- Required: Yes
- Type: object

### Parameter: `managedClusterName`

The name of the parent managed cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the maintenance configuration.

- Required: No
- Type: string
- Default: `'aksManagedAutoUpgradeSchedule'`

### Parameter: `notAllowedTime`

Time slots on which upgrade is not allowed.

- Required: No
- Type: array

### Parameter: `timeInWeek`

Time slots during the week when planned maintenance is allowed to proceed.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the maintenance configuration. |
| `resourceGroupName` | string | The resource group the agent pool was deployed into. |
| `resourceId` | string | The resource ID of the maintenance configuration. |
