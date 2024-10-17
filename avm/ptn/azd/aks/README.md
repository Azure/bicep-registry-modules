# Azd AKS `[Azd/Aks]`

Creates an Azure Kubernetes Service (AKS) cluster with a system agent pool as well as an additional user agent pool.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.

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
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.ContainerService/managedClusters` | [2024-03-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2024-03-02-preview/managedClusters) |
| `Microsoft.ContainerService/managedClusters/agentPools` | [2023-07-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-07-02-preview/managedClusters/agentPools) |
| `Microsoft.ContainerService/managedClusters/maintenanceConfigurations` | [2023-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2023-10-01/managedClusters/maintenanceConfigurations) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.KubernetesConfiguration/extensions` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/extensions) |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2022-03-01/fluxConfigurations) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/azd/aks:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module aks 'br/public:avm/ptn/azd/aks:<version>' = {
  name: 'aksDeployment'
  params: {
    // Required parameters
    containerRegistryName: '<containerRegistryName>'
    keyVaultName: '<keyVaultName>'
    monitoringWorkspaceResourceId: '<monitoringWorkspaceResourceId>'
    name: '<name>'
    principalId: '<principalId>'
    // Non-required parameters
    location: '<location>'
    principalType: 'ServicePrincipal'
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
    "containerRegistryName": {
      "value": "<containerRegistryName>"
    },
    "keyVaultName": {
      "value": "<keyVaultName>"
    },
    "monitoringWorkspaceResourceId": {
      "value": "<monitoringWorkspaceResourceId>"
    },
    "name": {
      "value": "<name>"
    },
    "principalId": {
      "value": "<principalId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/azd/aks:<version>'

// Required parameters
param containerRegistryName = '<containerRegistryName>'
param keyVaultName = '<keyVaultName>'
param monitoringWorkspaceResourceId = '<monitoringWorkspaceResourceId>'
param name = '<name>'
param principalId = '<principalId>'
// Non-required parameters
param location = '<location>'
param principalType = 'ServicePrincipal'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module aks 'br/public:avm/ptn/azd/aks:<version>' = {
  name: 'aksDeployment'
  params: {
    // Required parameters
    containerRegistryName: '<containerRegistryName>'
    keyVaultName: '<keyVaultName>'
    monitoringWorkspaceResourceId: '<monitoringWorkspaceResourceId>'
    name: '<name>'
    principalId: '<principalId>'
    // Non-required parameters
    acrSku: 'Basic'
    aksClusterRoleAssignmentName: '<aksClusterRoleAssignmentName>'
    containerRegistryRoleName: '<containerRegistryRoleName>'
    dnsPrefix: 'dep-dns-paamax'
    location: '<location>'
    principalType: 'ServicePrincipal'
    skuTier: 'Free'
    webApplicationRoutingEnabled: true
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
    "containerRegistryName": {
      "value": "<containerRegistryName>"
    },
    "keyVaultName": {
      "value": "<keyVaultName>"
    },
    "monitoringWorkspaceResourceId": {
      "value": "<monitoringWorkspaceResourceId>"
    },
    "name": {
      "value": "<name>"
    },
    "principalId": {
      "value": "<principalId>"
    },
    // Non-required parameters
    "acrSku": {
      "value": "Basic"
    },
    "aksClusterRoleAssignmentName": {
      "value": "<aksClusterRoleAssignmentName>"
    },
    "containerRegistryRoleName": {
      "value": "<containerRegistryRoleName>"
    },
    "dnsPrefix": {
      "value": "dep-dns-paamax"
    },
    "location": {
      "value": "<location>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    },
    "skuTier": {
      "value": "Free"
    },
    "webApplicationRoutingEnabled": {
      "value": true
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/azd/aks:<version>'

// Required parameters
param containerRegistryName = '<containerRegistryName>'
param keyVaultName = '<keyVaultName>'
param monitoringWorkspaceResourceId = '<monitoringWorkspaceResourceId>'
param name = '<name>'
param principalId = '<principalId>'
// Non-required parameters
param acrSku = 'Basic'
param aksClusterRoleAssignmentName = '<aksClusterRoleAssignmentName>'
param containerRegistryRoleName = '<containerRegistryRoleName>'
param dnsPrefix = 'dep-dns-paamax'
param location = '<location>'
param principalType = 'ServicePrincipal'
param skuTier = 'Free'
param webApplicationRoutingEnabled = true
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerRegistryName`](#parameter-containerregistryname) | string | Name of your Azure Container Registry. |
| [`keyVaultName`](#parameter-keyvaultname) | string | Name of the Key Vault. Must be globally unique. |
| [`monitoringWorkspaceResourceId`](#parameter-monitoringworkspaceresourceid) | string | Resource ID of the monitoring log analytics workspace. |
| [`name`](#parameter-name) | string | The name of the parent managed cluster. Required if the template is used in a standalone deployment. |
| [`principalId`](#parameter-principalid) | string | Id of the user or app to assign application roles. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appGatewayResourceId`](#parameter-appgatewayresourceid) | string | Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`acrSku`](#parameter-acrsku) | string | Tier of your Azure container registry. |
| [`agentPoolConfig`](#parameter-agentpoolconfig) | object | Custom configuration of user node pool. |
| [`agentPoolType`](#parameter-agentpooltype) | string | The User Pool Preset sizing. |
| [`aksClusterRoleAssignmentName`](#parameter-aksclusterroleassignmentname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`autoNodeOsUpgradeProfileUpgradeChannel`](#parameter-autonodeosupgradeprofileupgradechannel) | string | Auto-upgrade channel on the Node Os. |
| [`containerRegistryRoleName`](#parameter-containerregistryrolename) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`disableLocalAccounts`](#parameter-disablelocalaccounts) | bool | If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled. |
| [`dnsPrefix`](#parameter-dnsprefix) | string | Specifies the DNS prefix specified when creating the managed cluster. |
| [`dnsServiceIP`](#parameter-dnsserviceip) | string | Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr. |
| [`enableKeyvaultSecretsProvider`](#parameter-enablekeyvaultsecretsprovider) | bool | Specifies whether the KeyvaultSecretsProvider add-on is enabled or not. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`kubernetesVersion`](#parameter-kubernetesversion) | string | Kubernetes Version. |
| [`loadBalancerSku`](#parameter-loadbalancersku) | string | Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools. |
| [`location`](#parameter-location) | string | Specifies the location of AKS cluster. It picks up Resource Group's location by default. |
| [`networkDataplane`](#parameter-networkdataplane) | string | Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin. |
| [`networkPlugin`](#parameter-networkplugin) | string | Network plugin used for building the Kubernetes network. |
| [`networkPluginMode`](#parameter-networkpluginmode) | string | Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin. |
| [`networkPolicy`](#parameter-networkpolicy) | string | Specifies the network policy used for building Kubernetes network. - calico or azure. |
| [`nodeResourceGroupName`](#parameter-noderesourcegroupname) | string | The name of the resource group for the managed resources of the AKS cluster. |
| [`podCidr`](#parameter-podcidr) | string | Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used. |
| [`principalType`](#parameter-principaltype) | string | The type of principal to assign application roles. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.  Note, requires the 'acrSku' to be 'Premium'. |
| [`scopeMaps`](#parameter-scopemaps) | array | Scope maps setting. |
| [`serviceCidr`](#parameter-servicecidr) | string | A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges. |
| [`skuTier`](#parameter-skutier) | string | Tier of a managed cluster SKU. |
| [`sshPublicKey`](#parameter-sshpublickey) | string | Specifies the SSH RSA public key string for the Linux nodes. |
| [`systemPoolConfig`](#parameter-systempoolconfig) | object | Custom configuration of system node pool. |
| [`systemPoolType`](#parameter-systempooltype) | string | The System Pool Preset sizing. |
| [`tags`](#parameter-tags) | object | Custom tags to apply to the AKS resources. |
| [`webApplicationRoutingEnabled`](#parameter-webapplicationroutingenabled) | bool | Specifies whether the webApplicationRoutingEnabled add-on is enabled or not. |

### Parameter: `containerRegistryName`

Name of your Azure Container Registry.

- Required: Yes
- Type: string

### Parameter: `keyVaultName`

Name of the Key Vault. Must be globally unique.

- Required: Yes
- Type: string

### Parameter: `monitoringWorkspaceResourceId`

Resource ID of the monitoring log analytics workspace.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the parent managed cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `principalId`

Id of the user or app to assign application roles.

- Required: Yes
- Type: string

### Parameter: `appGatewayResourceId`

Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`.

- Required: No
- Type: string

### Parameter: `acrSku`

Tier of your Azure container registry.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `agentPoolConfig`

Custom configuration of user node pool.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `agentPoolType`

The User Pool Preset sizing.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'CostOptimised'
    'Custom'
    'HighSpec'
    'Standard'
  ]
  ```

### Parameter: `aksClusterRoleAssignmentName`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `autoNodeOsUpgradeProfileUpgradeChannel`

Auto-upgrade channel on the Node Os.

- Required: No
- Type: string
- Default: `'NodeImage'`
- Allowed:
  ```Bicep
  [
    'NodeImage'
    'None'
    'SecurityPatch'
    'Unmanaged'
  ]
  ```

### Parameter: `containerRegistryRoleName`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `disableLocalAccounts`

If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `dnsPrefix`

Specifies the DNS prefix specified when creating the managed cluster.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `dnsServiceIP`

Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.

- Required: No
- Type: string

### Parameter: `enableKeyvaultSecretsProvider`

Specifies whether the KeyvaultSecretsProvider add-on is enabled or not.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `kubernetesVersion`

Kubernetes Version.

- Required: No
- Type: string
- Default: `'1.29'`

### Parameter: `loadBalancerSku`

Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools.

- Required: No
- Type: string
- Default: `'standard'`
- Allowed:
  ```Bicep
  [
    'basic'
    'standard'
  ]
  ```

### Parameter: `location`

Specifies the location of AKS cluster. It picks up Resource Group's location by default.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `networkDataplane`

Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'azure'
    'cilium'
  ]
  ```

### Parameter: `networkPlugin`

Network plugin used for building the Kubernetes network.

- Required: No
- Type: string
- Default: `'azure'`
- Allowed:
  ```Bicep
  [
    'azure'
    'kubenet'
  ]
  ```

### Parameter: `networkPluginMode`

Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'overlay'
  ]
  ```

### Parameter: `networkPolicy`

Specifies the network policy used for building Kubernetes network. - calico or azure.

- Required: No
- Type: string
- Default: `'azure'`
- Allowed:
  ```Bicep
  [
    'azure'
    'calico'
  ]
  ```

### Parameter: `nodeResourceGroupName`

The name of the resource group for the managed resources of the AKS cluster.

- Required: No
- Type: string
- Default: `''`

### Parameter: `podCidr`

Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used.

- Required: No
- Type: string

### Parameter: `principalType`

The type of principal to assign application roles.

- Required: No
- Type: string
- Default: `'User'`
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.  Note, requires the 'acrSku' to be 'Premium'.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `scopeMaps`

Scope maps setting.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-scopemapsactions) | array | The list of scoped permissions for registry artifacts. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-scopemapsdescription) | string | The user friendly description of the scope map. |
| [`name`](#parameter-scopemapsname) | string | The name of the scope map. |

### Parameter: `scopeMaps.actions`

The list of scoped permissions for registry artifacts.

- Required: Yes
- Type: array

### Parameter: `scopeMaps.description`

The user friendly description of the scope map.

- Required: No
- Type: string

### Parameter: `scopeMaps.name`

The name of the scope map.

- Required: No
- Type: string

### Parameter: `serviceCidr`

A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.

- Required: No
- Type: string

### Parameter: `skuTier`

Tier of a managed cluster SKU.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `sshPublicKey`

Specifies the SSH RSA public key string for the Linux nodes.

- Required: No
- Type: string

### Parameter: `systemPoolConfig`

Custom configuration of system node pool.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `systemPoolType`

The System Pool Preset sizing.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'CostOptimised'
    'Custom'
    'HighSpec'
    'Standard'
  ]
  ```

### Parameter: `tags`

Custom tags to apply to the AKS resources.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `webApplicationRoutingEnabled`

Specifies whether the webApplicationRoutingEnabled add-on is enabled or not.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `containerRegistryLoginServer` | string | The login server for the container registry. |
| `containerRegistryName` | string | The resource name of the ACR. |
| `managedClusterClientId` | string | The Client ID of the AKS identity. |
| `managedClusterName` | string | The resource name of the AKS cluster. |
| `managedClusterObjectId` | string | The Object ID of the AKS identity. |
| `managedClusterResourceId` | string | The resource ID of the AKS cluster. |
| `resourceGroupName` | string | The resource group the application insights components were deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/container-registry/registry:0.5.1` | Remote reference |
| `br/public:avm/res/container-service/managed-cluster:0.4.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.9.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
