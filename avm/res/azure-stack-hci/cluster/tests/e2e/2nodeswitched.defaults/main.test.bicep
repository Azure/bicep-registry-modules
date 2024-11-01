targetScope = 'subscription'

metadata name = 'Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration'
metadata description = 'This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster.'

@description('Optional. Location for all resources.')
param location string = deployment().location

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

var name = 'hcicluster'
var deploymentPrefix = 'a${take(uniqueString(namePrefix, serviceShort), 7)}' // ensure deployment prefix starts with a letter to match '^(?=.{1,8}$)([a-zA-Z])(\-?[a-zA-Z\d])*$'

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
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    clusterName: name
    clusterWitnessStorageAccountName: 'dep${namePrefix}${serviceShort}wit'
    customLocationName: 'dep-${namePrefix}${serviceShort}-location'
    deploymentPrefix: deploymentPrefix
    deploymentUserPassword: localAdminAndDeploymentUserPass
    hciResourceProviderObjectId: hciResourceProviderObjectId
    keyVaultDiagnosticStorageAccountName: 'dep${take('${deploymentPrefix}${serviceShort}${take(uniqueString(resourceGroup.name,resourceGroup.location),6)}',17)}kvd'
    keyVaultName: 'dep-${namePrefix}${serviceShort}kv'
    localAdminPassword: localAdminAndDeploymentUserPass
    location: enforcedLocation
    namePrefix: namePrefix
    serviceShort: serviceShort
  }
}

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clustermodule-${serviceShort}'
  scope: resourceGroup
  params: {
    name: name
    customLocationName: hciDependencies.outputs.customLocationName
    clusterNodeNames: hciDependencies.outputs.clusterNodeNames
    clusterWitnessStorageAccountName: hciDependencies.outputs.clusterWitnessStorageAccountName
    defaultGateway: hciDependencies.outputs.defaultGateway
    deploymentPrefix: deploymentPrefix
    dnsServers: hciDependencies.outputs.dnsServers
    domainFqdn: hciDependencies.outputs.domainFqdn
    domainOUPath: hciDependencies.outputs.domainOUPath
    endingIPAddress: hciDependencies.outputs.endingIPAddress
    enableStorageAutoIp: hciDependencies.outputs.enableStorageAutoIp
    keyVaultName: hciDependencies.outputs.keyVaultName
    networkIntents: hciDependencies.outputs.networkIntents
    startingIPAddress: hciDependencies.outputs.startingIPAddress
    storageConnectivitySwitchless: false
    storageNetworks: hciDependencies.outputs.storageNetworks
    subnetMask: hciDependencies.outputs.subnetMask
  }
}
