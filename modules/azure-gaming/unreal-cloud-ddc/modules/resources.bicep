@description('Deployment Location')
param location string

@description('Toggle to enable or disable zone redudance.')
param isZoneRedundant bool = true

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingStorageAccount string = 'none'
param storageAccountName string = 'store${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingKeyVault string = 'none'
param keyVaultName string = 'keyVault${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingPublicIp string = 'none'
param publicIpName string = 'pubip${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingCosmosDB string = 'none'
param cosmosDBName string = 'cosmos${uniqueString(resourceGroup().id, subscription().id)}'
@description('array of region objects or regions: [{locationName: string, failoverPriority: int, isZoneRedundant: bool}] or [region: string]')
param secondaryLocations array = []

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingTrafficManager string = 'none'
param trafficManagerName string = 'traffic-mp-${uniqueString(resourceGroup().id)}'
@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingKubernetes string = 'none'
param kubernetesParams object = {
  name: 'aks-${uniqueString(resourceGroup().id)}'
  agentPoolCount: 3
  agentPoolName: 'agentpool'
  vmSize: 'Standard_D2_v2'
  assignRole: true
}
param assignRole bool = true

param storageSecretName string = ''
param cassandraSecretName string = ''

var newOrExisting = {
  new: 'new'
  existing: 'existing'
}

var enableKubernetes = newOrExistingKubernetes != 'none'
var enableKeyVault = newOrExistingKeyVault != 'none'
var enableComosDB = newOrExistingCosmosDB != 'none'
var enableStorage = newOrExistingStorageAccount != 'none'
var enablePublicIP = newOrExistingPublicIp != 'none'
var enableTrafficManager = newOrExistingTrafficManager != 'none'


var noAvailabilityZones = [
  'northcentralus'
  'westus'
  'jioindiawest'
  'westcentralus'
  'australiacentral'
  'australiacentral2'
  'australiasoutheast'
  'japanwest'
  'jioindiacentral'
  'koreasouth'
  'southindia'
  'francesouth'
  'germanynorth'
  'norwayeast'
  'switzerlandwest'
  'ukwest'
  'uaecentral'
  'brazilsoutheast'
]

module clusterModule 'ContainerService/managedClusters.bicep' = if (enableKubernetes) {
  name: 'create_cluster-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    name: contains(kubernetesParams, 'name') ? kubernetesParams.name : 'aks-${uniqueString(resourceGroup().id)}'
    location: location
    agentPoolCount: contains(kubernetesParams, 'agentPoolCount') ? kubernetesParams.agentPoolCount : 3
    agentPoolName: contains(kubernetesParams, 'agentPoolName') ? kubernetesParams.agentPoolName : 'agentpool'
    vmSize: contains(kubernetesParams, 'vmSize') ? kubernetesParams.vmSize : 'Standard_D2_v2'
    assignRole: assignRole
    newOrExisting: newOrExisting[newOrExistingKubernetes]
    isZoneRedundant: isZoneRedundant && !contains(noAvailabilityZones, location)
  }
}
var rbacPolicies = [
  enableKubernetes ? { objectId: clusterModule.outputs.clusterUserObjectId } : {}
]

module keyVault 'keyvault/vaults.bicep' = if (enableKeyVault) {
  name: 'keyVault-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    location: location
    name: keyVaultName
    newOrExisting: newOrExisting[newOrExistingKeyVault]
    rbacPolicies: rbacPolicies
    assignRole: assignRole
  }
}

module cosmosDB 'CosmosDB/databaseAccounts.bicep' = if (enableComosDB) {
  name: 'cosmosDB-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    location: location
    name: cosmosDBName
    newOrExisting: newOrExisting[newOrExistingCosmosDB]
    secondaryLocations: secondaryLocations
    isZoneRedundant: isZoneRedundant && !contains(noAvailabilityZones, location)
  }
}

module storageAccount 'Storage/storageAccounts.bicep' = if (enableStorage) {
  name: 'storageAccount-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    location: location
    name: take(storageAccountName, 24)
    newOrExisting: newOrExisting[newOrExistingStorageAccount]
    isZoneRedundant: isZoneRedundant && !contains(noAvailabilityZones, location)
  }
}

module publicIp 'Network/publicIPAddress.bicep' = if (enablePublicIP) {
  name: 'publicIp-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    location: location
    name: publicIpName
    newOrExisting: newOrExisting[newOrExistingPublicIp]
  }
}

module trafficManager 'Network/trafficManagerProfiles.bicep' = if (enableTrafficManager) {
  name: 'trafficManager-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    name: trafficManagerName
    newOrExisting: newOrExisting[newOrExistingTrafficManager]
    trafficManagerDnsName: trafficManagerDnsName
    endpoints: [
      enablePublicIP ? {
        name: 'publicip${location}'
        target: publicIp.outputs.ipAddress
        endpointStatus: 'Enabled'
        endpointLocation: location
      } : {}
    ]
  }
}

module secretsBatch 'keyvault/vaults/secrets.bicep' = if (assignRole && enableKeyVault && (enableComosDB || enableStorage)) {
  name: 'secrets-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    keyVaultName: keyVault.outputs.name
    names: union(
      enableStorage ? [ { secretName: storageSecretName, secretValue: storageAccount.outputs.blobStorageConnectionString } ] : [],
      enableComosDB ? [ { secretName: cassandraSecretName, secretValue: cosmosDB.outputs.cassandraConnectionString } ] : []
    )
  }
}

output keyVaultName string = enableKeyVault ? keyVault.outputs.name : ''
output cassandraConnectionString string = enableComosDB ? cosmosDB.outputs.cassandraConnectionString : ''
output blobStorageConnectionString string = enableStorage ? storageAccount.outputs.blobStorageConnectionString : ''
output ipAddress string = enablePublicIP ? publicIp.outputs.ipAddress : ''
