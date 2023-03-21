// Copyright (c) 2022 Microsoft Corporation. All rights reserved.
// Azure Resources
//                                                    Parameters
// ********************************************************************************************************************
param location string
param isZoneRedundant bool = true
param storageAccountName string = 'store${uniqueString(resourceGroup().id, subscription().id)}'
param keyVaultName string = 'keyVault${uniqueString(resourceGroup().id, subscription().id)}'
param publicIpName string = 'pubip${uniqueString(resourceGroup().id, subscription().id)}'
param cosmosDBName string = 'cosmos${uniqueString(resourceGroup().id, subscription().id)}'
param secondaryLocations array = []
param trafficManagerName string = 'traffic-mp-${uniqueString(resourceGroup().id)}'
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id)}'
param assignRole bool = true
param kubernetesParams object = {
  name: 'aks-${uniqueString(resourceGroup().id)}'
  agentPoolCount: 3
  agentPoolName: 'agentpool'
  vmSize: 'Standard_D2_v2'
  assignRole: true
}

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingStorageAccount string = 'none'

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingCosmosDB string = 'none'

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingKubernetes string = 'none'

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingTrafficManager string = 'none'

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingPublicIp string = 'none'

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingKeyVault string = 'none'
// End Parameters

//                                                    Variables
// ********************************************************************************************************************
var enableKubernetes = newOrExistingKubernetes != 'none'
var enableKeyVault = newOrExistingKeyVault != 'none'
var enableComosDB = newOrExistingCosmosDB != 'none'
var enableStorage = newOrExistingStorageAccount != 'none'
var enablePublicIP = newOrExistingPublicIp != 'none'
var enableTrafficManager = newOrExistingTrafficManager != 'none'
var newOrExisting = {
  new: 'new'
  existing: 'existing'
}
var rbacPolicies = [
  enableKubernetes ? { objectId: clusterModule.outputs.clusterUserObjectId } : {}
]
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
// End Variables

//                                                    Modules
// ********************************************************************************************************************
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

module cosmosDB 'documentDB/databaseAccounts.bicep' = if (enableComosDB) {
  name: 'cosmosDB-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    location: location
    name: cosmosDBName
    newOrExisting: newOrExisting[newOrExistingCosmosDB]
    secondaryLocations: secondaryLocations
    isZoneRedundant: isZoneRedundant && !contains(noAvailabilityZones, location)
  }
}

module storageAccount 'storage/storageAccounts.bicep' = if (enableStorage) {
  name: 'storageAccount-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    location: location
    name: take(storageAccountName, 24)
    newOrExisting: newOrExisting[newOrExistingStorageAccount]
    isZoneRedundant: isZoneRedundant && !contains(noAvailabilityZones, location)
  }
}

module publicIp 'network/publicIpAddress.bicep' = if (enablePublicIP) {
  name: 'publicIp-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    location: location
    name: publicIpName
    newOrExisting: newOrExisting[newOrExistingPublicIp]
  }
}

module trafficManager 'network/trafficManagerProfiles.bicep' = if (enableTrafficManager) {
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
// End Modules

//                                                    Outputs
// ********************************************************************************************************************
output keyVaultName string = enableKeyVault ? keyVault.outputs.name : ''
output cassandraConnectionString string = enableComosDB ? cosmosDB.outputs.cassandraConnectionString : ''
output blobStorageConnectionString string = enableStorage ? storageAccount.outputs.blobStorageConnectionString : ''
output ipAddress string = enablePublicIP ? publicIp.outputs.ipAddress : ''
// End Outputs
