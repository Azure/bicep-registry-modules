metadata name = 'Azure Stack HCI Cluster Deployment Settings'
metadata description = 'This module deploys an Azure Stack HCI Cluster Deployment Settings resource.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure.')
@maxLength(15)
@minLength(4)
param clusterName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Optional. Tags of the resource.')
param tags object?

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

@description('Optional. Security configuration settings object; defaults to most secure posture.')
param securityConfiguration object = {
  hvciProtection: true
  drtmProtection: true
  driftControlEnforced: true
  credentialGuardEnforced: true
  smbSigningEnforced: true
  smbClusterEncryption: true
  sideChannelMitigationEnforced: true
  bitlockerBootVolume: true
  bitlockerDataVolumes: true
  wdacEnforced: true
}

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

// cluster network configuration details
@description('Required. The subnet mask pf the Management Network for the HCI cluster - ex: 255.255.252.0.')
param subnetMask string

@description('Required. The default gateway of the Management Network. Exameple: 192.168.0.1.')
param defaultGateway string

@description('Required. The starting IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.')
param startingIPAddress string

@description('Required. The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.')
param endingIPAddress string

@description('Required. The DNS servers accessible from the Management Network for the HCI cluster.')
param dnsServers array

@description('Required. An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster.')
param networkIntents array

@description('Required. Specify whether the Storage Network connectivity is switched or switchless.')
param storageConnectivitySwitchless bool

@description('Required. Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false.')
param enableStorageAutoIp bool = true

@description('Required. An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations.')
param storageNetworks array

// other cluster configuration parameters
@description('Required. The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01.')
param customLocationName string

@description('Required. The name of the storage account to be used as the witness for the HCI Windows Failover Cluster.')
param clusterWitnessStorageAccountName string

@description('Required. The name of the key vault to be used for storing secrets for the HCI cluster. This currently needs to be unique per HCI cluster.')
param keyVaultName string

var arcNodeResourceIds = [
  for (nodeName, index) in clusterNodeNames: resourceId('Microsoft.HybridCompute/machines', nodeName)
]

var storageNetworkList = [
  for (storageAdapter, index) in storageNetworks: {
    name: 'StorageNetwork${index + 1}'
    networkAdapterName: storageAdapter.adapterName
    vlanId: storageAdapter.vlan
    storageAdapterIPInfo: storageAdapter.?storageAdapterIPInfo
  }
]

resource cluster 'Microsoft.AzureStackHCI/clusters@2024-04-01' existing = {
  name: clusterName
}

resource deploymentSettings 'Microsoft.AzureStackHCI/clusters/deploymentSettings@2024-04-01' = {
  name: 'default'
  parent: cluster
  properties: {
    arcNodeResourceIds: arcNodeResourceIds
    deploymentMode: deploymentMode
    deploymentConfiguration: {
      version: '10.0.0.0'
      scaleUnits: [
        {
          deploymentData: {
            securitySettings: {
              hvciProtection: securityConfiguration.hvciProtection
              drtmProtection: securityConfiguration.drtmProtection
              driftControlEnforced: securityConfiguration.driftControlEnforced
              credentialGuardEnforced: securityConfiguration.credentialGuardEnforced
              smbSigningEnforced: securityConfiguration.smbSigningEnforced
              smbClusterEncryption: securityConfiguration.smbClusterEncryption
              sideChannelMitigationEnforced: securityConfiguration.sideChannelMitigationEnforced
              bitlockerBootVolume: securityConfiguration.bitlockerBootVolume
              bitlockerDataVolumes: securityConfiguration.bitlockerDataVolumes
              wdacEnforced: securityConfiguration.wdacEnforced
            }
            observability: {
              streamingDataClient: streamingDataClient
              euLocation: isEuropeanUnionLocation
              episodicDataUpload: episodicDataUpload
            }
            cluster: {
              name: clusterName
              witnessType: 'Cloud'
              witnessPath: ''
              cloudAccountName: clusterWitnessStorageAccountName
              azureServiceEndpoint: environment().suffixes.storage
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
              }
            ]
            physicalNodes: [
              for hciNode in arcNodeResourceIds: {
                name: reference(hciNode, '2022-12-27', 'Full').properties.displayName
                // Getting the IP from the first NIC of the node with a default gateway. Only the first management NIC should have a gateway defined.
                // This reference call requires that the 'DeviceManagementExtension' extension be fully initialized on each node, which creates the
                // referenced edgeDevices sub-resource, containing the IP configuration.
                ipv4Address: (filter(
                  reference('${hciNode}/providers/microsoft.azurestackhci/edgeDevices/default', '2024-01-01', 'Full').properties.deviceConfiguration.nicDetails,
                  nic => nic.?defaultGateway != null
                ))[0].ip4Address
              }
            ]
            hostNetwork: {
              intents: networkIntents
              storageConnectivitySwitchless: storageConnectivitySwitchless
              storageNetworks: storageNetworkList
              enableStorageAutoIp: enableStorageAutoIp
            }
            adouPath: domainOUPath
            secretsLocation: 'https://${keyVaultName}${environment().suffixes.keyvaultDns}'
            optionalServices: {
              customLocation: customLocationName
            }
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
