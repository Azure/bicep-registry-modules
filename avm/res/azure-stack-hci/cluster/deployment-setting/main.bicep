metadata name = 'Azure Stack HCI Cluster Deployment Settings'
metadata description = 'This module deploys an Azure Stack HCI Cluster Deployment Settings resource.'

@description('Optional. The name of the deployment settings.')
@allowed([
  'default'
])
param name string = 'default'

@description('Conditional. The name of the Azure Stack HCI cluster - this will be the name of your cluster in Azure. Required if the template is used in a standalone deployment.')
@maxLength(40)
@minLength(4)
param clusterName string

@description('Conditional. The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name. Required if the template is used in a standalone deployment.')
@maxLength(15)
@minLength(4)
param clusterADName string

@description('Required. First must pass with this parameter set to Validate prior running with it set to Deploy. If either Validation or Deployment phases fail, fix the issue, then resubmit the template with the same deploymentMode to retry.')
@allowed([
  'Validate'
  'Deploy'
])
param deploymentMode string

@minLength(4)
@maxLength(8)
@description('Required. The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$.')
param deploymentPrefix string

@description('Required. Names of the cluster node Arc Machine resources. These are the name of the Arc Machine resources created when the new HCI nodes were Arc initialized. Example: [hci-node-1, hci-node-2].')
param clusterNodeNames array

@description('Required. The domain name of the Active Directory Domain Services. Example: "contoso.com".')
param domainFqdn string

@description('Required. The ADDS OU path - ex "OU=HCI,DC=contoso,DC=com".')
param domainOUPath string

@description('Optional. The Hypervisor-protected Code Integrity setting.')
param hvciProtection bool = true

@description('Optional. The hardware-dependent Secure Boot setting.')
param drtmProtection bool = true

@description('Optional. When set to true, the security baseline is re-applied regularly.')
param driftControlEnforced bool = false

@description('Optional. Enables the Credential Guard.')
param credentialGuardEnforced bool = false

@description('Optional. When set to true, the SMB default instance requires sign in for the client and server services.')
param smbSigningEnforced bool = false

@description('Optional. When set to true, cluster east-west traffic is encrypted.')
param smbClusterEncryption bool = false

@description('Optional. When set to true, all the side channel mitigations are enabled.')
param sideChannelMitigationEnforced bool = false

@description('Optional. When set to true, BitLocker XTS_AES 256-bit encryption is enabled for all data-at-rest on the OS volume of your Azure Stack HCI cluster. This setting is TPM-hardware dependent.')
param bitlockerBootVolume bool = false

@description('Optional. When set to true, BitLocker XTS-AES 256-bit encryption is enabled for all data-at-rest on your Azure Stack HCI cluster shared volumes.')
param bitlockerDataVolumes bool = false

@description('Optional. Limits the applications and the code that you can run on your Azure Stack HCI cluster.')
param wdacEnforced bool = true

// cluster diagnostics and telemetry configuration
@description('Optional. The metrics data for deploying a HCI cluster.')
param streamingDataClient bool = true

@description('Optional. The location data for deploying a HCI cluster.')
param isEuropeanUnionLocation bool = false

@description('Optional. The diagnostic data for deploying a HCI cluster.')
param episodicDataUpload bool = true

// storage configuration
@description('Optional. The storage volume configuration mode. See documentation for details.')
@allowed([
  'Express'
  'InfraOnly'
  'KeepStorage'
])
param storageConfigurationMode string = 'Express'

@description('Required. If true, the service principal secret for ARB is required. If false, the secrets wiil not be required.')
param needArbSecret bool

// cluster network configuration details
@description('Required. The subnet mask pf the Management Network for the HCI cluster - ex: 255.255.252.0.')
param subnetMask string

@description('Required. The default gateway of the Management Network. Example: 192.168.0.1.')
param defaultGateway string

@description('Required. The starting IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.')
param startingIPAddress string

@description('Required. The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.')
param endingIPAddress string

@description('Required. The DNS servers accessible from the Management Network for the HCI cluster.')
param dnsServers string[]

@description('Optional. If true, the infrastructure network uses DHCP. If false, static IP pools are used.')
param useDhcp bool = false

@description('Optional. Physical node settings to pass through to the deployment settings resource. If not provided, the module derives node IPs from Arc edgeDevices.')
param physicalNodesSettings array = []

@description('Required. An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster.')
param networkIntents array

@description('Required. Specify whether the Storage Network connectivity is switched or switchless.')
param storageConnectivitySwitchless bool

@description('Optional. Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false.')
param enableStorageAutoIp bool = true

@description('Required. An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations.')
param storageNetworks array

// other cluster configuration parameters
@description('Required. The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01.')
param customLocationName string

@description('Required. The name of the storage account to be used as the witness for the HCI Windows Failover Cluster.')
param clusterWitnessStorageAccountName string

@description('Optional. Witness type for the cluster. Use `No Witness` to omit witness configuration in the RP payload.')
@allowed([
  'Cloud'
  'No Witness'
])
param witnessType string = 'Cloud'

@description('Required. The name of the key vault to be used for storing secrets for the HCI cluster.')
param keyVaultName string

@description('Optional. If using a shared key vault or non-legacy secret naming, pass the properties.cloudId guid from the pre-created HCI cluster resource.')
param cloudId string?

@description('Optional. The intended operation for a cluster.')
@allowed([
  'ClusterProvisioning'
  'ClusterUpgrade'
])
param operationType string = 'ClusterProvisioning'

@description('Optional. Solution builder extension (SBE) version.')
param sbeVersion string = ''

@description('Optional. Solution builder extension (SBE) family value.')
param sbeFamily string = ''

@description('Optional. Solution builder extension (SBE) publisher name.')
param sbePublisher string = ''

@description('Optional. Solution builder extension (SBE) manifest source.')
param sbeManifestSource string = ''

@description('Optional. Solution builder extension (SBE) creation date.')
param sbeManifestCreationDate string = ''

@description('Optional. Solution builder extension (SBE) partner properties.')
param partnerProperties array = []

@description('Optional. Solution builder extension (SBE) partner credential properties.')
param partnerCredentialList array = []

var arcNodeResourceIds = [
  for (nodeName, index) in clusterNodeNames: resourceId('Microsoft.HybridCompute/machines', nodeName)
]

var storageNetworksArray = [
  for (storageAdapter, index) in storageNetworks: {
    name: storageAdapter.name
    networkAdapterName: storageAdapter.adapterName
    vlanId: storageAdapter.vlan
    storageAdapterIPInfo: storageAdapter.?storageAdapterIPInfo
  }
]

var translatedNetworkIntents = [
  for intent in networkIntents: {
    ...intent
    qosPolicyOverrides: (intent.?qosPolicyOverrides == null) ? null : {
      bandwidthPercentage_SMB: intent.qosPolicyOverrides.?bandwidthPercentageSMB ?? ''
      priorityValue8021Action_Cluster: intent.qosPolicyOverrides.?priorityValue8021ActionCluster ?? ''
      priorityValue8021Action_SMB: intent.qosPolicyOverrides.?priorityValue8021ActionSMB ?? ''
    }
  }
]

var sbeCredentialList = [
  for credential in partnerCredentialList: {
    secretName: empty(cloudId) ? credential.secretName : '${clusterName}-${credential.secretName}-${cloudId}'
    eceSecretName: credential.secretName
    secretLocation: empty(cloudId)
      ? 'https://${keyVaultName}${environment().suffixes.keyvaultDns}/secrets/${credential.secretName}'
      : 'https://${keyVaultName}${environment().suffixes.keyvaultDns}/secrets/${clusterName}-${credential.secretName}-${cloudId}'
  }
]

var witnessTypeVar = witnessType == 'No Witness' ? '' : 'Cloud'
var clusterWitnessStorageAccountNameVar = witnessType == 'No Witness' ? '' : clusterWitnessStorageAccountName
var azureServiceEndpointVar = witnessType == 'No Witness' ? '' : environment().suffixes.storage


resource cluster 'Microsoft.AzureStackHCI/clusters@2025-10-01' existing = {
  name: clusterName
}

var baseSecretNames = [
  'LocalAdminCredential'
  'AzureStackLCMUserCredential'
  'WitnessStorageKey'
]

var allSecretNames = needArbSecret ? concat(baseSecretNames, ['DefaultARBApplication']) : baseSecretNames

resource deploymentSettings 'Microsoft.AzureStackHCI/clusters/deploymentSettings@2025-10-01' = {
  name: name
  parent: cluster
  properties: {
    arcNodeResourceIds: arcNodeResourceIds
    deploymentMode: deploymentMode
    operationType: operationType == 'ClusterUpgrade' ? operationType : null
    deploymentConfiguration: {
      version: operationType == 'ClusterUpgrade' ? '1#_moduleVersion_#.0' : '10.0.0.0'
      scaleUnits: [
        {
          deploymentData: {
            securitySettings: operationType == 'ClusterUpgrade'
              ? null
              : {
                  hvciProtection: hvciProtection
                  drtmProtection: drtmProtection
                  driftControlEnforced: driftControlEnforced
                  credentialGuardEnforced: credentialGuardEnforced
                  smbSigningEnforced: smbSigningEnforced
                  smbClusterEncryption: smbClusterEncryption
                  sideChannelMitigationEnforced: sideChannelMitigationEnforced
                  bitlockerBootVolume: bitlockerBootVolume
                  bitlockerDataVolumes: bitlockerDataVolumes
                  wdacEnforced: wdacEnforced
                }
            observability: {
              streamingDataClient: streamingDataClient
              euLocation: isEuropeanUnionLocation
              episodicDataUpload: episodicDataUpload
            }
            cluster: {
              name: clusterADName
              witnessType: witnessTypeVar
              witnessPath: ''
              cloudAccountName: clusterWitnessStorageAccountNameVar
              azureServiceEndpoint: azureServiceEndpointVar
            }
            storage: {
              configurationMode: storageConfigurationMode
            }
            namingPrefix: deploymentPrefix
            domainFqdn: domainFqdn
            infrastructureNetwork: [
              {
                subnetMask: subnetMask
                gateway: defaultGateway
                ipPools: [
                  {
                    startingAddress: startingIPAddress
                    endingAddress: endingIPAddress
                  }
                ]
                dnsServers: dnsServers
                useDhcp: useDhcp
              }
            ]
            physicalNodes: [
              for (hciNode, index) in arcNodeResourceIds: {
                name: !empty(physicalNodesSettings)
                  ? physicalNodesSettings[index].name
                  : reference(hciNode, '2022-12-27', 'Full').properties.displayName
                // Getting the IP from the first NIC of the node with a default gateway. Only the first management pNIC should have a gateway defined.
                // This reference call requires that the 'DeviceManagementExtension' extension be fully initialized on each node, which creates the
                // edgeDevices sub-resource queried below, containing the IP configuration. View the edgedevice to troubleshoot by appending
                // `/providers/microsoft.azurestackhci/edgedevices/default` to the end the HCI Arc Machine resource id and using `az resource show --id <id>`
                ipv4Address: !empty(physicalNodesSettings)
                  ? physicalNodesSettings[index].ipv4Address
                  : (filter(
                      reference('${hciNode}/providers/microsoft.azurestackhci/edgeDevices/default', '2024-01-01', 'Full').properties.deviceConfiguration.nicDetails,
                      nic => nic.?defaultGateway != null
                    ))[0].ip4Address
              }
            ]
            hostNetwork: operationType == 'ClusterUpgrade'
              ? null
              : {
                  intents: translatedNetworkIntents
                  storageConnectivitySwitchless: storageConnectivitySwitchless
                  storageNetworks: storageNetworksArray
                  enableStorageAutoIp: enableStorageAutoIp
                }
            adouPath: domainOUPath
            secretsLocation: 'https://${keyVaultName}${environment().suffixes.keyvaultDns}'
            optionalServices: {
              customLocation: customLocationName
            }
            secrets: [
              for secretName in allSecretNames: {
                secretName: empty(cloudId) ? secretName : '${clusterName}-${secretName}-${cloudId}'
                eceSecretName: secretName
                secretLocation: empty(cloudId)
                  ? 'https://${keyVaultName}${environment().suffixes.keyvaultDns}/secrets/${secretName}'
                  : 'https://${keyVaultName}${environment().suffixes.keyvaultDns}/secrets/${clusterName}-${secretName}-${cloudId}'
              }
            ]
          }
          sbePartnerInfo: {
            sbeDeploymentInfo: {
              version: sbeVersion
              family: sbeFamily
              publisher: sbePublisher
              sbeManifestSource: sbeManifestSource
              sbeManifestCreationDate: empty(sbeManifestCreationDate) ? null : sbeManifestCreationDate
            }
            partnerProperties: partnerProperties
            credentialList: sbeCredentialList
          }
        }
      ]
    }
  }
}

@description('The name of the cluster deployment settings.')
output name string = deploymentSettings.name

@description('The ID of the cluster deployment settings.')
output resourceId string = deploymentSettings.id

@description('The resource group of the cluster deployment settings.')
output resourceGroupName string = resourceGroup().name
