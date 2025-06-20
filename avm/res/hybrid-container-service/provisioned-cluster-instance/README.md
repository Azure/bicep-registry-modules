# Hybrid Container Service Provisioned Cluster Instance `[Microsoft.HybridContainerService/provisionedClusterInstances]`

Deploy a provisioned cluster instance.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.HybridContainerService/provisionedClusterInstances` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HybridContainerService/2024-01-01/provisionedClusterInstances) |
| `Microsoft.Kubernetes/connectedClusters` | [2024-07-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kubernetes/2024-07-15-preview/connectedClusters) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2024-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/hybrid-container-service/provisioned-cluster-instance:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


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
    customLocationResourceId: '<customLocationResourceId>'
    name: 'hcpcimin001'
    // Non-required parameters
    keyVaultName: '<keyVaultName>'
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
    "customLocationResourceId": {
      "value": "<customLocationResourceId>"
    },
    "name": {
      "value": "hcpcimin001"
    },
    // Non-required parameters
    "keyVaultName": {
      "value": "<keyVaultName>"
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
param customLocationResourceId = '<customLocationResourceId>'
param name = 'hcpcimin001'
// Non-required parameters
param keyVaultName = '<keyVaultName>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


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
    customLocationResourceId: '<customLocationResourceId>'
    name: 'hcpcimax001'
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
    arcAgentProfile: {
      agentAutoUpgrade: 'Enabled'
    }
    connectClustersTags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    controlPlane: {
      controlPlaneEndpoint: {
        hostIP: '<hostIP>'
      }
      count: 1
      vmSize: 'Standard_A4_v2'
    }
    enableTelemetry: true
    keyVaultName: '<keyVaultName>'
    kubernetesVersion: '1.29.4'
    licenseProfile: {
      azureHybridBenefit: 'False'
    }
    location: '<location>'
    oidcIssuerProfile: {
      enabled: false
    }
    securityProfile: {
      workloadIdentity: {
        enabled: false
      }
    }
    storageProfile: {
      nfsCsiDriver: {
        enabled: true
      }
      smbCsiDriver: {
        enabled: true
      }
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
    "customLocationResourceId": {
      "value": "<customLocationResourceId>"
    },
    "name": {
      "value": "hcpcimax001"
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
    "arcAgentProfile": {
      "value": {
        "agentAutoUpgrade": "Enabled"
      }
    },
    "connectClustersTags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "controlPlane": {
      "value": {
        "controlPlaneEndpoint": {
          "hostIP": "<hostIP>"
        },
        "count": 1,
        "vmSize": "Standard_A4_v2"
      }
    },
    "enableTelemetry": {
      "value": true
    },
    "keyVaultName": {
      "value": "<keyVaultName>"
    },
    "kubernetesVersion": {
      "value": "1.29.4"
    },
    "licenseProfile": {
      "value": {
        "azureHybridBenefit": "False"
      }
    },
    "location": {
      "value": "<location>"
    },
    "oidcIssuerProfile": {
      "value": {
        "enabled": false
      }
    },
    "securityProfile": {
      "value": {
        "workloadIdentity": {
          "enabled": false
        }
      }
    },
    "storageProfile": {
      "value": {
        "nfsCsiDriver": {
          "enabled": true
        },
        "smbCsiDriver": {
          "enabled": true
        }
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
param customLocationResourceId = '<customLocationResourceId>'
param name = 'hcpcimax001'
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
param arcAgentProfile = {
  agentAutoUpgrade: 'Enabled'
}
param connectClustersTags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param controlPlane = {
  controlPlaneEndpoint: {
    hostIP: '<hostIP>'
  }
  count: 1
  vmSize: 'Standard_A4_v2'
}
param enableTelemetry = true
param keyVaultName = '<keyVaultName>'
param kubernetesVersion = '1.29.4'
param licenseProfile = {
  azureHybridBenefit: 'False'
}
param location = '<location>'
param oidcIssuerProfile = {
  enabled: false
}
param securityProfile = {
  workloadIdentity: {
    enabled: false
  }
}
param storageProfile = {
  nfsCsiDriver: {
    enabled: true
  }
  smbCsiDriver: {
    enabled: true
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


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
    customLocationResourceId: '<customLocationResourceId>'
    name: 'hcpciwaf001'
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
    connectClustersTags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    controlPlane: {
      controlPlaneEndpoint: {
        hostIP: '<hostIP>'
      }
      count: 1
      vmSize: 'Standard_A4_v2'
    }
    keyVaultName: '<keyVaultName>'
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
    "customLocationResourceId": {
      "value": "<customLocationResourceId>"
    },
    "name": {
      "value": "hcpciwaf001"
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
    "connectClustersTags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "controlPlane": {
      "value": {
        "controlPlaneEndpoint": {
          "hostIP": "<hostIP>"
        },
        "count": 1,
        "vmSize": "Standard_A4_v2"
      }
    },
    "keyVaultName": {
      "value": "<keyVaultName>"
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
param customLocationResourceId = '<customLocationResourceId>'
param name = 'hcpciwaf001'
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
param connectClustersTags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param controlPlane = {
  controlPlaneEndpoint: {
    hostIP: '<hostIP>'
  }
  count: 1
  vmSize: 'Standard_A4_v2'
}
param keyVaultName = '<keyVaultName>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cloudProviderProfile`](#parameter-cloudproviderprofile) | object | The profile for the underlying cloud infrastructure provider for the provisioned cluster. |
| [`customLocationResourceId`](#parameter-customlocationresourceid) | string | The id of the Custom location that used to create hybrid aks. |
| [`name`](#parameter-name) | string | The name of the provisioned cluster instance. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the key vault. The key vault name. Required if no existing SSH keys. |
| [`keyvaultResourceGroup`](#parameter-keyvaultresourcegroup) | string | Key vault resource group, which is used for for storing secrets for the HCI cluster. Required if no existing SSH keys and key vault is in different resource group. |
| [`keyvaultSubscriptionId`](#parameter-keyvaultsubscriptionid) | string | Key vault subscription ID, which is used for for storing secrets for the HCI cluster. Required if no existing SSH keys and key vault is in different subscription. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadProfile`](#parameter-aadprofile) | object | AAD profile for the connected cluster. |
| [`agentPoolProfiles`](#parameter-agentpoolprofiles) | array | The agent pool properties for the provisioned cluster. |
| [`arcAgentProfile`](#parameter-arcagentprofile) | object | Arc agentry configuration for the provisioned cluster. |
| [`connectClustersTags`](#parameter-connectclusterstags) | object | Tags for the cluster resource. |
| [`controlPlane`](#parameter-controlplane) | object | The profile for control plane of the provisioned cluster. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`kubernetesVersion`](#parameter-kubernetesversion) | string | The Kubernetes version for the cluster. |
| [`licenseProfile`](#parameter-licenseprofile) | object | The license profile of the provisioned cluster. |
| [`linuxProfile`](#parameter-linuxprofile) | object | The profile for Linux VMs in the provisioned cluster. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`networkProfile`](#parameter-networkprofile) | object | The network configuration profile for the provisioned cluster. |
| [`oidcIssuerProfile`](#parameter-oidcissuerprofile) | object | Open ID Connect (OIDC) Issuer Profile for the connected cluster. |
| [`securityProfile`](#parameter-securityprofile) | object | Security profile for the connected cluster. |
| [`sshPrivateKeyPemSecretName`](#parameter-sshprivatekeypemsecretname) | string | The name of the secret in the key vault that contains the SSH private key PEM. |
| [`sshPublicKeySecretName`](#parameter-sshpublickeysecretname) | string | The name of the secret in the key vault that contains the SSH public key. |
| [`storageProfile`](#parameter-storageprofile) | object | The storage configuration profile for the provisioned cluster. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

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

### Parameter: `customLocationResourceId`

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

### Parameter: `keyvaultResourceGroup`

Key vault resource group, which is used for for storing secrets for the HCI cluster. Required if no existing SSH keys and key vault is in different resource group.

- Required: No
- Type: string

### Parameter: `keyvaultSubscriptionId`

Key vault subscription ID, which is used for for storing secrets for the HCI cluster. Required if no existing SSH keys and key vault is in different subscription.

- Required: No
- Type: string

### Parameter: `aadProfile`

AAD profile for the connected cluster.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminGroupObjectIDs`](#parameter-aadprofileadmingroupobjectids) | array | The list of AAD group object IDs that will have admin role of the cluster. |
| [`enableAzureRBAC`](#parameter-aadprofileenableazurerbac) | bool | Whether to enable Azure RBAC for Kubernetes authorization. |
| [`tenantID`](#parameter-aadprofiletenantid) | string | The AAD tenant ID. |

### Parameter: `aadProfile.adminGroupObjectIDs`

The list of AAD group object IDs that will have admin role of the cluster.

- Required: Yes
- Type: array

### Parameter: `aadProfile.enableAzureRBAC`

Whether to enable Azure RBAC for Kubernetes authorization.

- Required: Yes
- Type: bool

### Parameter: `aadProfile.tenantID`

The AAD tenant ID.

- Required: Yes
- Type: string

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
      osSKU: 'CBLMariner'
      osType: 'Linux'
      vmSize: 'Standard_A4_v2'
    }
  ]
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-agentpoolprofilescount) | int | The number of nodes for the pool. |
| [`enableAutoScaling`](#parameter-agentpoolprofilesenableautoscaling) | bool | Whether to enable auto-scaling for the pool. |
| [`maxCount`](#parameter-agentpoolprofilesmaxcount) | int | The maximum number of nodes for auto-scaling. |
| [`maxPods`](#parameter-agentpoolprofilesmaxpods) | int | The maximum number of pods per node. |
| [`minCount`](#parameter-agentpoolprofilesmincount) | int | The minimum number of nodes for auto-scaling. |
| [`name`](#parameter-agentpoolprofilesname) | string | The name of the agent pool. |
| [`osSKU`](#parameter-agentpoolprofilesossku) | string | The OS SKU for the nodes. |
| [`osType`](#parameter-agentpoolprofilesostype) | string | The OS type for the nodes. |
| [`vmSize`](#parameter-agentpoolprofilesvmsize) | string | The VM size for the nodes. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nodeLabels`](#parameter-agentpoolprofilesnodelabels) | object | The node labels to be applied to nodes in the pool. |
| [`nodeTaints`](#parameter-agentpoolprofilesnodetaints) | array | The taints to be applied to nodes in the pool. |

### Parameter: `agentPoolProfiles.count`

The number of nodes for the pool.

- Required: Yes
- Type: int

### Parameter: `agentPoolProfiles.enableAutoScaling`

Whether to enable auto-scaling for the pool.

- Required: Yes
- Type: bool

### Parameter: `agentPoolProfiles.maxCount`

The maximum number of nodes for auto-scaling.

- Required: Yes
- Type: int

### Parameter: `agentPoolProfiles.maxPods`

The maximum number of pods per node.

- Required: Yes
- Type: int

### Parameter: `agentPoolProfiles.minCount`

The minimum number of nodes for auto-scaling.

- Required: Yes
- Type: int

### Parameter: `agentPoolProfiles.name`

The name of the agent pool.

- Required: Yes
- Type: string

### Parameter: `agentPoolProfiles.osSKU`

The OS SKU for the nodes.

- Required: Yes
- Type: string

### Parameter: `agentPoolProfiles.osType`

The OS type for the nodes.

- Required: Yes
- Type: string

### Parameter: `agentPoolProfiles.vmSize`

The VM size for the nodes.

- Required: Yes
- Type: string

### Parameter: `agentPoolProfiles.nodeLabels`

The node labels to be applied to nodes in the pool.

- Required: No
- Type: object

### Parameter: `agentPoolProfiles.nodeTaints`

The taints to be applied to nodes in the pool.

- Required: No
- Type: array

### Parameter: `arcAgentProfile`

Arc agentry configuration for the provisioned cluster.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      agentAutoUpgrade: 'Enabled'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentAutoUpgrade`](#parameter-arcagentprofileagentautoupgrade) | string | Indicates whether the Arc agents on the be upgraded automatically to the latest version. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentErrors`](#parameter-arcagentprofileagenterrors) | array | The errors encountered by the Arc agent. |
| [`desiredAgentVersion`](#parameter-arcagentprofiledesiredagentversion) | string | The desired version of the Arc agent. |
| [`systemComponents`](#parameter-arcagentprofilesystemcomponents) | array | List of system extensions that are installed on the cluster resource. |

### Parameter: `arcAgentProfile.agentAutoUpgrade`

Indicates whether the Arc agents on the be upgraded automatically to the latest version.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `arcAgentProfile.agentErrors`

The errors encountered by the Arc agent.

- Required: No
- Type: array

### Parameter: `arcAgentProfile.desiredAgentVersion`

The desired version of the Arc agent.

- Required: No
- Type: string

### Parameter: `arcAgentProfile.systemComponents`

List of system extensions that are installed on the cluster resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`majorVersion`](#parameter-arcagentprofilesystemcomponentsmajorversion) | int | The major version of the system component. |
| [`type`](#parameter-arcagentprofilesystemcomponentstype) | string | The type of the system component. |
| [`userSpecifiedVersion`](#parameter-arcagentprofilesystemcomponentsuserspecifiedversion) | string | The user specified version of the system component. |

### Parameter: `arcAgentProfile.systemComponents.majorVersion`

The major version of the system component.

- Required: Yes
- Type: int

### Parameter: `arcAgentProfile.systemComponents.type`

The type of the system component.

- Required: Yes
- Type: string

### Parameter: `arcAgentProfile.systemComponents.userSpecifiedVersion`

The user specified version of the system component.

- Required: Yes
- Type: string

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
| [`azureHybridBenefit`](#parameter-licenseprofileazurehybridbenefit) | string | Azure Hybrid Benefit configuration. |

### Parameter: `licenseProfile.azureHybridBenefit`

Azure Hybrid Benefit configuration.

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

### Parameter: `oidcIssuerProfile`

Open ID Connect (OIDC) Issuer Profile for the connected cluster.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-oidcissuerprofileenabled) | bool | Whether the OIDC issuer is enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`selfHostedIssuerUrl`](#parameter-oidcissuerprofileselfhostedissuerurl) | string | The URL of the self-hosted OIDC issuer. |

### Parameter: `oidcIssuerProfile.enabled`

Whether the OIDC issuer is enabled.

- Required: Yes
- Type: bool

### Parameter: `oidcIssuerProfile.selfHostedIssuerUrl`

The URL of the self-hosted OIDC issuer.

- Required: No
- Type: string

### Parameter: `securityProfile`

Security profile for the connected cluster.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      workloadIdentity: {
        enabled: false
      }
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workloadIdentity`](#parameter-securityprofileworkloadidentity) | object | The workload identity configuration. |

### Parameter: `securityProfile.workloadIdentity`

The workload identity configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-securityprofileworkloadidentityenabled) | bool | Whether workload identity is enabled. |

### Parameter: `securityProfile.workloadIdentity.enabled`

Whether workload identity is enabled.

- Required: Yes
- Type: bool

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nfsCsiDriver`](#parameter-storageprofilenfscsidriver) | object | NFS CSI driver configuration. |
| [`smbCsiDriver`](#parameter-storageprofilesmbcsidriver) | object | SMB CSI driver configuration. |

### Parameter: `storageProfile.nfsCsiDriver`

NFS CSI driver configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-storageprofilenfscsidriverenabled) | bool | Whether the NFS CSI driver is enabled. |

### Parameter: `storageProfile.nfsCsiDriver.enabled`

Whether the NFS CSI driver is enabled.

- Required: Yes
- Type: bool

### Parameter: `storageProfile.smbCsiDriver`

SMB CSI driver configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-storageprofilesmbcsidriverenabled) | bool | Whether the SMB CSI driver is enabled. |

### Parameter: `storageProfile.smbCsiDriver.enabled`

Whether the SMB CSI driver is enabled.

- Required: Yes
- Type: bool

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Aks Arc. |
| `resourceGroupName` | string | The resource group of the Aks Arc. |
| `resourceId` | string | The ID of the Aks Arc. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
