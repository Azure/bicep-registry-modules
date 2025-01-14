targetScope = 'subscription'

metadata name = 'Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration'
metadata description = 'This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-azure-stack-hci.cluster-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashc2nmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password of the LCM deployment user and local administrator accounts.')
@secure()
param localAdminAndDeploymentUserPass string = newGuid()

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

@description('Required. The service principal ID of the Azure Stack HCI Resource Provider in this tenant.')
@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''

var deploymentPrefix = 'a${take(uniqueString(namePrefix, serviceShort), 7)}' // ensure deployment prefix starts with a letter to match '^(?=.{1,8}$)([a-zA-Z])(\-?[a-zA-Z\d])*$'

#disable-next-line no-hardcoded-location // Due to quotas and capacity challenges, this region must be used in the AVM testing subscription
var enforcedLocation = 'southeastasia'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-nestedDependencies-${serviceShort}'
  scope: resourceGroup
  params: {
    clusterName: '${namePrefix}${serviceShort}001'
    clusterWitnessStorageAccountName: 'dep${namePrefix}${serviceShort}wit'
    customLocationName: 'dep-${namePrefix}${serviceShort}-location'
    keyVaultDiagnosticStorageAccountName: 'dep${namePrefix}st${serviceShort}'
    keyVaultName: 'dep-${namePrefix}${serviceShort}kv'
    userAssignedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    maintenanceConfigurationName: 'dep-${namePrefix}-mc-${serviceShort}'
    maintenanceConfigurationAssignmentName: 'dep-${namePrefix}-mca-${serviceShort}'
    HCIHostPublicIpName: 'dep-${namePrefix}-hpip-${serviceShort}'
    HCIHostNetworkInterfaceGroupName: 'dep-${namePrefix}-hnic-${serviceShort}'
    HCIHostVirtualMachineScaleSetName: 'dep-${namePrefix}-hvmss-${serviceShort}'
    networkInterfaceName: 'dep-${namePrefix}-mice-${serviceShort}'
    diskNamePrefix: 'dep-${namePrefix}-disk-${serviceShort}'
    virtualMachineName: 'dep-${namePrefix}-vm-${serviceShort}'
    waitDeploymentScriptPrefixName: 'dep-${namePrefix}-wds-${serviceShort}'
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    deploymentUserPassword: localAdminAndDeploymentUserPass
    hciResourceProviderObjectId: hciResourceProviderObjectId
    localAdminPassword: localAdminAndDeploymentUserPass
    location: enforcedLocation
  }
}

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clustermodule-${serviceShort}'
  scope: resourceGroup
  params: {
    name: nestedDependencies.outputs.clusterName
    customLocationName: nestedDependencies.outputs.customLocationName
    clusterNodeNames: nestedDependencies.outputs.clusterNodeNames
    clusterWitnessStorageAccountName: nestedDependencies.outputs.clusterWitnessStorageAccountName
    defaultGateway: nestedDependencies.outputs.defaultGateway
    deploymentPrefix: deploymentPrefix
    dnsServers: nestedDependencies.outputs.dnsServers
    domainFqdn: nestedDependencies.outputs.domainFqdn
    domainOUPath: nestedDependencies.outputs.domainOUPath
    endingIPAddress: nestedDependencies.outputs.endingIPAddress
    enableStorageAutoIp: nestedDependencies.outputs.enableStorageAutoIp
    keyVaultName: nestedDependencies.outputs.keyVaultName
    networkIntents: nestedDependencies.outputs.networkIntents
    startingIPAddress: nestedDependencies.outputs.startingIPAddress
    storageConnectivitySwitchless: false
    storageNetworks: nestedDependencies.outputs.storageNetworks
    subnetMask: nestedDependencies.outputs.subnetMask
  }
}
