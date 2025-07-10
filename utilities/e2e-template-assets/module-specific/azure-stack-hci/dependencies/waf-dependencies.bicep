@description('Optional. The password of the LCM deployment user and local administrator accounts.')
@secure()
param deploymentUserPassword string

@description('Required. The password of the LCM deployment user and local administrator accounts.')
@secure()
param localAdminPassword string

@description('Required. The app ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
param arbDeploymentAppId string

@description('Required. The service principal ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
param arbDeploymentSPObjectId string

@description('Required. The secret of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
param arbDeploymentServicePrincipalSecret string

@description('Required. The location to deploy the resources into.')
param location string

@description('Required. The name of the storage account to create as a cluster witness.')
param clusterWitnessStorageAccountName string

@description('Required. The name of the storage account to be created to collect Key Vault diagnostic logs.')
param keyVaultDiagnosticStorageAccountName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Azure Stack HCI cluster.')
param clusterName string

@description('Required. The name of the VM-managed user identity to create, used for HCI Arc onboarding.')
param userAssignedIdentityName string

@description('Required. The name of the maintenance configuration for the Azure Stack HCI Host VM and proxy server.')
param maintenanceConfigurationName string

@description('Required. The name of the Azure VM scale set for the HCI host.')
param HCIHostVirtualMachineScaleSetName string

@description('Conditional. The name of the Network Security Group ro create.')
param networkSecurityGroupName string

@description('Required. The name of the virtual network to create. Used to connect the HCI Azure Host VM to an existing VNET in the same region.')
param virtualNetworkName string

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
module hciHostDeployment '../azureStackHCIHost/hciHostDeployment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-hcihostdeploy'
  params: {
    domainOUPath: domainOUPath
    hciISODownloadURL: 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
    hciNodeCount: length(clusterNodeNames)
    hostVMSize: 'Standard_E32bds_v5'
    localAdminPassword: localAdminPassword
    location: location
    switchlessStorageConfig: false
    diskNamePrefix: diskNamePrefix
    HCIHostVirtualMachineScaleSetName: HCIHostVirtualMachineScaleSetName
    maintenanceConfigurationAssignmentName: maintenanceConfigurationAssignmentName
    maintenanceConfigurationName: maintenanceConfigurationName
    networkInterfaceName: networkInterfaceName
    networkSecurityGroupName: networkSecurityGroupName
    virtualNetworkName: virtualNetworkName
    userAssignedIdentityName: userAssignedIdentityName
    virtualMachineName: virtualMachineName
    waitDeploymentScriptPrefixName: waitDeploymentScriptPrefixName
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

module hciClusterPreqs '../azureStackHCIClusterPreqs/ashciPrereqs.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-hciclusterreqs'
  params: {
    location: location
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    keyVaultDiagnosticStorageAccountName: keyVaultDiagnosticStorageAccountName
    deploymentUsername: 'deployUser'
    deploymentUserPassword: deploymentUserPassword
    keyVaultName: keyVaultName
    localAdminPassword: localAdminPassword
    localAdminUsername: 'admin-hci'
    logsRetentionInDays: 30
    softDeleteRetentionDays: 30
    tenantId: subscription().tenantId
    vnetSubnetResourceId: hciHostDeployment.outputs.vnetSubnetResourceId
  }
}

@description('The name of the created cluster')
output clusterName string = cluster.name

@description('The name of the cluster\'s nodes.')
output clusterNodeNames array = clusterNodeNames

@description('The name of the storage account used as the cluster witness.')
output clusterWitnessStorageAccountName string = clusterWitnessStorageAccountName

@description('The OU path for the domain.')
output domainOUPath string = domainOUPath

@description('The name of the created Key Vault.')
output keyVaultName string = keyVaultName
