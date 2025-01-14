@secure()
param deploymentUserPassword string
@secure()
param localAdminPassword string
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentAppId string = ''
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentSPObjectId string = ''
@secure()
param arbDeploymentServicePrincipalSecret string = ''
param location string
param softDeleteRetentionDays int = 30
@minValue(0)
@maxValue(365)
param logsRetentionInDays int = 30
param clusterWitnessStorageAccountName string
param keyVaultDiagnosticStorageAccountName string
param keyVaultName string
param customLocationName string

@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''
param clusterName string

@description('Required. The name of the VM-managed user identity to create, used for HCI Arc onboarding.')
param userAssignedIdentityName string

@description('Conditional. The name of the VNET for the HCI host Azure VM. Required if \'vnetSubnetResourceId\' is empty.')
param virtualNetworkName string

@description('Required. The name of the maintenance configuration for the Azure Stack HCI Host VM and proxy server.')
param maintenanceConfigurationName string

@description('Conditional. The name of the Public IP Address for the HCI host. Required if \'hciHostAssignPublicIp\' is true.')
param HCIHostPublicIpName string

@description('Conditional. The name of the Network Security Group for the HCI host. Required if \'hciHostAssignPublicIp\' is true.')
param HCIHostNetworkInterfaceGroupName string

@description('Required. The name of the Azure VM scale set for the HCI host.')
param HCIHostVirtualMachineScaleSetName string

@description('Required. The name of the Network Interface Card to create.')
param networkInterfaceName string

@description('Required. The name prefix for the Disks to create.')
param diskNamePrefix string

@description('Required. The name of the Azure VM to create.')
param virtualMachineName string

@description('Required. The name of the Maintenance Configuration Assignment for the proxy server.')
param maintenanceConfigurationAssignmentName string

@description('Required. The name prefix for the \'wait\' deployment scripts to create.')
param waitDeploymentScriptPrefixName string

var deploymentUsername = 'deployUser'
var localAdminUsername = 'admin-hci'
var clusterNodeNames = ['hcinode1', 'hcinode2']
var domainOUPath = 'OU=HCI,DC=hci,DC=local'
var hciHostAssignPublicIp = false
var domainFqdn = 'hci.local'
var subnetMask = '255.255.255.0'
var defaultGateway = '172.20.0.1'
var startingIPAddress = '172.20.0.2'
var endingIPAddress = '172.20.0.7'
var dnsServers = ['172.20.0.1']
var enableStorageAutoIp = true

var hciISODownloadURL = 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'

var networkIntents = [
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

var storageNetworks = [
  {
    adapterName: 'smb0'
    vlan: '711'
  }
  {
    adapterName: 'smb1'
    vlan: '712'
  }
]

var arcNodeResourceIds = [
  for (nodeName, index) in clusterNodeNames: resourceId('Microsoft.HybridCompute/machines', nodeName)
]

var tenantId = subscription().tenantId

module hciHostDeployment '../../e2e-template-assets/azureStackHCIHost/hciHostDeployment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-hcihostdeploy'
  params: {
    hciHostAssignPublicIp: hciHostAssignPublicIp
    domainOUPath: domainOUPath
    deployProxy: false
    hciISODownloadURL: hciISODownloadURL
    hciNodeCount: length(clusterNodeNames)
    hostVMSize: 'Standard_E16bds_v5'
    localAdminPassword: localAdminPassword
    location: location
    switchlessStorageConfig: false

    diskNamePrefix: diskNamePrefix
    HCIHostVirtualMachineScaleSetName: HCIHostVirtualMachineScaleSetName
    HCIHostNetworkInterfaceGroupName: HCIHostNetworkInterfaceGroupName
    HCIHostPublicIpName: HCIHostPublicIpName
    maintenanceConfigurationAssignmentName: maintenanceConfigurationAssignmentName
    maintenanceConfigurationName: maintenanceConfigurationName
    networkInterfaceName: networkInterfaceName
    userAssignedIdentityName: userAssignedIdentityName
    virtualMachineName: virtualMachineName
    waitDeploymentScriptPrefixName: waitDeploymentScriptPrefixName
    virtualNetworkName: virtualNetworkName
  }
}

// create the HCI cluster resource - cloudId property is needed for KeyVault secret names
resource cluster 'Microsoft.AzureStackHCI/clusters@2024-04-01' = {
  name: clusterName
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  properties: {}
}

module hciClusterPreqs '../../e2e-template-assets/azureStackHCIClusterPreqs/ashciPrereqs.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-hciclusterreqs'
  params: {
    location: location
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    arcNodeResourceIds: arcNodeResourceIds
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    keyVaultDiagnosticStorageAccountName: keyVaultDiagnosticStorageAccountName
    deploymentUsername: deploymentUsername
    deploymentUserPassword: deploymentUserPassword
    hciResourceProviderObjectId: hciResourceProviderObjectId
    keyVaultName: keyVaultName
    localAdminPassword: localAdminPassword
    localAdminUsername: localAdminUsername
    logsRetentionInDays: logsRetentionInDays
    softDeleteRetentionDays: softDeleteRetentionDays
    tenantId: tenantId
    vnetSubnetResourceId: hciHostDeployment.outputs.vnetSubnetResourceId
    clusterName: clusterName
    cloudId: cluster.properties.cloudId
  }
}

output cluster object = cluster
output clusterName string = cluster.name
output clusterNodeNames array = clusterNodeNames
output clusterWitnessStorageAccountName string = clusterWitnessStorageAccountName
output customLocationName string = customLocationName
output defaultGateway string = defaultGateway
output dnsServers array = dnsServers
output domainFqdn string = domainFqdn
output domainOUPath string = domainOUPath
output enableStorageAutoIp bool = enableStorageAutoIp
output endingIPAddress string = endingIPAddress
output hciClusterPreqs object = hciClusterPreqs
output keyVaultName string = keyVaultName
output networkIntents array = networkIntents
output startingIPAddress string = startingIPAddress
output storageNetworks array = storageNetworks
output subnetMask string = subnetMask
