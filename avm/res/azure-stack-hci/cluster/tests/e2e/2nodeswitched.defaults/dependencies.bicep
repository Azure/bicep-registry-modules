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

var clusterNodeNames = ['hcinode1', 'hcinode2']
var domainOUPath = 'OU=HCI,DC=hci,DC=local'
var hciHostAssignPublicIp = false

module hciHostDeployment '../../e2e-template-assets/azureStackHCIHost/hciHostDeployment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-hcihostdeploy'
  params: {
    hciHostAssignPublicIp: hciHostAssignPublicIp
    domainOUPath: domainOUPath
    deployProxy: false
    hciISODownloadURL: 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
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
    arcNodeResourceIds: [
      for (nodeName, index) in ['hcinode1', 'hcinode2']: resourceId('Microsoft.HybridCompute/machines', nodeName)
    ]
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    keyVaultDiagnosticStorageAccountName: keyVaultDiagnosticStorageAccountName
    deploymentUsername: 'deployUser'
    deploymentUserPassword: deploymentUserPassword
    hciResourceProviderObjectId: hciResourceProviderObjectId
    keyVaultName: keyVaultName
    localAdminPassword: localAdminPassword
    localAdminUsername: 'admin-hci'
    logsRetentionInDays: logsRetentionInDays
    softDeleteRetentionDays: softDeleteRetentionDays
    tenantId: subscription().tenantId
    vnetSubnetResourceId: hciHostDeployment.outputs.vnetSubnetResourceId
    clusterName: clusterName
    cloudId: cluster.properties.cloudId
  }
}

output clusterName string = cluster.name
output clusterNodeNames array = clusterNodeNames
output clusterWitnessStorageAccountName string = clusterWitnessStorageAccountName
output customLocationName string = customLocationName
output domainOUPath string = domainOUPath
output keyVaultName string = keyVaultName
