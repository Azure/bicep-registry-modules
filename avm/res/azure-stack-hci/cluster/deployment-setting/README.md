# Azure Stack HCI Cluster Deployment Settings `[Microsoft.AzureStackHCI/clusters/deploymentSettings]`

This module deploys an Azure Stack HCI Cluster Deployment Settings resource.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.AzureStackHCI/clusters/deploymentSettings` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/clusters/deploymentSettings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterNodeNames`](#parameter-clusternodenames) | array | Names of the cluster node Arc Machine resources. These are the name of the Arc Machine resources created when the new HCI nodes were Arc initialized. Example: [hci-node-1, hci-node-2]. |
| [`clusterWitnessStorageAccountName`](#parameter-clusterwitnessstorageaccountname) | string | The name of the storage account to be used as the witness for the HCI Windows Failover Cluster. |
| [`customLocationName`](#parameter-customlocationname) | string | The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01. |
| [`defaultGateway`](#parameter-defaultgateway) | string | The default gateway of the Management Network. Example: 192.168.0.1. |
| [`deploymentMode`](#parameter-deploymentmode) | string | First must pass with this parameter set to Validate prior running with it set to Deploy. If either Validation or Deployment phases fail, fix the issue, then resubmit the template with the same deploymentMode to retry. |
| [`deploymentPrefix`](#parameter-deploymentprefix) | string | The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$. |
| [`dnsServers`](#parameter-dnsservers) | array | The DNS servers accessible from the Management Network for the HCI cluster. |
| [`domainFqdn`](#parameter-domainfqdn) | string | The domain name of the Active Directory Domain Services. Example: "contoso.com". |
| [`domainOUPath`](#parameter-domainoupath) | string | The ADDS OU path - ex "OU=HCI,DC=contoso,DC=com". |
| [`endingIPAddress`](#parameter-endingipaddress) | string | The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs. |
| [`hciResourceProviderObjectId`](#parameter-hciresourceproviderobjectid) | securestring | The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the 'Microsoft.AzureStackHCI' provider was registered in the subscription. |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the key vault to be used for storing secrets for the HCI cluster. |
| [`needArbSecret`](#parameter-needarbsecret) | bool | If true, the service principal secret for ARB is required. If false, the secrets wiil not be required. |
| [`networkIntents`](#parameter-networkintents) | array | An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster. |
| [`startingIPAddress`](#parameter-startingipaddress) | string | The starting IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs. |
| [`storageConnectivitySwitchless`](#parameter-storageconnectivityswitchless) | bool | Specify whether the Storage Network connectivity is switched or switchless. |
| [`storageNetworks`](#parameter-storagenetworks) | array | An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations. |
| [`subnetMask`](#parameter-subnetmask) | string | The subnet mask pf the Management Network for the HCI cluster - ex: 255.255.252.0. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterName`](#parameter-clustername) | string | The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bitlockerBootVolume`](#parameter-bitlockerbootvolume) | bool | When set to true, BitLocker XTS_AES 256-bit encryption is enabled for all data-at-rest on the OS volume of your Azure Stack HCI cluster. This setting is TPM-hardware dependent. |
| [`bitlockerDataVolumes`](#parameter-bitlockerdatavolumes) | bool | When set to true, BitLocker XTS-AES 256-bit encryption is enabled for all data-at-rest on your Azure Stack HCI cluster shared volumes. |
| [`cloudId`](#parameter-cloudid) | string | If using a shared key vault or non-legacy secret naming, pass the properties.cloudId guid from the pre-created HCI cluster resource. |
| [`credentialGuardEnforced`](#parameter-credentialguardenforced) | bool | Enables the Credential Guard. |
| [`driftControlEnforced`](#parameter-driftcontrolenforced) | bool | When set to true, the security baseline is re-applied regularly. |
| [`drtmProtection`](#parameter-drtmprotection) | bool | The hardware-dependent Secure Boot setting. |
| [`enableStorageAutoIp`](#parameter-enablestorageautoip) | bool | Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false. |
| [`episodicDataUpload`](#parameter-episodicdataupload) | bool | The diagnostic data for deploying a HCI cluster. |
| [`hvciProtection`](#parameter-hvciprotection) | bool | The Hypervisor-protected Code Integrity setting. |
| [`isEuropeanUnionLocation`](#parameter-iseuropeanunionlocation) | bool | The location data for deploying a HCI cluster. |
| [`name`](#parameter-name) | string | The name of the deployment settings. |
| [`sideChannelMitigationEnforced`](#parameter-sidechannelmitigationenforced) | bool | When set to true, all the side channel mitigations are enabled. |
| [`smbClusterEncryption`](#parameter-smbclusterencryption) | bool | When set to true, cluster east-west traffic is encrypted. |
| [`smbSigningEnforced`](#parameter-smbsigningenforced) | bool | When set to true, the SMB default instance requires sign in for the client and server services. |
| [`storageConfigurationMode`](#parameter-storageconfigurationmode) | string | The storage volume configuration mode. See documentation for details. |
| [`streamingDataClient`](#parameter-streamingdataclient) | bool | The metrics data for deploying a HCI cluster. |
| [`wdacEnforced`](#parameter-wdacenforced) | bool | Limits the applications and the code that you can run on your Azure Stack HCI cluster. |

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

The default gateway of the Management Network. Example: 192.168.0.1.

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

### Parameter: `endingIPAddress`

The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.

- Required: Yes
- Type: string

### Parameter: `hciResourceProviderObjectId`

The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the 'Microsoft.AzureStackHCI' provider was registered in the subscription.

- Required: Yes
- Type: securestring

### Parameter: `keyVaultName`

The name of the key vault to be used for storing secrets for the HCI cluster.

- Required: Yes
- Type: string

### Parameter: `needArbSecret`

If true, the service principal secret for ARB is required. If false, the secrets wiil not be required.

- Required: Yes
- Type: bool

### Parameter: `networkIntents`

An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster.

- Required: Yes
- Type: array

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

### Parameter: `clusterName`

The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `bitlockerBootVolume`

When set to true, BitLocker XTS_AES 256-bit encryption is enabled for all data-at-rest on the OS volume of your Azure Stack HCI cluster. This setting is TPM-hardware dependent.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `bitlockerDataVolumes`

When set to true, BitLocker XTS-AES 256-bit encryption is enabled for all data-at-rest on your Azure Stack HCI cluster shared volumes.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `cloudId`

If using a shared key vault or non-legacy secret naming, pass the properties.cloudId guid from the pre-created HCI cluster resource.

- Required: No
- Type: string

### Parameter: `credentialGuardEnforced`

Enables the Credential Guard.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `driftControlEnforced`

When set to true, the security baseline is re-applied regularly.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `drtmProtection`

The hardware-dependent Secure Boot setting.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableStorageAutoIp`

Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `episodicDataUpload`

The diagnostic data for deploying a HCI cluster.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hvciProtection`

The Hypervisor-protected Code Integrity setting.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `isEuropeanUnionLocation`

The location data for deploying a HCI cluster.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `name`

The name of the deployment settings.

- Required: No
- Type: string
- Default: `'default'`
- Allowed:
  ```Bicep
  [
    'default'
  ]
  ```

### Parameter: `sideChannelMitigationEnforced`

When set to true, all the side channel mitigations are enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `smbClusterEncryption`

When set to true, cluster east-west traffic is encrypted.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `smbSigningEnforced`

When set to true, the SMB default instance requires sign in for the client and server services.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `wdacEnforced`

Limits the applications and the code that you can run on your Azure Stack HCI cluster.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the cluster deployment settings. |
| `resourceGroupName` | string | The resource group of the cluster deployment settings. |
| `resourceId` | string | The ID of the cluster deployment settings. |
