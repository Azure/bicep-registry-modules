# Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations `[Microsoft.ContainerService/managedClusters/maintenanceConfigurations]`

This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Maintenance Configurations.

You can reference the module as follows:
```bicep
module managedCluster 'br/public:avm/res/container-service/managed-cluster/maintenance-configuration:<version>' = {
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
| `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` | 2025-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerservice_managedclusters_maintenanceconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2025-10-01/managedClusters/maintenanceConfigurations)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
