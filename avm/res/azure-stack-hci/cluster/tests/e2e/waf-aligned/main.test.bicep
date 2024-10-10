targetScope = 'subscription'

metadata name = 'Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration WAF aligned'
metadata description = 'This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster. WAF aligned.'

@description('Optional. The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure.')
@maxLength(15)
@minLength(4)
param name string = 'hcicluster'
@description('Optional. Location for all resources.')
param location string = deployment().location
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-azure-stack-hci.cluster-${serviceShort}-rg'
@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashc2nwaf'
@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'
@minLength(4)
@maxLength(8)
@description('Optional. The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$.')
param deploymentPrefix string = take('${take(namePrefix, 8)}${uniqueString(utcNow())}', 8)
@description('Optional. The username of the LCM deployment user created in Active Directory.')
param deploymentUsername string = 'deployUser'
@description('Optional. The password of the LCM deployment user and local administrator accounts.')
@secure()
param localAdminAndDeploymentUserPass string = newGuid()
@description('Optional. The username of the local administrator account created on the host VM and each node in the cluster.')
param localAdminUsername string = 'admin-hci'
@description('Required. The app ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentAppId string = ''
@description('Required. The service principal ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentSPObjectId string = ''
@description('Required. The secret of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentServicePrincipalSecret string = ''
@description('Optional. The names of the cluster nodes to be deployed.')
param clusterNodeNames array = ['hcinode1', 'hcinode2']
@description('Optional. The fully qualified domain name of the Active Directory domain.')
param domainFqdn string = 'hci.local'
@description('Optional. The organizational unit path in Active Directory where the cluster computer objects will be created.')
param domainOUPath string = 'OU=HCI,DC=hci,DC=local'
@description('Optional. The subnet mask for the cluster network.')
param subnetMask string = '255.255.255.0'
@description('Optional. The default gateway for the cluster network.')
param defaultGateway string = '172.20.0.1'
@description('Optional. The starting IP address for the cluster network.')
param startingIPAddress string = '172.20.0.2'
@description('Optional. The ending IP address for the cluster network.')
param endingIPAddress string = '172.20.0.7'
@description('Optional. The DNS servers for the cluster network.')
param dnsServers array = ['172.20.0.1']
@description('Optional. The ID of the subnet in the VNet where the cluster will be deployed. If omitted, a new VNET will be deployed.')
param vnetSubnetId string = ''
@description('Optional. The name of the location for the custom location.')
param customLocationName string = '${serviceShort}-location'
@description('Conditional. The URL to download the Azure Stack HCI ISO. Required if hciVHDXDownloadURL is not supplied.')
param hciISODownloadURL string = 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
@description('Conditional. The URL to download the Azure Stack HCI VHDX. Required if hciISODownloadURL is not supplied.')
param hciVHDXDownloadURL string = '' //https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/25398.469.amd64fre.zn_release_svc_refresh.231004-1141_server_serverazurestackhcicor_en-us.vhdx'
@description('Optional. The service principal ID of the Azure Stack HCI Resource Provider. If this is not provided, the module attemps to determine this value by querying the Microsoft Graph.')
@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''
@description('Optional. The network intents for the cluster.')
param networkIntents networkIntent[] = [
  {
    adapter: ['mgmt']
    name: 'management'
    overrideAdapterProperty: true
    adapterPropertyOverrides: {
      jumboPacket: '9014'
      networkDirect: 'Disabled'
      networkDirectTechnology: 'iWARP'
    }
    overrideQosPolicy: false
    qosPolicyOverrides: {
      bandwidthPercentage_SMB: '50'
      priorityValue8021Action_Cluster: '7'
      priorityValue8021Action_SMB: '3'
    }
    overrideVirtualSwitchConfiguration: false
    virtualSwitchConfigurationOverrides: {
      enableIov: 'true'
      loadBalancingAlgorithm: 'Dynamic'
    }
    trafficType: ['Management']
  }
  {
    adapter: ['comp0', 'comp1']
    name: 'compute'
    overrideAdapterProperty: true
    adapterPropertyOverrides: {
      jumboPacket: '9014'
      networkDirect: 'Disabled'
      networkDirectTechnology: 'iWARP'
    }
    overrideQosPolicy: false
    qosPolicyOverrides: {
      bandwidthPercentage_SMB: '50'
      priorityValue8021Action_Cluster: '7'
      priorityValue8021Action_SMB: '3'
    }
    overrideVirtualSwitchConfiguration: false
    virtualSwitchConfigurationOverrides: {
      enableIov: 'true'
      loadBalancingAlgorithm: 'Dynamic'
    }
    trafficType: ['Compute']
  }
  {
    adapter: ['smb0', 'smb1']
    name: 'storage'
    overrideAdapterProperty: true
    adapterPropertyOverrides: {
      jumboPacket: '9014'
      networkDirect: 'Disabled'
      networkDirectTechnology: 'iWARP'
    }
    overrideQosPolicy: true
    qosPolicyOverrides: {
      bandwidthPercentage_SMB: '50'
      priorityValue8021Action_Cluster: '7'
      priorityValue8021Action_SMB: '3'
    }
    overrideVirtualSwitchConfiguration: false
    virtualSwitchConfigurationOverrides: {
      enableIov: 'true'
      loadBalancingAlgorithm: 'Dynamic'
    }
    trafficType: ['Storage']
  }
]
@description('Optional. Enable storage auto IP configuration. If false, storageNetworks must include IP configurations.')
param enableStorageAutoIp bool = true
@description('Optional. The storage networks for the cluster.')
param storageNetworks storageNetworksArrayType = [
  {
    adapterName: 'smb0'
    vlan: '711'
  }
  {
    adapterName: 'smb1'
    vlan: '712'
  }
]

var clusterWitnessStorageAccountName = '${take('${deploymentPrefix}${serviceShort}${take(uniqueString(resourceGroup.id,resourceGroup.location),6)}',21)}wit'
var keyVaultDiagnosticStorageAccountName = '${take('${deploymentPrefix}${serviceShort}${take(uniqueString(resourceGroup.id,resourceGroup.location),6)}',21)}kvd'
var keyVaultName = 'kvhci-${deploymentPrefix}${take(uniqueString(resourceGroup.id,resourceGroup.location),6)}'

#disable-next-line no-hardcoded-location // Due to quotas and capacity challenges, this region must be used in the AVM testing subscription
var enforcedLocation = 'southeastasia'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module hciDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-hcidependencies-${serviceShort}'
  scope: resourceGroup
  params: {
    clusterNodeNames: clusterNodeNames
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    deploymentPrefix: deploymentPrefix
    deploymentUsername: deploymentUsername
    deploymentUserPassword: localAdminAndDeploymentUserPass
    domainOUPath: domainOUPath
    hciResourceProviderObjectId: hciResourceProviderObjectId
    keyVaultName: keyVaultName
    keyVaultDiagnosticStorageAccountName: keyVaultDiagnosticStorageAccountName
    localAdminPassword: localAdminAndDeploymentUserPass
    localAdminUsername: localAdminUsername
    location: enforcedLocation
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    vnetSubnetId: vnetSubnetId
    hciNodeCount: length(clusterNodeNames)
    switchlessStorageConfig: false
    hciISODownloadURL: hciISODownloadURL
    hciVHDXDownloadURL: hciVHDXDownloadURL
  }
}

module cluster_validate '../../../main.bicep' = {
  dependsOn: [
    hciDependencies
  ]
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clustervalidate-${serviceShort}'
  scope: resourceGroup
  params: {
    name: name
    customLocationName: customLocationName
    clusterNodeNames: clusterNodeNames
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    defaultGateway: defaultGateway
    deploymentMode: 'Validate'
    deploymentPrefix: deploymentPrefix
    dnsServers: dnsServers
    domainFqdn: domainFqdn
    domainOUPath: domainOUPath
    endingIPAddress: endingIPAddress
    enableStorageAutoIp: enableStorageAutoIp
    keyVaultName: keyVaultName
    networkIntents: networkIntents
    startingIPAddress: startingIPAddress
    storageConnectivitySwitchless: false
    storageNetworks: storageNetworks
    subnetMask: subnetMask
  }
}

module testDeployment '../../../main.bicep' = {
  dependsOn: [
    hciDependencies
    cluster_validate
  ]
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clusterdeploy-${serviceShort}'
  scope: resourceGroup
  params: {
    name: name
    clusterNodeNames: clusterNodeNames
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    customLocationName: customLocationName
    defaultGateway: defaultGateway
    deploymentMode: 'Deploy'
    deploymentPrefix: deploymentPrefix
    dnsServers: dnsServers
    domainFqdn: domainFqdn
    domainOUPath: domainOUPath
    endingIPAddress: endingIPAddress
    enableStorageAutoIp: enableStorageAutoIp
    keyVaultName: keyVaultName
    networkIntents: networkIntents
    startingIPAddress: startingIPAddress
    storageConnectivitySwitchless: false
    storageNetworks: storageNetworks
    subnetMask: subnetMask
  }
}

type networkIntent = {
  adapter: string[]
  name: string
  overrideAdapterProperty: bool
  adapterPropertyOverrides: {
    jumboPacket: string
    networkDirect: string
    networkDirectTechnology: string
  }
  overrideQosPolicy: bool
  qosPolicyOverrides: {
    bandwidthPercentage_SMB: string
    priorityValue8021Action_Cluster: string
    priorityValue8021Action_SMB: string
  }
  overrideVirtualSwitchConfiguration: bool
  virtualSwitchConfigurationOverrides: {
    enableIov: string
    loadBalancingAlgorithm: string
  }
  trafficType: string[]
}

// define custom type for storage adapter IP info for 3-node switchless deployments
type storageAdapterIPInfoType = {
  physicalNode: string
  ipv4Address: string
  subnetMask: string
}

// define custom type for storage network objects
type storageNetworksType = {
  adapterName: string
  vlan: string
  storageAdapterIPInfo: storageAdapterIPInfoType[]? // optional for non-switchless deployments
}
type storageNetworksArrayType = storageNetworksType[]

// cluster security configuration settings
type securityConfigurationType = {
  hvciProtection: bool
  drtmProtection: bool
  driftControlEnforced: bool
  credentialGuardEnforced: bool
  smbSigningEnforced: bool
  smbClusterEncryption: bool
  sideChannelMitigationEnforced: bool
  bitlockerBootVolume: bool
  bitlockerDataVolumes: bool
  wdacEnforced: bool
}
