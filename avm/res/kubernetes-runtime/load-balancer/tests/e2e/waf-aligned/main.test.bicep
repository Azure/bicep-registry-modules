targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-kubernetesruntime.loadbalancers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'krlbwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the \'Microsoft.AzureStackHCI\' provider was registered in the subscription.')
@secure()
#disable-next-line secure-parameter-default
param kubernetesRuntimeRPObjectId string = ''

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    clusterName: '${namePrefix}${serviceShort}01'
  }
}

module arcnetworking 'br/public:avm/res/kubernetes-configuration/extension:0.3.7' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-arcnetworking'
  params: {
    name: 'arcnetworking'
    clusterName: nestedDependencies.outputs.clusterName
    clusterType: 'connectedCluster'
    extensionType: 'microsoft.arcnetworking'
    releaseNamespace: 'kube-system'
    configurationSettings: {
      k8sRuntimeFpaObjectId: kubernetesRuntimeRPObjectId
    }
    releaseTrain: 'stable'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      clusterName: nestedDependencies.outputs.clusterName
      clusterType: 'connectedCluster'
      addresses: [
        '10.0.0.100-10.0.0.110'
      ]
      advertiseMode: 'Both'
      bgpPeers: ['test-peer']
      serviceSelector: {
        test: 'waf-test'
      }
    }
  }
]
