targetScope = 'subscription'

metadata name = 'Deploy Azure Local cluster with 1 node'
metadata description = 'TODO: assumes already Arc Provisioned'

@description('Optional. Location for all resources.')
param location string = deployment().location

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'bicep2-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashc1nzz'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

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
var enforcedLocation = 'eastus'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  name: resourceGroupName
  // location: enforcedLocation
}

module hciDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-hcidependencies-${serviceShort}'
  scope: resourceGroup
  params: {
    customLocationName: 'dep-${namePrefix}${serviceShort}-location'
    keyVaultName: 'dep-${namePrefix}${serviceShort}kv'
    clusterWitnessStorageAccountName: 'dep${namePrefix}${serviceShort}wit'
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
