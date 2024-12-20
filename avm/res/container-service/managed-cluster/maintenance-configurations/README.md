# Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations `[Microsoft.ContainerService/managedClusters/maintenanceConfigurations]`

This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` | [2023-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-10-01/managedClusters/maintenanceConfigurations) |

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the maintenance configuration. |
| `resourceGroupName` | string | The resource group the agent pool was deployed into. |
| `resourceId` | string | The resource ID of the maintenance configuration. |
