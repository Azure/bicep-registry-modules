targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-kubernetesconfiguration.extensions-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'kcemax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    clusterName: 'dep-${namePrefix}-aks-${serviceShort}'
    clusterNodeResourceGroupName: 'nodes-${resourceGroupName}'
    location: resourceLocation
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
      location: resourceLocation
      clusterName: nestedDependencies.outputs.clusterName
      extensionType: 'microsoft.flux'
      configurationSettings: {
        'image-automation-controller.enabled': 'false'
        'image-reflector-controller.enabled': 'false'
        'kustomize-controller.enabled': 'true'
        'notification-controller.enabled': 'false'
        'source-controller.enabled': 'true'
      }
      releaseNamespace: 'flux-system'
      releaseTrain: 'Stable'
      version: '0.5.2'
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
    dependsOn: [
      nestedDependencies
    ]
  }
]
