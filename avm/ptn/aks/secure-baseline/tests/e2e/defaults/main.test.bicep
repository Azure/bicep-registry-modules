targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'Deploys the IPv4 AKS secure baseline in Auto node provisioning mode with its default networking and security configuration.'

@description('Optional. The location to deploy the AKS cluster and cluster-specific resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment.')
param serviceShort string = 'aksmin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in [
    'init'
    'idem'
  ]: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      clusterName: 'aks-${namePrefix}${serviceShort}'
      serviceName: '${namePrefix}-${serviceShort}'
      clusterLocation: resourceLocation
      globalResourceGroupName: 'dep-${namePrefix}-${serviceShort}-global-rg'
      subscriptionResourceGroupName: 'dep-${namePrefix}-${serviceShort}-sub-rg'
      clusterResourceGroupName: 'dep-${namePrefix}-aks-secure-baseline-${serviceShort}-rg'
    }
  }
]
