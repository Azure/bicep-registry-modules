targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with connected cluster.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-kubernetesconfiguration.extensions-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'kcecc'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    clusterName: '${namePrefix}${serviceShort}01'
    clusterExtensionName: '${namePrefix}${serviceShort}001'
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
      extensionType: 'microsoft.flux'
      releaseNamespace: 'flux-system'
      releaseTrain: 'Stable'
      fluxConfigurations: [
        {
          namespace: 'flux-system'
          scope: 'cluster'
          gitRepository: {
            repositoryRef: {
              branch: 'main'
            }
            sshKnownHosts: ''
            syncIntervalInSeconds: 300
            timeoutInSeconds: 180
            url: 'https://github.com/mspnp/aks-baseline'
          }
          kustomizations: {
            unified: {
              path: './cluster-manifests'
            }
          }
          suspend: false
        }
      ]
    }
  }
]
