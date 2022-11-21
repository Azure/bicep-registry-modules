@description('Deployment Location')
param location string = resourceGroup().location

@description('Resource Group Name')
param resourceGroupName string = resourceGroup().name

@description('Secondary Deployment Locations')
param secondaryLocations array = []

@allowed([
  'new'
  'existing'
])
param newOrExistingKubernetes string = 'new'
param aksName string = 'aks-${take(uniqueString(resourceGroup().id), 6)}'
param agentPoolCount int = 3
param agentPoolName string = 'k8agent'
param vmSize string = 'Standard_L16s_v2'

@allowed([
  'new'
  'existing'
])
param newOrExistingStorageAccount string = 'new'
param storageAccountName string = 'data${uniqueString(resourceGroup().id, subscription().subscriptionId)}'
param storageResourceGroupName string = resourceGroupName

@allowed([
  'new'
  'existing'
])
param newOrExistingKeyVault string = 'new'
param keyVaultName string = take('keyVault${uniqueString(resourceGroup().id, subscription().subscriptionId, location)}', 24)

@allowed([
  'new'
  'existing'
])
param newOrExistingPublicIp string = 'new'
param publicIpName string = 'publicIP${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@allowed([
  'new'
  'existing'
])
param newOrExistingTrafficManager string = 'new'
param trafficManagerName string = 'publicIP${uniqueString(resourceGroup().id, subscription().subscriptionId)}'
@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([
  'new'
  'existing'
])
param newOrExistingCosmosDB string = 'new'
param cosmosDBName string = 'cosmos-${uniqueString(resourceGroup().id, subscription().subscriptionId)}'
param cosmosDBRG string = resourceGroupName

@description('Running this template requires roleAssignment permission on the Resource Group, which require an Owner role. Set this to false to deploy some of the resources')
param assignRole bool = true

@description('Enable Zonal Redunancy for supported regions')
param isZoneRedundant bool = true

module deployResources 'modules/resources.bicep' = {
  name: guid(keyVaultName, publicIpName, cosmosDBName, storageAccountName)
  params: {
    location: location
    newOrExistingKubernetes: newOrExistingKubernetes
    newOrExistingKeyVault: newOrExistingKeyVault
    newOrExistingPublicIp: newOrExistingPublicIp
    newOrExistingStorageAccount: newOrExistingStorageAccount
    newOrExistingTrafficManager: newOrExistingTrafficManager
    newOrExistingCosmosDB: newOrExistingCosmosDB
    kubernetesParams: {
      name: '${aksName}-${take(location, 8)}'
      agentPoolCount: agentPoolCount
      agentPoolName: agentPoolName
      vmSize: vmSize
      clusterUserName: 'id-${aksName}-${location}'
    }
    secondaryLocations: secondaryLocations
    keyVaultName: take('${location}-${keyVaultName}', 24)
    publicIpName: '${publicIpName}-${location}'
    cosmosDBName: cosmosDBName
    cosmosDBRG: cosmosDBRG
    trafficManagerName: trafficManagerName
    trafficManagerDnsName: trafficManagerDnsName
    storageAccountName: '${take(location, 8)}${storageAccountName}'
    storageResourceGroupName: storageResourceGroupName
    storageSecretName: 'storage-connection-string'
    cassandraSecretName: 'db-connection-string'
    assignRole: assignRole
    isZoneRedundant: isZoneRedundant
  }
}
