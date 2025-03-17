# Hybrid Container Service Provisioned Cluster Instance `[Microsoft.HybridContainerService/provisionedClusterInstances]`

Deploy a provisioned cluster instance.

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
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.HybridContainerService/provisionedClusterInstances` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HybridContainerService/2024-01-01/provisionedClusterInstances) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.Kubernetes/connectedClusters` | [2024-07-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kubernetes/2024-07-15-preview/connectedClusters) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2018-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2018-11-30/userAssignedIdentities) |
| `Microsoft.Resources/deploymentScripts` | [2020-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2020-10-01/deploymentScripts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/hybrid-container-service/provisioned-cluster-instance:<version>`.

- [Deploy Aks Arc in default configuration](#example-1-deploy-aks-arc-in-default-configuration)
- [Deploy Aks Arc in WAF aligned configuration](#example-2-deploy-aks-arc-in-waf-aligned-configuration)

### Example 1: _Deploy Aks Arc in default configuration_

This test deploys an Aks Arc.


<details>

<summary>via Bicep module</summary>

```bicep
module provisionedClusterInstance 'br/public:avm/res/hybrid-container-service/provisioned-cluster-instance:<version>' = {
  name: 'provisionedClusterInstanceDeployment'
  params: {
    // Required parameters
    cloudProviderProfile: {
      infraNetworkProfile: {
        vnetSubnetIds: [
          '<resourceId>'
        ]
      }
    }
    customLocationId: '<customLocationId>'
    name: 'hcspcimin001'
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
    "cloudProviderProfile": {
      "value": {
        "infraNetworkProfile": {
          "vnetSubnetIds": [
            "<resourceId>"
          ]
        }
      }
    },
    "customLocationId": {
      "value": "<customLocationId>"
    },
    "name": {
      "value": "hcspcimin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/hybrid-container-service/provisioned-cluster-instance:<version>'

// Required parameters
param cloudProviderProfile = {
  infraNetworkProfile: {
    vnetSubnetIds: [
      '<resourceId>'
    ]
  }
}
param customLocationId = '<customLocationId>'
param name = 'hcspcimin001'
```

</details>
<p>

### Example 2: _Deploy Aks Arc in WAF aligned configuration_

This test deploys an Aks Arc.


<details>

<summary>via Bicep module</summary>

```bicep
module provisionedClusterInstance 'br/public:avm/res/hybrid-container-service/provisioned-cluster-instance:<version>' = {
  name: 'provisionedClusterInstanceDeployment'
  params: {
    // Required parameters
    cloudProviderProfile: {
      infraNetworkProfile: {
        vnetSubnetIds: [
          '<resourceId>'
        ]
      }
    }
    customLocationId: '<customLocationId>'
    name: 'hcspciwaf001'
    // Non-required parameters
    agentPoolProfiles: [
      {
        count: 2
        enableAutoScaling: false
        maxCount: 5
        maxPods: 110
        minCount: 1
        name: 'nodepool1'
        nodeLabels: {}
        nodeTaints: []
        osSKU: 'CBLMariner'
        osType: 'Linux'
        vmSize: 'Standard_A4_v2'
      }
    ]
    controlPlane: {
      controlPlaneEndpoint: {
        hostIP: '<hostIP>'
      }
      count: 2
      vmSize: 'Standard_A4_v2'
    }
    location: '<location>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
    "cloudProviderProfile": {
      "value": {
        "infraNetworkProfile": {
          "vnetSubnetIds": [
            "<resourceId>"
          ]
        }
      }
    },
    "customLocationId": {
      "value": "<customLocationId>"
    },
    "name": {
      "value": "hcspciwaf001"
    },
    // Non-required parameters
    "agentPoolProfiles": {
      "value": [
        {
          "count": 2,
          "enableAutoScaling": false,
          "maxCount": 5,
          "maxPods": 110,
          "minCount": 1,
          "name": "nodepool1",
          "nodeLabels": {},
          "nodeTaints": [],
          "osSKU": "CBLMariner",
          "osType": "Linux",
          "vmSize": "Standard_A4_v2"
        }
      ]
    },
    "controlPlane": {
      "value": {
        "controlPlaneEndpoint": {
          "hostIP": "<hostIP>"
        },
        "count": 2,
        "vmSize": "Standard_A4_v2"
      }
    },
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/hybrid-container-service/provisioned-cluster-instance:<version>'

// Required parameters
param cloudProviderProfile = {
  infraNetworkProfile: {
    vnetSubnetIds: [
      '<resourceId>'
    ]
  }
}
param customLocationId = '<customLocationId>'
param name = 'hcspciwaf001'
// Non-required parameters
param agentPoolProfiles = [
  {
    count: 2
    enableAutoScaling: false
    maxCount: 5
    maxPods: 110
    minCount: 1
    name: 'nodepool1'
    nodeLabels: {}
    nodeTaints: []
    osSKU: 'CBLMariner'
    osType: 'Linux'
    vmSize: 'Standard_A4_v2'
  }
]
param controlPlane = {
  controlPlaneEndpoint: {
    hostIP: '<hostIP>'
  }
  count: 2
  vmSize: 'Standard_A4_v2'
}
param location = '<location>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cloudProviderProfile`](#parameter-cloudproviderprofile) | object | The profile for the underlying cloud infrastructure provider for the provisioned cluster. |
| [`customLocationId`](#parameter-customlocationid) | string | The id of the Custom location that used to create hybrid aks. |
| [`name`](#parameter-name) | string | The name of the provisioned cluster instance. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the key vault. The key vault name. Required if no existing SSH keys. |
| [`sshPublicKey`](#parameter-sshpublickey) | string | The SSH public key that will be used to access the kubernetes cluster nodes. If not specified, a new SSH key pair will be generated. Required if no existing SSH keys. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadAdminGroupObjectIds`](#parameter-aadadmingroupobjectids) | array | The Azure AD admin group object IDs. |
| [`agentAutoUpgrade`](#parameter-agentautoupgrade) | string | Enable automatic agent upgrades. |
| [`agentPoolProfiles`](#parameter-agentpoolprofiles) | array | The agent pool properties for the provisioned cluster. |
| [`connectClustersTags`](#parameter-connectclusterstags) | object | Tags for the cluster resource. |
| [`controlPlane`](#parameter-controlplane) | object | The profile for control plane of the provisioned cluster. |
| [`enableAzureRBAC`](#parameter-enableazurerbac) | bool | Enable Azure RBAC. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`kubernetesVersion`](#parameter-kubernetesversion) | string | The Kubernetes version for the cluster. |
| [`licenseProfile`](#parameter-licenseprofile) | object | The license profile of the provisioned cluster. |
| [`linuxProfile`](#parameter-linuxprofile) | object | The profile for Linux VMs in the provisioned cluster. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`networkProfile`](#parameter-networkprofile) | object | The network configuration profile for the provisioned cluster. |
| [`oidcIssuerEnabled`](#parameter-oidcissuerenabled) | bool | Enable OIDC issuer. |
| [`sshPrivateKeyPemSecretName`](#parameter-sshprivatekeypemsecretname) | string | The name of the secret in the key vault that contains the SSH private key PEM. |
| [`sshPublicKeySecretName`](#parameter-sshpublickeysecretname) | string | The name of the secret in the key vault that contains the SSH public key. |
| [`storageProfile`](#parameter-storageprofile) | object | The storage configuration profile for the provisioned cluster. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`tenantId`](#parameter-tenantid) | string | The Azure AD tenant ID. |
| [`workloadIdentityEnabled`](#parameter-workloadidentityenabled) | bool | Enable workload identity. |

### Parameter: `cloudProviderProfile`

The profile for the underlying cloud infrastructure provider for the provisioned cluster.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`infraNetworkProfile`](#parameter-cloudproviderprofileinfranetworkprofile) | object | The infrastructure network profile configuration. |

### Parameter: `cloudProviderProfile.infraNetworkProfile`

The infrastructure network profile configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`vnetSubnetIds`](#parameter-cloudproviderprofileinfranetworkprofilevnetsubnetids) | array | The list of virtual network subnet IDs. |

### Parameter: `cloudProviderProfile.infraNetworkProfile.vnetSubnetIds`

The list of virtual network subnet IDs.

- Required: Yes
- Type: array

### Parameter: `customLocationId`

The id of the Custom location that used to create hybrid aks.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the provisioned cluster instance.

- Required: Yes
- Type: string

### Parameter: `keyVaultName`

The name of the key vault. The key vault name. Required if no existing SSH keys.

- Required: No
- Type: string

### Parameter: `sshPublicKey`

The SSH public key that will be used to access the kubernetes cluster nodes. If not specified, a new SSH key pair will be generated. Required if no existing SSH keys.

- Required: No
- Type: string

### Parameter: `aadAdminGroupObjectIds`

The Azure AD admin group object IDs.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `agentAutoUpgrade`

Enable automatic agent upgrades.

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

### Parameter: `agentPoolProfiles`

The agent pool properties for the provisioned cluster.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      count: 1
      enableAutoScaling: false
      maxCount: 5
      maxPods: 110
      minCount: 1
      name: 'nodepool1'
      nodeLabels: {}
      nodeTaints: []
      osSKU: 'CBLMariner'
      osType: 'Linux'
      vmSize: 'Standard_A4_v2'
    }
  ]
  ```

**RequiredReqired parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |

### Parameter: `connectClustersTags`

Tags for the cluster resource.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `controlPlane`

The profile for control plane of the provisioned cluster.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      controlPlaneEndpoint: {
        hostIP: null
      }
      count: 1
      vmSize: 'Standard_A4_v2'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`controlPlaneEndpoint`](#parameter-controlplanecontrolplaneendpoint) | object | The control plane endpoint configuration. |
| [`count`](#parameter-controlplanecount) | int | The number of control plane nodes. |
| [`vmSize`](#parameter-controlplanevmsize) | string | The VM size for control plane nodes. |

### Parameter: `controlPlane.controlPlaneEndpoint`

The control plane endpoint configuration.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hostIP`](#parameter-controlplanecontrolplaneendpointhostip) | string | The host IP address of the control plane endpoint. |

### Parameter: `controlPlane.controlPlaneEndpoint.hostIP`

The host IP address of the control plane endpoint.

- Required: No
- Type: string

### Parameter: `controlPlane.count`

The number of control plane nodes.

- Required: Yes
- Type: int

### Parameter: `controlPlane.vmSize`

The VM size for control plane nodes.

- Required: Yes
- Type: string

### Parameter: `enableAzureRBAC`

Enable Azure RBAC.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `kubernetesVersion`

The Kubernetes version for the cluster.

- Required: No
- Type: string

### Parameter: `licenseProfile`

The license profile of the provisioned cluster.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      azureHybridBenefit: 'False'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureHybridBenefit`](#parameter-licenseprofileazurehybridbenefit) | string | Azure Hybrid Benefit configuration. Allowed values: "False", "NotApplicable", "True". |

### Parameter: `licenseProfile.azureHybridBenefit`

Azure Hybrid Benefit configuration. Allowed values: "False", "NotApplicable", "True".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'False'
    'NotApplicable'
    'True'
  ]
  ```

### Parameter: `linuxProfile`

The profile for Linux VMs in the provisioned cluster.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ssh`](#parameter-linuxprofilessh) | object | SSH configuration for Linux nodes. |

### Parameter: `linuxProfile.ssh`

SSH configuration for Linux nodes.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`publicKeys`](#parameter-linuxprofilesshpublickeys) | array | SSH public keys configuration. |

### Parameter: `linuxProfile.ssh.publicKeys`

SSH public keys configuration.

- Required: Yes
- Type: array

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `networkProfile`

The network configuration profile for the provisioned cluster.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      loadBalancerProfile: {
        count: 0
      }
      networkPolicy: 'calico'
      podCidr: '10.244.0.0/16'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loadBalancerProfile`](#parameter-networkprofileloadbalancerprofile) | object | Load balancer profile configuration. |
| [`networkPolicy`](#parameter-networkprofilenetworkpolicy) | string | The network policy to use. |
| [`podCidr`](#parameter-networkprofilepodcidr) | string | The CIDR range for the pods in the kubernetes cluster. |

### Parameter: `networkProfile.loadBalancerProfile`

Load balancer profile configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-networkprofileloadbalancerprofilecount) | int | The number of load balancers. Must be 0 as for now. |

### Parameter: `networkProfile.loadBalancerProfile.count`

The number of load balancers. Must be 0 as for now.

- Required: Yes
- Type: int

### Parameter: `networkProfile.networkPolicy`

The network policy to use.

- Required: Yes
- Type: string

### Parameter: `networkProfile.podCidr`

The CIDR range for the pods in the kubernetes cluster.

- Required: Yes
- Type: string

### Parameter: `oidcIssuerEnabled`

Enable OIDC issuer.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `sshPrivateKeyPemSecretName`

The name of the secret in the key vault that contains the SSH private key PEM.

- Required: No
- Type: string
- Default: `'AksArcAgentSshPrivateKeyPem'`

### Parameter: `sshPublicKeySecretName`

The name of the secret in the key vault that contains the SSH public key.

- Required: No
- Type: string
- Default: `'AksArcAgentSshPublicKey'`

### Parameter: `storageProfile`

The storage configuration profile for the provisioned cluster.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      nfsCsiDriver: {
        enabled: true
      }
      smbCsiDriver: {
        enabled: true
      }
  }
  ```

**RequiredReqired parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `tenantId`

The Azure AD tenant ID.

- Required: No
- Type: string

### Parameter: `workloadIdentityEnabled`

Enable workload identity.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Aks Arc. |
| `resourceGroupName` | string | The resource group of the Aks Arc. |
| `resourceId` | string | The ID of the Aks Arc. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/kubernetes/connected-cluster:0.1.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
