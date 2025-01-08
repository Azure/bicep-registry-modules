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
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-11-01-preview/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/webhooks) |
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
    aadProfile: {
      aadProfileEnableAzureRBAC: true
      aadProfileManaged: true
    }
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
    "aadProfile": {
      "value": {
        "aadProfileEnableAzureRBAC": true,
        "aadProfileManaged": true
      }
    },
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
param aadProfile = {
  aadProfileEnableAzureRBAC: true
  aadProfileManaged: true
}
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
    aadProfile: '<aadProfile>'
    acrSku: 'Basic'
    agentPoolConfig: [
      {
        maxPods: 30
        maxSurge: '33%'
        mode: 'User'
        name: 'npuserpool'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        vmSize: 'Standard_DS2_v2'
      }
    ]
    agentPoolSize: 'Standard'
    aksClusterRoleAssignmentName: '<aksClusterRoleAssignmentName>'
    containerRegistryRoleName: '<containerRegistryRoleName>'
    disableLocalAccounts: false
    dnsPrefix: 'dep-dns-paamax'
    location: '<location>'
    principalType: 'ServicePrincipal'
    skuTier: 'Free'
    systemPoolConfig: [
      {
        availabilityZones: [
          1
          2
          3
        ]
        count: 3
        enableAutoScaling: true
        maxCount: 5
        minCount: 3
        mode: 'System'
        name: 'npsystem'
        vmSize: 'Standard_DS2_v2'
      }
    ]
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
    "aadProfile": {
      "value": "<aadProfile>"
    },
    "acrSku": {
      "value": "Basic"
    },
    "agentPoolConfig": {
      "value": [
        {
          "maxPods": 30,
          "maxSurge": "33%",
          "mode": "User",
          "name": "npuserpool",
          "osType": "Linux",
          "type": "VirtualMachineScaleSets",
          "vmSize": "Standard_DS2_v2"
        }
      ]
    },
    "agentPoolSize": {
      "value": "Standard"
    },
    "aksClusterRoleAssignmentName": {
      "value": "<aksClusterRoleAssignmentName>"
    },
    "containerRegistryRoleName": {
      "value": "<containerRegistryRoleName>"
    },
    "disableLocalAccounts": {
      "value": false
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
    "systemPoolConfig": {
      "value": [
        {
          "availabilityZones": [
            1,
            2,
            3
          ],
          "count": 3,
          "enableAutoScaling": true,
          "maxCount": 5,
          "minCount": 3,
          "mode": "System",
          "name": "npsystem",
          "vmSize": "Standard_DS2_v2"
        }
      ]
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
param aadProfile = '<aadProfile>'
param acrSku = 'Basic'
param agentPoolConfig = [
  {
    maxPods: 30
    maxSurge: '33%'
    mode: 'User'
    name: 'npuserpool'
    osType: 'Linux'
    type: 'VirtualMachineScaleSets'
    vmSize: 'Standard_DS2_v2'
  }
]
param agentPoolSize = 'Standard'
param aksClusterRoleAssignmentName = '<aksClusterRoleAssignmentName>'
param containerRegistryRoleName = '<containerRegistryRoleName>'
param disableLocalAccounts = false
param dnsPrefix = 'dep-dns-paamax'
param location = '<location>'
param principalType = 'ServicePrincipal'
param skuTier = 'Free'
param systemPoolConfig = [
  {
    availabilityZones: [
      1
      2
      3
    ]
    count: 3
    enableAutoScaling: true
    maxCount: 5
    minCount: 3
    mode: 'System'
    name: 'npsystem'
    vmSize: 'Standard_DS2_v2'
  }
]
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
| [`aadProfile`](#parameter-aadprofile) | object | Enable Azure Active Directory integration. |
| [`acrSku`](#parameter-acrsku) | string | Tier of your Azure container registry. |
| [`agentPoolConfig`](#parameter-agentpoolconfig) | array | Custom configuration of user node pool. |
| [`agentPoolSize`](#parameter-agentpoolsize) | string | The User Pool Preset sizing. |
| [`aksClusterRoleAssignmentName`](#parameter-aksclusterroleassignmentname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`autoNodeOsUpgradeProfileUpgradeChannel`](#parameter-autonodeosupgradeprofileupgradechannel) | string | Auto-upgrade channel on the Node Os. |
| [`containerRegistryRoleName`](#parameter-containerregistryrolename) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`disableLocalAccounts`](#parameter-disablelocalaccounts) | bool | If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled. |
| [`dnsPrefix`](#parameter-dnsprefix) | string | Specifies the DNS prefix specified when creating the managed cluster. |
| [`dnsServiceIP`](#parameter-dnsserviceip) | string | Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr. |
| [`enableAzureRbac`](#parameter-enableazurerbac) | bool | Enable RBAC using AAD. |
| [`enableKeyvaultSecretsProvider`](#parameter-enablekeyvaultsecretsprovider) | bool | Specifies whether the KeyvaultSecretsProvider add-on is enabled or not. |
| [`enablePurgeProtection`](#parameter-enablepurgeprotection) | bool | Provide 'true' to enable Key Vault's purge protection feature. |
| [`enableRbacAuthorization`](#parameter-enablerbacauthorization) | bool | Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored. When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. Note that management actions are always authorized with RBAC. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`enableVaultForDeployment`](#parameter-enablevaultfordeployment) | bool | Specifies if the vault is enabled for deployment by script or compute. |
| [`enableVaultForTemplateDeployment`](#parameter-enablevaultfortemplatedeployment) | bool | Specifies if the vault is enabled for a template deployment. |
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
| [`systemPoolConfig`](#parameter-systempoolconfig) | array | Custom configuration of system node pool. |
| [`systemPoolSize`](#parameter-systempoolsize) | string | The System Pool Preset sizing. |
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

### Parameter: `aadProfile`

Enable Azure Active Directory integration.

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
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-agentpoolconfigname) | string | The name of the agent pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-agentpoolconfigavailabilityzones) | array | The availability zones of the agent pool. |
| [`count`](#parameter-agentpoolconfigcount) | int | The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`enableAutoScaling`](#parameter-agentpoolconfigenableautoscaling) | bool | Whether to enable auto-scaling for the agent pool. |
| [`enableDefaultTelemetry`](#parameter-agentpoolconfigenabledefaulttelemetry) | bool | The enable default telemetry of the agent pool. |
| [`enableEncryptionAtHost`](#parameter-agentpoolconfigenableencryptionathost) | bool | Whether to enable encryption at host for the agent pool. |
| [`enableFIPS`](#parameter-agentpoolconfigenablefips) | bool | Whether to enable FIPS for the agent pool. |
| [`enableNodePublicIP`](#parameter-agentpoolconfigenablenodepublicip) | bool | Whether to enable node public IP for the agent pool. |
| [`enableUltraSSD`](#parameter-agentpoolconfigenableultrassd) | bool | Whether to enable Ultra SSD for the agent pool. |
| [`gpuInstanceProfile`](#parameter-agentpoolconfiggpuinstanceprofile) | string | The GPU instance profile of the agent pool. |
| [`kubeletDiskType`](#parameter-agentpoolconfigkubeletdisktype) | string | The kubelet disk type of the agent pool. |
| [`maxCount`](#parameter-agentpoolconfigmaxcount) | int | The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`maxPods`](#parameter-agentpoolconfigmaxpods) | int | The maximum number of pods that can run on a node. |
| [`maxSurge`](#parameter-agentpoolconfigmaxsurge) | string | The maximum number of nodes that can be created during an upgrade. |
| [`minCount`](#parameter-agentpoolconfigmincount) | int | The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`minPods`](#parameter-agentpoolconfigminpods) | int | The minimum number of pods that can run on a node. |
| [`mode`](#parameter-agentpoolconfigmode) | string | The mode of the agent pool. |
| [`nodeLabels`](#parameter-agentpoolconfignodelabels) | object | The node labels of the agent pool. |
| [`nodePublicIpPrefixResourceId`](#parameter-agentpoolconfignodepublicipprefixresourceid) | string | The node public IP prefix ID of the agent pool. |
| [`nodeTaints`](#parameter-agentpoolconfignodetaints) | array | The node taints of the agent pool. |
| [`orchestratorVersion`](#parameter-agentpoolconfigorchestratorversion) | string | The Kubernetes version of the agent pool. |
| [`osDiskSizeGB`](#parameter-agentpoolconfigosdisksizegb) | int | The OS disk size in GB of the agent pool. |
| [`osDiskType`](#parameter-agentpoolconfigosdisktype) | string | The OS disk type of the agent pool. |
| [`osSku`](#parameter-agentpoolconfigossku) | string | The OS SKU of the agent pool. |
| [`osType`](#parameter-agentpoolconfigostype) | string | The OS type of the agent pool. |
| [`podSubnetResourceId`](#parameter-agentpoolconfigpodsubnetresourceid) | string | The pod subnet ID of the agent pool. |
| [`proximityPlacementGroupResourceId`](#parameter-agentpoolconfigproximityplacementgroupresourceid) | string | The proximity placement group resource ID of the agent pool. |
| [`scaleDownMode`](#parameter-agentpoolconfigscaledownmode) | string | The scale down mode of the agent pool. |
| [`scaleSetEvictionPolicy`](#parameter-agentpoolconfigscalesetevictionpolicy) | string | The scale set eviction policy of the agent pool. |
| [`scaleSetPriority`](#parameter-agentpoolconfigscalesetpriority) | string | The scale set priority of the agent pool. |
| [`sourceResourceId`](#parameter-agentpoolconfigsourceresourceid) | string | The source resource ID to create the agent pool from. |
| [`spotMaxPrice`](#parameter-agentpoolconfigspotmaxprice) | int | The spot max price of the agent pool. |
| [`tags`](#parameter-agentpoolconfigtags) | object | The tags of the agent pool. |
| [`type`](#parameter-agentpoolconfigtype) | string | The type of the agent pool. |
| [`vmSize`](#parameter-agentpoolconfigvmsize) | string | The VM size of the agent pool. |
| [`vnetSubnetResourceId`](#parameter-agentpoolconfigvnetsubnetresourceid) | string | The VNet subnet ID of the agent pool. |
| [`workloadRuntime`](#parameter-agentpoolconfigworkloadruntime) | string | The workload runtime of the agent pool. |

### Parameter: `agentPoolConfig.name`

The name of the agent pool.

- Required: Yes
- Type: string

### Parameter: `agentPoolConfig.availabilityZones`

The availability zones of the agent pool.

- Required: No
- Type: array

### Parameter: `agentPoolConfig.count`

The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `agentPoolConfig.enableAutoScaling`

Whether to enable auto-scaling for the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPoolConfig.enableDefaultTelemetry`

The enable default telemetry of the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPoolConfig.enableEncryptionAtHost`

Whether to enable encryption at host for the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPoolConfig.enableFIPS`

Whether to enable FIPS for the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPoolConfig.enableNodePublicIP`

Whether to enable node public IP for the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPoolConfig.enableUltraSSD`

Whether to enable Ultra SSD for the agent pool.

- Required: No
- Type: bool

### Parameter: `agentPoolConfig.gpuInstanceProfile`

The GPU instance profile of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'MIG1g'
    'MIG2g'
    'MIG3g'
    'MIG4g'
    'MIG7g'
  ]
  ```

### Parameter: `agentPoolConfig.kubeletDiskType`

The kubelet disk type of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.maxCount`

The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `agentPoolConfig.maxPods`

The maximum number of pods that can run on a node.

- Required: No
- Type: int

### Parameter: `agentPoolConfig.maxSurge`

The maximum number of nodes that can be created during an upgrade.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.minCount`

The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `agentPoolConfig.minPods`

The minimum number of pods that can run on a node.

- Required: No
- Type: int

### Parameter: `agentPoolConfig.mode`

The mode of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'System'
    'User'
  ]
  ```

### Parameter: `agentPoolConfig.nodeLabels`

The node labels of the agent pool.

- Required: No
- Type: object

### Parameter: `agentPoolConfig.nodePublicIpPrefixResourceId`

The node public IP prefix ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.nodeTaints`

The node taints of the agent pool.

- Required: No
- Type: array

### Parameter: `agentPoolConfig.orchestratorVersion`

The Kubernetes version of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.osDiskSizeGB`

The OS disk size in GB of the agent pool.

- Required: No
- Type: int

### Parameter: `agentPoolConfig.osDiskType`

The OS disk type of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.osSku`

The OS SKU of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.osType`

The OS type of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `agentPoolConfig.podSubnetResourceId`

The pod subnet ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.proximityPlacementGroupResourceId`

The proximity placement group resource ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.scaleDownMode`

The scale down mode of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Deallocate'
    'Delete'
  ]
  ```

### Parameter: `agentPoolConfig.scaleSetEvictionPolicy`

The scale set eviction policy of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Deallocate'
    'Delete'
  ]
  ```

### Parameter: `agentPoolConfig.scaleSetPriority`

The scale set priority of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Low'
    'Regular'
    'Spot'
  ]
  ```

### Parameter: `agentPoolConfig.sourceResourceId`

The source resource ID to create the agent pool from.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.spotMaxPrice`

The spot max price of the agent pool.

- Required: No
- Type: int

### Parameter: `agentPoolConfig.tags`

The tags of the agent pool.

- Required: No
- Type: object

### Parameter: `agentPoolConfig.type`

The type of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AvailabilitySet'
    'VirtualMachineScaleSets'
  ]
  ```

### Parameter: `agentPoolConfig.vmSize`

The VM size of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.vnetSubnetResourceId`

The VNet subnet ID of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPoolConfig.workloadRuntime`

The workload runtime of the agent pool.

- Required: No
- Type: string

### Parameter: `agentPoolSize`

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
- Default: `True`

### Parameter: `dnsPrefix`

Specifies the DNS prefix specified when creating the managed cluster.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `dnsServiceIP`

Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.

- Required: No
- Type: string

### Parameter: `enableAzureRbac`

Enable RBAC using AAD.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableKeyvaultSecretsProvider`

Specifies whether the KeyvaultSecretsProvider add-on is enabled or not.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enablePurgeProtection`

Provide 'true' to enable Key Vault's purge protection feature.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRbacAuthorization`

Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored. When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. Note that management actions are always authorized with RBAC.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableVaultForDeployment`

Specifies if the vault is enabled for deployment by script or compute.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableVaultForTemplateDeployment`

Specifies if the vault is enabled for a template deployment.

- Required: No
- Type: bool
- Default: `False`

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
- Default: `[format('rg-mc-{0}', parameters('name'))]`

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
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-systempoolconfigname) | string | The name of the agent pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-systempoolconfigavailabilityzones) | array | The availability zones of the agent pool. |
| [`count`](#parameter-systempoolconfigcount) | int | The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`enableAutoScaling`](#parameter-systempoolconfigenableautoscaling) | bool | Whether to enable auto-scaling for the agent pool. |
| [`enableDefaultTelemetry`](#parameter-systempoolconfigenabledefaulttelemetry) | bool | The enable default telemetry of the agent pool. |
| [`enableEncryptionAtHost`](#parameter-systempoolconfigenableencryptionathost) | bool | Whether to enable encryption at host for the agent pool. |
| [`enableFIPS`](#parameter-systempoolconfigenablefips) | bool | Whether to enable FIPS for the agent pool. |
| [`enableNodePublicIP`](#parameter-systempoolconfigenablenodepublicip) | bool | Whether to enable node public IP for the agent pool. |
| [`enableUltraSSD`](#parameter-systempoolconfigenableultrassd) | bool | Whether to enable Ultra SSD for the agent pool. |
| [`gpuInstanceProfile`](#parameter-systempoolconfiggpuinstanceprofile) | string | The GPU instance profile of the agent pool. |
| [`kubeletDiskType`](#parameter-systempoolconfigkubeletdisktype) | string | The kubelet disk type of the agent pool. |
| [`maxCount`](#parameter-systempoolconfigmaxcount) | int | The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`maxPods`](#parameter-systempoolconfigmaxpods) | int | The maximum number of pods that can run on a node. |
| [`maxSurge`](#parameter-systempoolconfigmaxsurge) | string | The maximum number of nodes that can be created during an upgrade. |
| [`minCount`](#parameter-systempoolconfigmincount) | int | The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive). |
| [`minPods`](#parameter-systempoolconfigminpods) | int | The minimum number of pods that can run on a node. |
| [`mode`](#parameter-systempoolconfigmode) | string | The mode of the agent pool. |
| [`nodeLabels`](#parameter-systempoolconfignodelabels) | object | The node labels of the agent pool. |
| [`nodePublicIpPrefixResourceId`](#parameter-systempoolconfignodepublicipprefixresourceid) | string | The node public IP prefix ID of the agent pool. |
| [`nodeTaints`](#parameter-systempoolconfignodetaints) | array | The node taints of the agent pool. |
| [`orchestratorVersion`](#parameter-systempoolconfigorchestratorversion) | string | The Kubernetes version of the agent pool. |
| [`osDiskSizeGB`](#parameter-systempoolconfigosdisksizegb) | int | The OS disk size in GB of the agent pool. |
| [`osDiskType`](#parameter-systempoolconfigosdisktype) | string | The OS disk type of the agent pool. |
| [`osSku`](#parameter-systempoolconfigossku) | string | The OS SKU of the agent pool. |
| [`osType`](#parameter-systempoolconfigostype) | string | The OS type of the agent pool. |
| [`podSubnetResourceId`](#parameter-systempoolconfigpodsubnetresourceid) | string | The pod subnet ID of the agent pool. |
| [`proximityPlacementGroupResourceId`](#parameter-systempoolconfigproximityplacementgroupresourceid) | string | The proximity placement group resource ID of the agent pool. |
| [`scaleDownMode`](#parameter-systempoolconfigscaledownmode) | string | The scale down mode of the agent pool. |
| [`scaleSetEvictionPolicy`](#parameter-systempoolconfigscalesetevictionpolicy) | string | The scale set eviction policy of the agent pool. |
| [`scaleSetPriority`](#parameter-systempoolconfigscalesetpriority) | string | The scale set priority of the agent pool. |
| [`sourceResourceId`](#parameter-systempoolconfigsourceresourceid) | string | The source resource ID to create the agent pool from. |
| [`spotMaxPrice`](#parameter-systempoolconfigspotmaxprice) | int | The spot max price of the agent pool. |
| [`tags`](#parameter-systempoolconfigtags) | object | The tags of the agent pool. |
| [`type`](#parameter-systempoolconfigtype) | string | The type of the agent pool. |
| [`vmSize`](#parameter-systempoolconfigvmsize) | string | The VM size of the agent pool. |
| [`vnetSubnetResourceId`](#parameter-systempoolconfigvnetsubnetresourceid) | string | The VNet subnet ID of the agent pool. |
| [`workloadRuntime`](#parameter-systempoolconfigworkloadruntime) | string | The workload runtime of the agent pool. |

### Parameter: `systemPoolConfig.name`

The name of the agent pool.

- Required: Yes
- Type: string

### Parameter: `systemPoolConfig.availabilityZones`

The availability zones of the agent pool.

- Required: No
- Type: array

### Parameter: `systemPoolConfig.count`

The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `systemPoolConfig.enableAutoScaling`

Whether to enable auto-scaling for the agent pool.

- Required: No
- Type: bool

### Parameter: `systemPoolConfig.enableDefaultTelemetry`

The enable default telemetry of the agent pool.

- Required: No
- Type: bool

### Parameter: `systemPoolConfig.enableEncryptionAtHost`

Whether to enable encryption at host for the agent pool.

- Required: No
- Type: bool

### Parameter: `systemPoolConfig.enableFIPS`

Whether to enable FIPS for the agent pool.

- Required: No
- Type: bool

### Parameter: `systemPoolConfig.enableNodePublicIP`

Whether to enable node public IP for the agent pool.

- Required: No
- Type: bool

### Parameter: `systemPoolConfig.enableUltraSSD`

Whether to enable Ultra SSD for the agent pool.

- Required: No
- Type: bool

### Parameter: `systemPoolConfig.gpuInstanceProfile`

The GPU instance profile of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'MIG1g'
    'MIG2g'
    'MIG3g'
    'MIG4g'
    'MIG7g'
  ]
  ```

### Parameter: `systemPoolConfig.kubeletDiskType`

The kubelet disk type of the agent pool.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.maxCount`

The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `systemPoolConfig.maxPods`

The maximum number of pods that can run on a node.

- Required: No
- Type: int

### Parameter: `systemPoolConfig.maxSurge`

The maximum number of nodes that can be created during an upgrade.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.minCount`

The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).

- Required: No
- Type: int

### Parameter: `systemPoolConfig.minPods`

The minimum number of pods that can run on a node.

- Required: No
- Type: int

### Parameter: `systemPoolConfig.mode`

The mode of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'System'
    'User'
  ]
  ```

### Parameter: `systemPoolConfig.nodeLabels`

The node labels of the agent pool.

- Required: No
- Type: object

### Parameter: `systemPoolConfig.nodePublicIpPrefixResourceId`

The node public IP prefix ID of the agent pool.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.nodeTaints`

The node taints of the agent pool.

- Required: No
- Type: array

### Parameter: `systemPoolConfig.orchestratorVersion`

The Kubernetes version of the agent pool.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.osDiskSizeGB`

The OS disk size in GB of the agent pool.

- Required: No
- Type: int

### Parameter: `systemPoolConfig.osDiskType`

The OS disk type of the agent pool.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.osSku`

The OS SKU of the agent pool.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.osType`

The OS type of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `systemPoolConfig.podSubnetResourceId`

The pod subnet ID of the agent pool.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.proximityPlacementGroupResourceId`

The proximity placement group resource ID of the agent pool.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.scaleDownMode`

The scale down mode of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Deallocate'
    'Delete'
  ]
  ```

### Parameter: `systemPoolConfig.scaleSetEvictionPolicy`

The scale set eviction policy of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Deallocate'
    'Delete'
  ]
  ```

### Parameter: `systemPoolConfig.scaleSetPriority`

The scale set priority of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Low'
    'Regular'
    'Spot'
  ]
  ```

### Parameter: `systemPoolConfig.sourceResourceId`

The source resource ID to create the agent pool from.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.spotMaxPrice`

The spot max price of the agent pool.

- Required: No
- Type: int

### Parameter: `systemPoolConfig.tags`

The tags of the agent pool.

- Required: No
- Type: object

### Parameter: `systemPoolConfig.type`

The type of the agent pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AvailabilitySet'
    'VirtualMachineScaleSets'
  ]
  ```

### Parameter: `systemPoolConfig.vmSize`

The VM size of the agent pool.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.vnetSubnetResourceId`

The VNet subnet ID of the agent pool.

- Required: No
- Type: string

### Parameter: `systemPoolConfig.workloadRuntime`

The workload runtime of the agent pool.

- Required: No
- Type: string

### Parameter: `systemPoolSize`

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
| `br/public:avm/res/container-service/managed-cluster:0.5.2` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.9.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
