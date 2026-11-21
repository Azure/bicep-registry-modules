@description('Optional. The password of the LCM deployment user and local administrator accounts.')
@secure()
param deploymentUserPassword string

@description('Optional. The resource ID of a pre-baked Azure Compute Gallery image for the HCI host VM. Injected via CI-hciHostImageReferenceId secret.')
@secure()
#disable-next-line secure-parameter-default
param hciHostImageReferenceId string = ''

@description('Optional. Grant the host identity subscription Contributor.')
param assignSubscriptionContributor bool = true

@description('Optional. The object ID of the Azure Stack HCI resource provider service principal. When provided, the host deployment grants the cluster module\'s built-in roles early, so the node extensions can install before the cluster deployment.')
param hciResourceProviderObjectId string = ''

@description('Optional. Install updates on the host VM in a weekly maintenance window, restarting it if required. Disable for a long-lived host that must not install updates or restart during setup and cluster deployment.')
param enableScheduledPatching bool = true

@description('Optional. Grant the host identity Owner on the resource group. Disable to grant only the roles that Arc registration and the edge-device request need.')
param assignResourceGroupOwner bool = true

@description('Required. The password of the LCM deployment user and local administrator accounts.')
@secure()
param localAdminPassword string

@description('Optional. The app ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
param arbDeploymentAppId string?
@description('Optional. The service principal ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
param arbDeploymentSPObjectId string?
@description('Optional. The secret of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
param arbDeploymentServicePrincipalSecret string?
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

@description('Required. The name of the Azure VM to create.')
param virtualMachineName string

@description('Required. The name of the Maintenance Configuration Assignment for the proxy server.')
param maintenanceConfigurationAssignmentName string

@description('Required. The name prefix for disk resources.')
param diskNamePrefix string = 'dep-disk'

@description('Required. The name prefix for the wait deployment scripts.')
param waitDeploymentScriptPrefixName string = 'dep-wait'

@description('Optional. The HCI marketplace image version to store in Key Vault for guest VM deployments.')
param hciImageVersionName string = '20348.2461.240510'

var clusterNodeNames = ['hcinode1']
var domainOUPath = 'OU=HCI,DC=hci,DC=local'

module hciHostDeployment '../azureStackHCIHost/hciHostDeployment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-hcihostdeploy'
  params: {
    domainOUPath: domainOUPath
    imageReferenceId: hciHostImageReferenceId
    assignSubscriptionContributor: assignSubscriptionContributor
    hciResourceProviderObjectId: hciResourceProviderObjectId
    enableScheduledPatching: enableScheduledPatching
    assignResourceGroupOwner: assignResourceGroupOwner
    hciNodeCount: length(clusterNodeNames)
    hostVMSize: 'Standard_E48bds_v5'
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
    hciVHDXDownloadURL: 'https://azlocalvhds.blob.core.windows.net/images/AzLocal2601.vhdx'
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
    localAdminUsername: 'Administrator'
    logsRetentionInDays: 30
    softDeleteRetentionDays: 30
    tenantId: subscription().tenantId
    vnetSubnetResourceId: hciHostDeployment.outputs.vnetSubnetResourceId
    hciImageVersionName: hciImageVersionName
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

@description('The HCI marketplace image version stored in Key Vault for guest VM deployments.')
output imageVersionName string = hciClusterPreqs.outputs.imageVersionName
