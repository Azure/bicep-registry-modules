# Azure Stack HCI Cluster `[Microsoft.AzureStackHCI/clusters]`

This module deploys an Azure Stack HCI Cluster on the provided Arc Machines.

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
| `Microsoft.AzureStackHCI/clusters` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/clusters) |
| `Microsoft.AzureStackHCI/clusters/deploymentSettings` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/clusters/deploymentSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/cluster:<version>`.

- [Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration](#example-1-deploy-azure-stack-hci-cluster-in-azure-with-a-2-node-switched-configuration)
- [Deploy Azure Stack HCI Cluster in Azure with a 3 node switchless configuration](#example-2-deploy-azure-stack-hci-cluster-in-azure-with-a-3-node-switchless-configuration)
- [Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration WAF aligned](#example-3-deploy-azure-stack-hci-cluster-in-azure-with-a-2-node-switched-configuration-waf-aligned)

### Example 1: _Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration_

This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/azure-stack-hci/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    clusterNodeNames: '<clusterNodeNames>'
    clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
    customLocationName: '<customLocationName>'
    defaultGateway: '<defaultGateway>'
    deploymentMode: 'Deploy'
    deploymentPrefix: '<deploymentPrefix>'
    dnsServers: '<dnsServers>'
    domainFqdn: '<domainFqdn>'
    domainOUPath: '<domainOUPath>'
    endingIPAddress: '<endingIPAddress>'
    keyVaultName: '<keyVaultName>'
    name: '<name>'
    networkIntents: '<networkIntents>'
    startingIPAddress: '<startingIPAddress>'
    storageConnectivitySwitchless: false
    storageNetworks: '<storageNetworks>'
    subnetMask: '<subnetMask>'
    // Non-required parameters
    enableStorageAutoIp: '<enableStorageAutoIp>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "clusterNodeNames": {
      "value": "<clusterNodeNames>"
    },
    "clusterWitnessStorageAccountName": {
      "value": "<clusterWitnessStorageAccountName>"
    },
    "customLocationName": {
      "value": "<customLocationName>"
    },
    "defaultGateway": {
      "value": "<defaultGateway>"
    },
    "deploymentMode": {
      "value": "Deploy"
    },
    "deploymentPrefix": {
      "value": "<deploymentPrefix>"
    },
    "dnsServers": {
      "value": "<dnsServers>"
    },
    "domainFqdn": {
      "value": "<domainFqdn>"
    },
    "domainOUPath": {
      "value": "<domainOUPath>"
    },
    "endingIPAddress": {
      "value": "<endingIPAddress>"
    },
    "keyVaultName": {
      "value": "<keyVaultName>"
    },
    "name": {
      "value": "<name>"
    },
    "networkIntents": {
      "value": "<networkIntents>"
    },
    "startingIPAddress": {
      "value": "<startingIPAddress>"
    },
    "storageConnectivitySwitchless": {
      "value": false
    },
    "storageNetworks": {
      "value": "<storageNetworks>"
    },
    "subnetMask": {
      "value": "<subnetMask>"
    },
    // Non-required parameters
    "enableStorageAutoIp": {
      "value": "<enableStorageAutoIp>"
    }
  }
}
```

</details>
<p>

### Example 2: _Deploy Azure Stack HCI Cluster in Azure with a 3 node switchless configuration_

This test deploys an Azure VM to host a 3 node switchless Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/azure-stack-hci/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    clusterNodeNames: [
      'hcinode1'
      'hcinode2'
      'hcinode3'
    ]
    clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
    customLocationName: '<customLocationName>'
    defaultGateway: '<defaultGateway>'
    deploymentMode: 'Deploy'
    deploymentPrefix: '<deploymentPrefix>'
    dnsServers: '<dnsServers>'
    domainFqdn: '<domainFqdn>'
    domainOUPath: '<domainOUPath>'
    endingIPAddress: '<endingIPAddress>'
    keyVaultName: '<keyVaultName>'
    name: '<name>'
    networkIntents: '<networkIntents>'
    startingIPAddress: '<startingIPAddress>'
    storageConnectivitySwitchless: true
    storageNetworks: '<storageNetworks>'
    subnetMask: '<subnetMask>'
    // Non-required parameters
    enableStorageAutoIp: '<enableStorageAutoIp>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "clusterNodeNames": {
      "value": [
        "hcinode1",
        "hcinode2",
        "hcinode3"
      ]
    },
    "clusterWitnessStorageAccountName": {
      "value": "<clusterWitnessStorageAccountName>"
    },
    "customLocationName": {
      "value": "<customLocationName>"
    },
    "defaultGateway": {
      "value": "<defaultGateway>"
    },
    "deploymentMode": {
      "value": "Deploy"
    },
    "deploymentPrefix": {
      "value": "<deploymentPrefix>"
    },
    "dnsServers": {
      "value": "<dnsServers>"
    },
    "domainFqdn": {
      "value": "<domainFqdn>"
    },
    "domainOUPath": {
      "value": "<domainOUPath>"
    },
    "endingIPAddress": {
      "value": "<endingIPAddress>"
    },
    "keyVaultName": {
      "value": "<keyVaultName>"
    },
    "name": {
      "value": "<name>"
    },
    "networkIntents": {
      "value": "<networkIntents>"
    },
    "startingIPAddress": {
      "value": "<startingIPAddress>"
    },
    "storageConnectivitySwitchless": {
      "value": true
    },
    "storageNetworks": {
      "value": "<storageNetworks>"
    },
    "subnetMask": {
      "value": "<subnetMask>"
    },
    // Non-required parameters
    "enableStorageAutoIp": {
      "value": "<enableStorageAutoIp>"
    }
  }
}
```

</details>
<p>

### Example 3: _Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration WAF aligned_

This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster. WAF aligned.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/azure-stack-hci/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    clusterNodeNames: '<clusterNodeNames>'
    clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
    customLocationName: '<customLocationName>'
    defaultGateway: '<defaultGateway>'
    deploymentMode: 'Deploy'
    deploymentPrefix: '<deploymentPrefix>'
    dnsServers: '<dnsServers>'
    domainFqdn: '<domainFqdn>'
    domainOUPath: '<domainOUPath>'
    endingIPAddress: '<endingIPAddress>'
    keyVaultName: '<keyVaultName>'
    name: '<name>'
    networkIntents: '<networkIntents>'
    startingIPAddress: '<startingIPAddress>'
    storageConnectivitySwitchless: false
    storageNetworks: '<storageNetworks>'
    subnetMask: '<subnetMask>'
    // Non-required parameters
    enableStorageAutoIp: '<enableStorageAutoIp>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "clusterNodeNames": {
      "value": "<clusterNodeNames>"
    },
    "clusterWitnessStorageAccountName": {
      "value": "<clusterWitnessStorageAccountName>"
    },
    "customLocationName": {
      "value": "<customLocationName>"
    },
    "defaultGateway": {
      "value": "<defaultGateway>"
    },
    "deploymentMode": {
      "value": "Deploy"
    },
    "deploymentPrefix": {
      "value": "<deploymentPrefix>"
    },
    "dnsServers": {
      "value": "<dnsServers>"
    },
    "domainFqdn": {
      "value": "<domainFqdn>"
    },
    "domainOUPath": {
      "value": "<domainOUPath>"
    },
    "endingIPAddress": {
      "value": "<endingIPAddress>"
    },
    "keyVaultName": {
      "value": "<keyVaultName>"
    },
    "name": {
      "value": "<name>"
    },
    "networkIntents": {
      "value": "<networkIntents>"
    },
    "startingIPAddress": {
      "value": "<startingIPAddress>"
    },
    "storageConnectivitySwitchless": {
      "value": false
    },
    "storageNetworks": {
      "value": "<storageNetworks>"
    },
    "subnetMask": {
      "value": "<subnetMask>"
    },
    // Non-required parameters
    "enableStorageAutoIp": {
      "value": "<enableStorageAutoIp>"
    }
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterNodeNames`](#parameter-clusternodenames) | array | Names of the cluster node Arc Machine resources. These are the name of the Arc Machine resources created when the new HCI nodes were Arc initialized. Example: [hci-node-1, hci-node-2]. |
| [`clusterWitnessStorageAccountName`](#parameter-clusterwitnessstorageaccountname) | string | The name of the storage account to be used as the witness for the HCI Windows Failover Cluster. |
| [`customLocationName`](#parameter-customlocationname) | string | The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01. |
| [`defaultGateway`](#parameter-defaultgateway) | string | The default gateway of the Management Network. Exameple: 192.168.0.1. |
| [`deploymentMode`](#parameter-deploymentmode) | string | First must pass with this parameter set to Validate prior running with it set to Deploy. If either Validation or Deployment phases fail, fix the issue, then resubmit the template with the same deploymentMode to retry. |
| [`deploymentPrefix`](#parameter-deploymentprefix) | string | The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$. |
| [`dnsServers`](#parameter-dnsservers) | array | The DNS servers accessible from the Management Network for the HCI cluster. |
| [`domainFqdn`](#parameter-domainfqdn) | string | The domain name of the Active Directory Domain Services. Example: "contoso.com". |
| [`domainOUPath`](#parameter-domainoupath) | string | The ADDS OU path - ex "OU=HCI,DC=contoso,DC=com". |
| [`enableStorageAutoIp`](#parameter-enablestorageautoip) | bool | Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false. |
| [`endingIPAddress`](#parameter-endingipaddress) | string | The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs. |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the key vault to be used for storing secrets for the HCI cluster. This currently needs to be unique per HCI cluster. |
| [`name`](#parameter-name) | string | The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure. |
| [`networkIntents`](#parameter-networkintents) | array | An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster. |
| [`startingIPAddress`](#parameter-startingipaddress) | string | The starting IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs. |
| [`storageConnectivitySwitchless`](#parameter-storageconnectivityswitchless) | bool | Specify whether the Storage Network connectivity is switched or switchless. |
| [`storageNetworks`](#parameter-storagenetworks) | array | An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations. |
| [`subnetMask`](#parameter-subnetmask) | string | The subnet mask pf the Management Network for the HCI cluster - ex: 255.255.252.0. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`episodicDataUpload`](#parameter-episodicdataupload) | bool | The diagnostic data for deploying a HCI cluster. |
| [`isEuropeanUnionLocation`](#parameter-iseuropeanunionlocation) | bool | The location data for deploying a HCI cluster. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityConfiguration`](#parameter-securityconfiguration) | object | Security configuration settings object; defaults to most secure posture. |
| [`storageConfigurationMode`](#parameter-storageconfigurationmode) | string | The storage volume configuration mode. See documentation for details. |
| [`streamingDataClient`](#parameter-streamingdataclient) | bool | The metrics data for deploying a HCI cluster. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `clusterNodeNames`

Names of the cluster node Arc Machine resources. These are the name of the Arc Machine resources created when the new HCI nodes were Arc initialized. Example: [hci-node-1, hci-node-2].

- Required: Yes
- Type: array

### Parameter: `clusterWitnessStorageAccountName`

The name of the storage account to be used as the witness for the HCI Windows Failover Cluster.

- Required: Yes
- Type: string

### Parameter: `customLocationName`

The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01.

- Required: Yes
- Type: string

### Parameter: `defaultGateway`

The default gateway of the Management Network. Exameple: 192.168.0.1.

- Required: Yes
- Type: string

### Parameter: `deploymentMode`

First must pass with this parameter set to Validate prior running with it set to Deploy. If either Validation or Deployment phases fail, fix the issue, then resubmit the template with the same deploymentMode to retry.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Deploy'
    'Validate'
  ]
  ```

### Parameter: `deploymentPrefix`

The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$.

- Required: Yes
- Type: string

### Parameter: `dnsServers`

The DNS servers accessible from the Management Network for the HCI cluster.

- Required: Yes
- Type: array

### Parameter: `domainFqdn`

The domain name of the Active Directory Domain Services. Example: "contoso.com".

- Required: Yes
- Type: string

### Parameter: `domainOUPath`

The ADDS OU path - ex "OU=HCI,DC=contoso,DC=com".

- Required: Yes
- Type: string

### Parameter: `enableStorageAutoIp`

Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `endingIPAddress`

The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.

- Required: Yes
- Type: string

### Parameter: `keyVaultName`

The name of the key vault to be used for storing secrets for the HCI cluster. This currently needs to be unique per HCI cluster.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure.

- Required: Yes
- Type: string

### Parameter: `networkIntents`

An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adapter`](#parameter-networkintentsadapter) | array | The names of the network adapters to include in the intent. |
| [`adapterPropertyOverrides`](#parameter-networkintentsadapterpropertyoverrides) | object | The adapter property overrides for the network intent. |
| [`name`](#parameter-networkintentsname) | string | The name of the network intent. |
| [`overrideAdapterProperty`](#parameter-networkintentsoverrideadapterproperty) | bool | Specify whether to override the adapter property. Use false by default. |
| [`overrideQosPolicy`](#parameter-networkintentsoverrideqospolicy) | bool | Specify whether to override the qosPolicy property. Use false by default. |
| [`overrideVirtualSwitchConfiguration`](#parameter-networkintentsoverridevirtualswitchconfiguration) | bool | Specify whether to override the virtualSwitchConfiguration property. Use false by default. |
| [`qosPolicyOverrides`](#parameter-networkintentsqospolicyoverrides) | object | The qosPolicy overrides for the network intent. |
| [`trafficType`](#parameter-networkintentstraffictype) | array | The traffic types for the network intent. Allowed values: "Compute", "Management", "Storage". |
| [`virtualSwitchConfigurationOverrides`](#parameter-networkintentsvirtualswitchconfigurationoverrides) | object | The virtualSwitchConfiguration overrides for the network intent. |

### Parameter: `networkIntents.adapter`

The names of the network adapters to include in the intent.

- Required: Yes
- Type: array

### Parameter: `networkIntents.adapterPropertyOverrides`

The adapter property overrides for the network intent.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`jumboPacket`](#parameter-networkintentsadapterpropertyoverridesjumbopacket) | string | The jumboPacket configuration for the network adapters. |
| [`networkDirect`](#parameter-networkintentsadapterpropertyoverridesnetworkdirect) | string | The networkDirect configuration for the network adapters. Allowed values: "Enabled", "Disabled". |
| [`networkDirectTechnology`](#parameter-networkintentsadapterpropertyoverridesnetworkdirecttechnology) | string | The networkDirectTechnology configuration for the network adapters. Allowed values: "RoCEv2", "iWARP". |

### Parameter: `networkIntents.adapterPropertyOverrides.jumboPacket`

The jumboPacket configuration for the network adapters.

- Required: Yes
- Type: string

### Parameter: `networkIntents.adapterPropertyOverrides.networkDirect`

The networkDirect configuration for the network adapters. Allowed values: "Enabled", "Disabled".

- Required: Yes
- Type: string

### Parameter: `networkIntents.adapterPropertyOverrides.networkDirectTechnology`

The networkDirectTechnology configuration for the network adapters. Allowed values: "RoCEv2", "iWARP".

- Required: Yes
- Type: string

### Parameter: `networkIntents.name`

The name of the network intent.

- Required: Yes
- Type: string

### Parameter: `networkIntents.overrideAdapterProperty`

Specify whether to override the adapter property. Use false by default.

- Required: Yes
- Type: bool

### Parameter: `networkIntents.overrideQosPolicy`

Specify whether to override the qosPolicy property. Use false by default.

- Required: Yes
- Type: bool

### Parameter: `networkIntents.overrideVirtualSwitchConfiguration`

Specify whether to override the virtualSwitchConfiguration property. Use false by default.

- Required: Yes
- Type: bool

### Parameter: `networkIntents.qosPolicyOverrides`

The qosPolicy overrides for the network intent.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bandwidthPercentage_SMB`](#parameter-networkintentsqospolicyoverridesbandwidthpercentage_smb) | string | The bandwidthPercentage for the network intent. Recommend 50. |
| [`priorityValue8021Action_Cluster`](#parameter-networkintentsqospolicyoverridespriorityvalue8021action_cluster) | string | Recommend 7. |
| [`priorityValue8021Action_SMB`](#parameter-networkintentsqospolicyoverridespriorityvalue8021action_smb) | string | Recommend 3. |

### Parameter: `networkIntents.qosPolicyOverrides.bandwidthPercentage_SMB`

The bandwidthPercentage for the network intent. Recommend 50.

- Required: Yes
- Type: string

### Parameter: `networkIntents.qosPolicyOverrides.priorityValue8021Action_Cluster`

Recommend 7.

- Required: Yes
- Type: string

### Parameter: `networkIntents.qosPolicyOverrides.priorityValue8021Action_SMB`

Recommend 3.

- Required: Yes
- Type: string

### Parameter: `networkIntents.trafficType`

The traffic types for the network intent. Allowed values: "Compute", "Management", "Storage".

- Required: Yes
- Type: array

### Parameter: `networkIntents.virtualSwitchConfigurationOverrides`

The virtualSwitchConfiguration overrides for the network intent.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableIov`](#parameter-networkintentsvirtualswitchconfigurationoverridesenableiov) | string | The enableIov configuration for the network intent. Allowed values: "True", "False". |
| [`loadBalancingAlgorithm`](#parameter-networkintentsvirtualswitchconfigurationoverridesloadbalancingalgorithm) | string | The loadBalancingAlgorithm configuration for the network intent. Allowed values: "Dynamic", "HyperVPort", "IPHash". |

### Parameter: `networkIntents.virtualSwitchConfigurationOverrides.enableIov`

The enableIov configuration for the network intent. Allowed values: "True", "False".

- Required: Yes
- Type: string

### Parameter: `networkIntents.virtualSwitchConfigurationOverrides.loadBalancingAlgorithm`

The loadBalancingAlgorithm configuration for the network intent. Allowed values: "Dynamic", "HyperVPort", "IPHash".

- Required: Yes
- Type: string

### Parameter: `startingIPAddress`

The starting IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.

- Required: Yes
- Type: string

### Parameter: `storageConnectivitySwitchless`

Specify whether the Storage Network connectivity is switched or switchless.

- Required: Yes
- Type: bool

### Parameter: `storageNetworks`

An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations.

- Required: Yes
- Type: array

### Parameter: `subnetMask`

The subnet mask pf the Management Network for the HCI cluster - ex: 255.255.252.0.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `episodicDataUpload`

The diagnostic data for deploying a HCI cluster.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `isEuropeanUnionLocation`

The location data for deploying a HCI cluster.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
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

### Parameter: `securityConfiguration`

Security configuration settings object; defaults to most secure posture.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      bitlockerBootVolume: true
      bitlockerDataVolumes: true
      credentialGuardEnforced: true
      driftControlEnforced: true
      drtmProtection: true
      hvciProtection: true
      sideChannelMitigationEnforced: true
      smbClusterEncryption: true
      smbSigningEnforced: true
      wdacEnforced: true
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bitlockerBootVolume`](#parameter-securityconfigurationbitlockerbootvolume) | bool | Enable/Disable BitLocker protection for boot volume. |
| [`bitlockerDataVolumes`](#parameter-securityconfigurationbitlockerdatavolumes) | bool | Enable/Disable BitLocker protection for data volumes. |
| [`credentialGuardEnforced`](#parameter-securityconfigurationcredentialguardenforced) | bool | Enable/Disable Credential Guard enforcement. |
| [`driftControlEnforced`](#parameter-securityconfigurationdriftcontrolenforced) | bool | Enable/Disable Drift Control enforcement. |
| [`drtmProtection`](#parameter-securityconfigurationdrtmprotection) | bool | Enable/Disable DRTM protection. |
| [`hvciProtection`](#parameter-securityconfigurationhvciprotection) | bool | Enable/Disable HVCI protection. |
| [`sideChannelMitigationEnforced`](#parameter-securityconfigurationsidechannelmitigationenforced) | bool | Enable/Disable Side Channel Mitigation enforcement. |
| [`smbClusterEncryption`](#parameter-securityconfigurationsmbclusterencryption) | bool | Enable/Disable SMB cluster encryption. |
| [`smbSigningEnforced`](#parameter-securityconfigurationsmbsigningenforced) | bool | Enable/Disable SMB signing enforcement. |
| [`wdacEnforced`](#parameter-securityconfigurationwdacenforced) | bool | Enable/Disable WDAC enforcement. |

### Parameter: `securityConfiguration.bitlockerBootVolume`

Enable/Disable BitLocker protection for boot volume.

- Required: Yes
- Type: bool

### Parameter: `securityConfiguration.bitlockerDataVolumes`

Enable/Disable BitLocker protection for data volumes.

- Required: Yes
- Type: bool

### Parameter: `securityConfiguration.credentialGuardEnforced`

Enable/Disable Credential Guard enforcement.

- Required: Yes
- Type: bool

### Parameter: `securityConfiguration.driftControlEnforced`

Enable/Disable Drift Control enforcement.

- Required: Yes
- Type: bool

### Parameter: `securityConfiguration.drtmProtection`

Enable/Disable DRTM protection.

- Required: Yes
- Type: bool

### Parameter: `securityConfiguration.hvciProtection`

Enable/Disable HVCI protection.

- Required: Yes
- Type: bool

### Parameter: `securityConfiguration.sideChannelMitigationEnforced`

Enable/Disable Side Channel Mitigation enforcement.

- Required: Yes
- Type: bool

### Parameter: `securityConfiguration.smbClusterEncryption`

Enable/Disable SMB cluster encryption.

- Required: Yes
- Type: bool

### Parameter: `securityConfiguration.smbSigningEnforced`

Enable/Disable SMB signing enforcement.

- Required: Yes
- Type: bool

### Parameter: `securityConfiguration.wdacEnforced`

Enable/Disable WDAC enforcement.

- Required: Yes
- Type: bool

### Parameter: `storageConfigurationMode`

The storage volume configuration mode. See documentation for details.

- Required: No
- Type: string
- Default: `'Express'`
- Allowed:
  ```Bicep
  [
    'Express'
    'InfraOnly'
    'KeepStorage'
  ]
  ```

### Parameter: `streamingDataClient`

The metrics data for deploying a HCI cluster.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the cluster. |
| `name` | string | The name of the cluster. |
| `resourceGroupName` | string | The resource group of the cluster. |
| `resourceId` | string | The ID of the cluster. |
| `systemAssignedMIPrincipalId` | string | The managed identity of the cluster. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
