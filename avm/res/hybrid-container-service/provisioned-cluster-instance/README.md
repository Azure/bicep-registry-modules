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
    customLocationId: '<customLocationId>'
    logicalNetworkId: '<logicalNetworkId>'
    name: 'hcspcimin001'
    // Non-required parameters
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
    "customLocationId": {
      "value": "<customLocationId>"
    },
    "logicalNetworkId": {
      "value": "<logicalNetworkId>"
    },
    "name": {
      "value": "hcspcimin001"
    },
    // Non-required parameters
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
using 'br/public:avm/res/hybrid-container-service/provisioned-cluster-instance:<version>'

// Required parameters
param customLocationId = '<customLocationId>'
param logicalNetworkId = '<logicalNetworkId>'
param name = 'hcspcimin001'
// Non-required parameters
param location = '<location>'
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
    customLocationId: '<customLocationId>'
    logicalNetworkId: '<logicalNetworkId>'
    name: 'hcspciwaf001'
    // Non-required parameters
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
    "customLocationId": {
      "value": "<customLocationId>"
    },
    "logicalNetworkId": {
      "value": "<logicalNetworkId>"
    },
    "name": {
      "value": "hcspciwaf001"
    },
    // Non-required parameters
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
using 'br/public:avm/res/hybrid-container-service/provisioned-cluster-instance:<version>'

// Required parameters
param customLocationId = '<customLocationId>'
param logicalNetworkId = '<logicalNetworkId>'
param name = 'hcspciwaf001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customLocationId`](#parameter-customlocationid) | string | The id of the Custom location that used to create hybrid aks. |
| [`logicalNetworkId`](#parameter-logicalnetworkid) | string | The id of the logical network that the AKS nodes will be connected to. |
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
| [`aadTenantId`](#parameter-aadtenantid) | string | The Azure AD tenant ID. |
| [`agentAutoUpgrade`](#parameter-agentautoupgrade) | string | Enable automatic agent upgrades. |
| [`agentPoolProfiles`](#parameter-agentpoolprofiles) | array | Agent pool configuration. |
| [`azureHybridBenefit`](#parameter-azurehybridbenefit) | string | Azure Hybrid Benefit configuration. |
| [`connectClustersTags`](#parameter-connectclusterstags) | object | Tags for the cluster resource. |
| [`controlPlaneCount`](#parameter-controlplanecount) | int | The number of control plane nodes. |
| [`controlPlaneIP`](#parameter-controlplaneip) | string | The host IP for control plane endpoint. |
| [`controlPlaneVmSize`](#parameter-controlplanevmsize) | string | The VM size for control plane nodes. |
| [`enableAzureRBAC`](#parameter-enableazurerbac) | bool | Enable Azure RBAC. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`identityType`](#parameter-identitytype) | string | The identity type for the cluster. Allowed values: "SystemAssigned", "None" |
| [`kubernetesVersion`](#parameter-kubernetesversion) | string | The Kubernetes version for the cluster. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`nfsCsiDriverEnabled`](#parameter-nfscsidriverenabled) | bool | Enable or disable NFS CSI driver. |
| [`oidcIssuerEnabled`](#parameter-oidcissuerenabled) | bool | Enable OIDC issuer. |
| [`podCidr`](#parameter-podcidr) | string | The CIDR range for the pods in the kubernetes cluster. |
| [`smbCsiDriverEnabled`](#parameter-smbcsidriverenabled) | bool | Enable or disable SMB CSI driver. |
| [`sshPrivateKeyPemSecretName`](#parameter-sshprivatekeypemsecretname) | string | The name of the secret in the key vault that contains the SSH private key PEM. |
| [`sshPublicKeySecretName`](#parameter-sshpublickeysecretname) | string | The name of the secret in the key vault that contains the SSH public key. |
| [`workloadIdentityEnabled`](#parameter-workloadidentityenabled) | bool | Enable workload identity. |

### Parameter: `customLocationId`

The id of the Custom location that used to create hybrid aks.

- Required: Yes
- Type: string

### Parameter: `logicalNetworkId`

The id of the logical network that the AKS nodes will be connected to.

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
- Default: `''`

### Parameter: `sshPublicKey`

The SSH public key that will be used to access the kubernetes cluster nodes. If not specified, a new SSH key pair will be generated. Required if no existing SSH keys.

- Required: No
- Type: string
- Default: `''`

### Parameter: `aadAdminGroupObjectIds`

The Azure AD admin group object IDs.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `aadTenantId`

The Azure AD tenant ID.

- Required: No
- Type: string
- Default: `''`

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

Agent pool configuration.

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

### Parameter: `azureHybridBenefit`

Azure Hybrid Benefit configuration.

- Required: No
- Type: string
- Default: `''`

### Parameter: `connectClustersTags`

Tags for the cluster resource.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `controlPlaneCount`

The number of control plane nodes.

- Required: No
- Type: int
- Default: `1`

### Parameter: `controlPlaneIP`

The host IP for control plane endpoint.

- Required: No
- Type: string
- Default: `''`

### Parameter: `controlPlaneVmSize`

The VM size for control plane nodes.

- Required: No
- Type: string
- Default: `'Standard_A4_v2'`

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

### Parameter: `identityType`

The identity type for the cluster. Allowed values: "SystemAssigned", "None"

- Required: No
- Type: string
- Default: `'SystemAssigned'`
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
  ]
  ```

### Parameter: `kubernetesVersion`

The Kubernetes version for the cluster.

- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `nfsCsiDriverEnabled`

Enable or disable NFS CSI driver.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `oidcIssuerEnabled`

Enable OIDC issuer.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `podCidr`

The CIDR range for the pods in the kubernetes cluster.

- Required: No
- Type: string
- Default: `'10.244.0.0/16'`

### Parameter: `smbCsiDriverEnabled`

Enable or disable SMB CSI driver.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `workloadIdentityEnabled`

Enable workload identity.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `provisionedClusterId` | string | The id of the Aks Arc. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `avm/res/kubernetes/connected-clusters` | Local reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
