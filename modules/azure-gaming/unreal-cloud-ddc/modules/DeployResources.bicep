@description('Deployment Location')
param location string = resourceGroup().location

@description('Secondary Deployment Locations')
param secondaryLocations array = []

@allowed([
  'new'
  'existing'
])
param newOrExistingKubernetes string = 'new'
param name string = 'horde-storage-${take(uniqueString(resourceGroup().id), 6)}'
param agentPoolCount int = 3
param agentPoolName string = 'k8agent'
param vmSize string = 'Standard_L16s_v2'

@description('Running this template requires roleAssignment permission on the Resource Group, which require an Owner role. Set this to false to deploy some of the resources')
param assignRole bool = true

@description('Enable Zonal Redunancy for supported regions')
param isZoneRedundant bool = true

@allowed([
  'new'
  'existing'
])
param newOrExistingStorageAccount string = 'new'
param storageAccountName string = 'horde${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@allowed([
  'new'
  'existing'
])
param newOrExistingKeyVault string = 'new'
param keyVaultName string = take('hordeKeyVault${uniqueString(resourceGroup().id, subscription().subscriptionId, location)}', 24)

@allowed([
  'new'
  'existing'
])
param newOrExistingPublicIp string = 'new'
param publicIpName string = 'hordePublicIP${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@allowed([
  'new'
  'existing'
])
param newOrExistingTrafficManager string = 'new'
param trafficManagerName string = 'hordePublicIP${uniqueString(resourceGroup().id, subscription().subscriptionId)}'
@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([
  'new'
  'existing'
])
param newOrExistingCosmosDB string = 'new'
param cosmosDBName string = 'hordeDB-${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

module deployResources 'resources.bicep' = {
  name: guid(keyVaultName, publicIpName, cosmosDBName, storageAccountName)
  params: {
    location: location
    newOrExistingKubernetes: newOrExistingKubernetes
    newOrExistingCosmosDB: newOrExistingCosmosDB
    newOrExistingKeyVault: newOrExistingKeyVault
    newOrExistingPublicIp: newOrExistingPublicIp
    newOrExistingStorageAccount: newOrExistingStorageAccount
    newOrExistingTrafficManager: newOrExistingTrafficManager
    kubernetesParams: {
      name: '${name}-${take(location, 8)}'
      agentPoolCount: agentPoolCount
      agentPoolName: agentPoolName
      vmSize: vmSize
    }
    cosmosDBName: cosmosDBName
    secondaryLocations: secondaryLocations
    keyVaultName: '${location}-${keyVaultName}'
    publicIpName: '${publicIpName}-${location}'
    trafficManagerName: trafficManagerName
    trafficManagerDnsName: trafficManagerDnsName
    storageAccountName: '${take(location, 8)}${storageAccountName}'
    storageSecretName: 'horde-storage-${location}-connection-string'
    cassandraSecretName: 'horde-db-connection-string'
    assignRole: assignRole
    isZoneRedundant: isZoneRedundant
  }
}

module secondaryResources 'resources.bicep' = [for hordeLocation in secondaryLocations: {
  name: guid(keyVaultName, publicIpName, cosmosDBName, storageAccountName, hordeLocation)
  params: {
    location: hordeLocation
    newOrExistingKubernetes: newOrExistingKubernetes
    newOrExistingKeyVault: newOrExistingKeyVault
    newOrExistingPublicIp: newOrExistingPublicIp
    newOrExistingStorageAccount: newOrExistingStorageAccount
    newOrExistingTrafficManager: newOrExistingTrafficManager
    kubernetesParams: {
      name: '${name}-${take(hordeLocation, 8)}'
      agentPoolCount: agentPoolCount
      agentPoolName: agentPoolName
      vmSize: vmSize
    }
    keyVaultName: '${hordeLocation}-${keyVaultName}'
    publicIpName: '${publicIpName}-${hordeLocation}'
    trafficManagerName: trafficManagerName
    trafficManagerDnsName: trafficManagerDnsName
    storageAccountName: '${take(hordeLocation, 8)}${storageAccountName}'
    storageSecretName: 'horde-storage-${hordeLocation}-connection-string'
    assignRole: assignRole
    isZoneRedundant: isZoneRedundant
  }
}]
