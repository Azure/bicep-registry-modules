@description('Optional. The cluster deployment operations to execute. Defaults to "[Validate, Deploy]".')
@allowed([
  'Deploy'
  'Validate'
])
param deploymentOperations string[] = ['Validate', 'Deploy']

@description('Required. The deployment settings of the cluster.')
param deploymentSettings deploymentSettingsType

@description('Optional. Specify whether to use the shared key vault for the HCI cluster.')
param useSharedKeyVault bool = true

@description('Required. The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the \'Microsoft.AzureStackHCI\' provider was registered in the subscription.')
@secure()
param hciResourceProviderObjectId string

param clusterName string
param cloudId string

param needArbSecret bool

// if deployment operations requested, validation must be performed first so we reverse sort the array
var sortedDeploymentOperations = (!empty(deploymentOperations)) ? sort(deploymentOperations, (a, b) => a > b) : []

@batchSize(1)
module deploymentSetting '../deployment-setting/main.bicep' = [
  for deploymentOperation in sortedDeploymentOperations: if (!empty(deploymentOperation) && !empty(deploymentSettings)) {
    name: 'deploymentSettings-${deploymentOperation}'
    params: {
      cloudId: useSharedKeyVault ? cloudId : null
      clusterName: clusterName
      deploymentMode: deploymentOperation
      clusterNodeNames: deploymentSettings!.clusterNodeNames
      clusterWitnessStorageAccountName: deploymentSettings!.clusterWitnessStorageAccountName
      customLocationName: deploymentSettings!.customLocationName
      defaultGateway: deploymentSettings!.defaultGateway
      deploymentPrefix: deploymentSettings!.deploymentPrefix
      dnsServers: deploymentSettings!.dnsServers
      domainFqdn: deploymentSettings!.domainFqdn
      domainOUPath: deploymentSettings!.domainOUPath
      endingIPAddress: deploymentSettings!.endingIPAddress
      keyVaultName: deploymentSettings!.keyVaultName
      networkIntents: [
        for intent in deploymentSettings.networkIntents: {
          ...intent
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: intent.qosPolicyOverrides.bandwidthPercentageSMB
            priorityValue8021Action_Cluster: intent.qosPolicyOverrides.priorityValue8021ActionCluster
            priorityValue8021Action_SMB: intent.qosPolicyOverrides.priorityValue8021ActionSMB
          }
        }
      ]
      startingIPAddress: deploymentSettings!.startingIPAddress
      storageConnectivitySwitchless: deploymentSettings!.storageConnectivitySwitchless
      storageNetworks: deploymentSettings!.storageNetworks
      subnetMask: deploymentSettings!.subnetMask
      bitlockerBootVolume: deploymentSettings!.?bitlockerBootVolume
      bitlockerDataVolumes: deploymentSettings!.?bitlockerDataVolumes
      credentialGuardEnforced: deploymentSettings!.?credentialGuardEnforced
      driftControlEnforced: deploymentSettings!.?driftControlEnforced
      drtmProtection: deploymentSettings!.?drtmProtection
      enableStorageAutoIp: deploymentSettings!.?enableStorageAutoIp
      episodicDataUpload: deploymentSettings!.?episodicDataUpload
      hvciProtection: deploymentSettings!.?hvciProtection
      isEuropeanUnionLocation: deploymentSettings!.?isEuropeanUnionLocation
      sideChannelMitigationEnforced: deploymentSettings!.?sideChannelMitigationEnforced
      smbClusterEncryption: deploymentSettings!.?smbClusterEncryption
      smbSigningEnforced: deploymentSettings!.?smbSigningEnforced
      storageConfigurationMode: deploymentSettings!.?storageConfigurationMode
      streamingDataClient: deploymentSettings!.?streamingDataClient
      wdacEnforced: deploymentSettings!.?wdacEnforced
      hciResourceProviderObjectId: hciResourceProviderObjectId
      needArbSecret: needArbSecret
    }
  }
]

import { networkIntentType, storageNetworksType } from 'br/public:avm/res/azure-stack-hci/cluster:0.1.6'
type deploymentSettingsType = {
  @minLength(4)
  @maxLength(8)
  @description('Required. The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$.')
  deploymentPrefix: string

  @description('Required. Names of the cluster node Arc Machine resources. These are the name of the Arc Machine resources created when the new HCI nodes were Arc initialized. Example: [hci-node-1, hci-node-2].')
  clusterNodeNames: array

  @description('Required. The domain name of the Active Directory Domain Services. Example: "contoso.com".')
  domainFqdn: string

  @description('Required. The ADDS OU path - ex "OU=HCI,DC=contoso,DC=com".')
  domainOUPath: string

  @description('Optional. The Hypervisor-protected Code Integrity setting.')
  hvciProtection: bool?

  @description('Optional. The hardware-dependent Secure Boot setting.')
  drtmProtection: bool?

  @description('Optional. When set to true, the security baseline is re-applied regularly.')
  driftControlEnforced: bool?

  @description('Optional. Enables the Credential Guard.')
  credentialGuardEnforced: bool?

  @description('Optional. When set to true, the SMB default instance requires sign in for the client and server services.')
  smbSigningEnforced: bool?

  @description('Optional. When set to true, cluster east-west traffic is encrypted.')
  smbClusterEncryption: bool?

  @description('Optional. When set to true, all the side channel mitigations are enabled.')
  sideChannelMitigationEnforced: bool?

  @description('Optional. When set to true, BitLocker XTS_AES 256-bit encryption is enabled for all data-at-rest on the OS volume of your Azure Stack HCI cluster. This setting is TPM-hardware dependent.')
  bitlockerBootVolume: bool?

  @description('Optional. When set to true, BitLocker XTS-AES 256-bit encryption is enabled for all data-at-rest on your Azure Stack HCI cluster shared volumes.')
  bitlockerDataVolumes: bool?

  @description('Optional. Limits the applications and the code that you can run on your Azure Stack HCI cluster.')
  wdacEnforced: bool?

  // cluster diagnostics and telemetry configuration
  @description('Optional. The metrics data for deploying a HCI cluster.')
  streamingDataClient: bool?

  @description('Optional. The location data for deploying a HCI cluster.')
  isEuropeanUnionLocation: bool?

  @description('Optional. The diagnostic data for deploying a HCI cluster.')
  episodicDataUpload: bool?

  // storage configuration
  @description('Optional. The storage volume configuration mode. See documentation for details.')
  storageConfigurationMode: ('Express' | 'InfraOnly' | 'KeepStorage')?

  // cluster network configuration details
  @description('Required. The subnet mask pf the Management Network for the HCI cluster - ex: 255.255.252.0.')
  subnetMask: string

  @description('Required. The default gateway of the Management Network. Example: 192.168.0.1.')
  defaultGateway: string

  @description('Required. The starting IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.')
  startingIPAddress: string

  @description('Required. The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.')
  endingIPAddress: string

  @description('Required. The DNS servers accessible from the Management Network for the HCI cluster.')
  dnsServers: string[]

  @description('Required. An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster.')
  networkIntents: networkIntentType[]

  @description('Required. Specify whether the Storage Network connectivity is switched or switchless.')
  storageConnectivitySwitchless: bool

  @description('Optional. Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false.')
  enableStorageAutoIp: bool?

  @description('Required. An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations.')
  storageNetworks: storageNetworksType[]

  // other cluster configuration parameters
  @description('Required. The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01.')
  customLocationName: string

  @description('Required. The name of the storage account to be used as the witness for the HCI Windows Failover Cluster.')
  clusterWitnessStorageAccountName: string

  @description('Required. The name of the key vault to be used for storing secrets for the HCI cluster. This currently needs to be unique per HCI cluster.')
  keyVaultName: string
}
