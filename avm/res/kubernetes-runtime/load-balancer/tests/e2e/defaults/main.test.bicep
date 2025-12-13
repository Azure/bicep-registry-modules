targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-kubernetesruntime.loadbalancers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'krlbmin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The service principal object ID of the Kubernetes Runtime HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 087fca6e-4606-4d41-b3f6-5ebdf75b8b4c`.')
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
      addresses: [
        '10.0.0.100-10.0.0.110'
      ]
      advertiseMode: 'ARP'
      kubernetesRuntimeRPObjectId: kubernetesRuntimeRPObjectId
    }
  }
]
