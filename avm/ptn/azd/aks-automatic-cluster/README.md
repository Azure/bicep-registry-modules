# Azd AKS Automatic Cluster `[Azd/AksAutomaticCluster]`

Creates an Azure Kubernetes Service (AKS) cluster with a system agent pool.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ContainerService/managedClusters` | [2024-03-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2024-03-02-preview/managedClusters) |
| `Microsoft.ContainerService/managedClusters/agentPools` | [2023-07-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-07-02-preview/managedClusters/agentPools) |
| `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` | [2023-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-10-01/managedClusters/maintenanceConfigurations) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KubernetesConfiguration/extensions` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/extensions) |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/fluxConfigurations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/azd/aks-automatic-cluster:<version>`.

- [Using only defaults and use AKS Automatic mode](#example-1-using-only-defaults-and-use-aks-automatic-mode)

### Example 1: _Using only defaults and use AKS Automatic mode_

This instance deploys the module with the set of automatic parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module aksAutomaticCluster 'br/public:avm/ptn/azd/aks-automatic-cluster:<version>' = {
  name: 'aksAutomaticClusterDeployment'
  params: {
    // Required parameters
    name: 'csautomin001'
    // Non-required parameters
    aadProfile: {
      aadProfileEnableAzureRBAC: true
      aadProfileManaged: true
    }
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "csautomin001"
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "aadProfileEnableAzureRBAC": true,
        "aadProfileManaged": true
      }
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/azd/aks-automatic-cluster:<version>'

// Required parameters
param name = 'csautomin001'
// Non-required parameters
param aadProfile = {
  aadProfileEnableAzureRBAC: true
  aadProfileManaged: true
}
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name for the AKS managed cluster. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadProfile`](#parameter-aadprofile) | object | Settigs for the Azure Active Directory integration. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The Azure region/location for the AKS resources. |

### Parameter: `name`

The name for the AKS managed cluster.

- Required: Yes
- Type: string

### Parameter: `aadProfile`

Settigs for the Azure Active Directory integration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadProfileEnableAzureRBAC`](#parameter-aadprofileaadprofileenableazurerbac) | bool | Specifies whether to enable Azure RBAC for Kubernetes authorization. |
| [`aadProfileManaged`](#parameter-aadprofileaadprofilemanaged) | bool | Specifies whether to enable managed AAD integration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadProfileAdminGroupObjectIDs`](#parameter-aadprofileaadprofileadmingroupobjectids) | array | Specifies the AAD group object IDs that will have admin role of the cluster. |
| [`aadProfileClientAppID`](#parameter-aadprofileaadprofileclientappid) | string | The client AAD application ID. |
| [`aadProfileServerAppID`](#parameter-aadprofileaadprofileserverappid) | string | The server AAD application ID. |
| [`aadProfileServerAppSecret`](#parameter-aadprofileaadprofileserverappsecret) | string | The server AAD application secret. |
| [`aadProfileTenantId`](#parameter-aadprofileaadprofiletenantid) | string | Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication. |

### Parameter: `aadProfile.aadProfileEnableAzureRBAC`

Specifies whether to enable Azure RBAC for Kubernetes authorization.

- Required: Yes
- Type: bool

### Parameter: `aadProfile.aadProfileManaged`

Specifies whether to enable managed AAD integration.

- Required: Yes
- Type: bool

### Parameter: `aadProfile.aadProfileAdminGroupObjectIDs`

Specifies the AAD group object IDs that will have admin role of the cluster.

- Required: No
- Type: array

### Parameter: `aadProfile.aadProfileClientAppID`

The client AAD application ID.

- Required: No
- Type: string

### Parameter: `aadProfile.aadProfileServerAppID`

The server AAD application ID.

- Required: No
- Type: string

### Parameter: `aadProfile.aadProfileServerAppSecret`

The server AAD application secret.

- Required: No
- Type: string

### Parameter: `aadProfile.aadProfileTenantId`

Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The Azure region/location for the AKS resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `clusterIdentity` | object | The AKS cluster identity. |
| `clusterName` | string | The resource name of the AKS cluster. |
| `resourceGroupName` | string | The resource group the AKS cluster were deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/container-service/managed-cluster:0.5.3` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
