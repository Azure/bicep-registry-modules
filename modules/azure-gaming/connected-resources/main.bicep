@description('Deployment Location')
param location string

@description('Secondary Deployment Locations')
param secondaryLocations array = []

@allowed([ 'new', 'existing', 'none' ])
@description('Set to create a new or use an existing AKS')
param newOrExistingKubernetes string = 'none'

@description('AKS Resource Name')
param aksName string = 'aks-${take(uniqueString(resourceGroup().id, subscription().subscriptionId, location), 6)}'

@description('Count of AKS Nodes')
param agentPoolCount int = 3

@description('AKS Pool Name')
param agentPoolName string = 'k8agent'

@description('AKS VM Size')
param vmSize string = 'Standard_L16s_v2'

@allowed([ 'new', 'existing', 'none' ])
@description('Set to create a new or use an existing Storage Account')
param newOrExistingStorageAccount string = 'none'

@description('Storage Account Resource Name')
param storageAccountName string = 'st${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([ 'new', 'existing', 'none' ])
@description('Set to create a new or use an existing Key Vault')
param newOrExistingKeyVault string = 'none'

@description('Key Vault Resource Name')
param keyVaultName string = take('keyVault${uniqueString(resourceGroup().id, subscription().subscriptionId, location)}', 24)

@allowed([ 'new', 'existing', 'none' ])
@description('Set to create a new or use an existing Public IP')
param newOrExistingPublicIp string = 'none'

@description('Public IP Resource Name')
param publicIpName string = 'publicIP${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@allowed([ 'new', 'existing', 'none' ])
@description('Set to create a new or use an existing Traffic Manager Profile')
param newOrExistingTrafficManager string = 'none'

@description('Traffic Manager Resource Name')
param trafficManagerName string = 'publicIP${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([ 'new', 'existing', 'none' ])
@description('Set to create a new or use an existing Cosmos DB')
param newOrExistingCosmosDB string = 'none'

@description('Cosmos DB Resource Name')
param cosmosDBName string = 'cosmos-${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

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
    trafficManagerName: trafficManagerName
    trafficManagerDnsName: trafficManagerDnsName
    storageAccountName: '${take(location, 8)}${storageAccountName}'
    storageSecretName: 'storage-connection-string'
    cassandraSecretName: 'db-connection-string'
    assignRole: assignRole
    isZoneRedundant: isZoneRedundant
  }
}
