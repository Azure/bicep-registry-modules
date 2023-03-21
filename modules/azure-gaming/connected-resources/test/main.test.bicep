@description('Deployment Location')
param location string = resourceGroup().location

module noDeployment '../main.bicep' = {
  name: 'NoResources'
  params: {
    location: location
  }
}

module basicResources '../main.bicep' = {
  name: 'basicResources'
  params: {
    location: location
    newOrExistingKubernetes: 'new'
    newOrExistingStorageAccount: 'new'
    newOrExistingKeyVault: 'new'
    newOrExistingPublicIp: 'new'
    newOrExistingTrafficManager: 'new'
    newOrExistingCosmosDB: 'new'
    vmSize: 'standard_a2_v2'
  }
}
