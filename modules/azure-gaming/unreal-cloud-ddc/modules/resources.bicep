@description('Deployment Location')
param location string

@description('Toggle to enable or disable zone redudance.')
param isZoneRedundant bool = true

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingStorageAccount string = 'none'
param storageAccountName string = 'store${uniqueString(resourceGroup().id, subscription().id)}'
param storageResourceGroupName string = resourceGroup().name

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingKeyVault string = 'none'
param keyVaultName string = 'keyVault${uniqueString(resourceGroup().id, subscription().id)}'
param keyVaultTags object = {}

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingPublicIp string = 'none'
param publicIpName string = 'pubip${uniqueString(resourceGroup().id, subscription().id)}'

@description('Existing traffic manager name to add endpoints to. Leave empty to skip endpoints')
param trafficManagerNameForEndpoints string = ''

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingKubernetes string = 'none'
param kubernetesParams object = {
  name: 'aks-${uniqueString(resourceGroup().id)}'
  agentPoolCount: 3
  agentPoolName: 'agentpool'
  vmSize: 'Standard_D2_v2'
  assignRole: true
  clusterUserName: 'k8-${take(uniqueString(location, resourceGroup().id), 15)}'
  nodeLabels: 'defaultLabel'
}
param assignRole bool = true

@description('Subject for AKS Federated Credential')
param subject string = ''

param storageSecretName string = ''

@secure()
param storageAccountSecret string = ''

param useDnsZone bool = false
param dnsZoneName string = ''
param dnsZoneResourceGroupName string = ''
param dnsRecordNameSuffix string = ''

param logAnalyticsWorkspaceResourceId string = ''

var newOrExisting = {
  new: 'new'
  existing: 'existing'
}

var enableKubernetes = newOrExistingKubernetes != 'none'
var enableKeyVault = newOrExistingKeyVault != 'none'
var enableStorage = newOrExistingStorageAccount != 'none'
var enablePublicIP = newOrExistingPublicIp != 'none'
var enableTrafficManager = trafficManagerNameForEndpoints != ''

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

var clusterName = contains(kubernetesParams, 'name') ? kubernetesParams.name : 'aks-${uniqueString(resourceGroup().id)}'

module clusterModule 'ContainerService/managedClusters.bicep' = if (enableKubernetes) {
  name: 'create_cluster-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    name: clusterName
    location: location
    agentPoolCount: contains(kubernetesParams, 'agentPoolCount') ? kubernetesParams.agentPoolCount : 3
    agentPoolName: contains(kubernetesParams, 'agentPoolName') ? kubernetesParams.agentPoolName : 'agentpool'
    vmSize: contains(kubernetesParams, 'vmSize') ? kubernetesParams.vmSize : 'Standard_D2_v2'
    assignRole: assignRole
    newOrExisting: newOrExisting[newOrExistingKubernetes]
    isZoneRedundant: isZoneRedundant && !contains(noAvailabilityZones, location)
    subject: subject
    clusterUserName: kubernetesParams.clusterUserName
    nodeLabels: kubernetesParams.nodeLabels
    workspaceResourceId: logAnalyticsWorkspaceResourceId
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
    tags: keyVaultTags
    rbacPolicies: rbacPolicies
    assignRole: assignRole
  }
}

module storageAccount 'storage/storageAccounts.bicep' = if (enableStorage) {
  name: 'storageAccount-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    location: location
    name: take(storageAccountName, 24)
    newOrExisting: newOrExisting[newOrExistingStorageAccount]
    resourceGroupName: storageResourceGroupName
    isZoneRedundant: isZoneRedundant && !contains(noAvailabilityZones, location)
  }
}

module publicIp 'network/publicIpAddress.bicep' = if (enablePublicIP) {
  name: 'publicIp-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    location: location
    name: publicIpName
    newOrExisting: newOrExisting[newOrExistingPublicIp]
    useDnsZone: useDnsZone
    dnsZoneName: dnsZoneName
    dnsZoneResourceGroupName: dnsZoneResourceGroupName
    dnsRecordNameSuffix: dnsRecordNameSuffix
  }
}

module trafficManagerEndpoint 'network/trafficManagerEndpoints.bicep' = if (enableTrafficManager) {
  name: 'trafficManagerEndpoint-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    trafficManagerName: trafficManagerNameForEndpoints
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

module secretsBatch 'keyvault/vaults/secretsBatch.bicep' = if (assignRole && enableKeyVault ) {
  name: 'secrets-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    keyVaultName: keyVault.outputs.name
    secrets: [ { secretName: storageSecretName, secretValue: newOrExistingStorageAccount == 'new' ? storageAccount.outputs.blobStorageConnectionString : storageAccountSecret } ]
  }
}

output keyVaultName string = enableKeyVault ? keyVault.outputs.name : ''
output blobStorageConnectionString string = newOrExistingStorageAccount == 'new' ? storageAccount.outputs.blobStorageConnectionString : ''
output ipAddress string = enablePublicIP ? publicIp.outputs.ipAddress : ''
