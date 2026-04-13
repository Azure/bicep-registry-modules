targetScope = 'subscription'

metadata name = 'Using probes'
metadata description = 'This instance deploys the module with container probes.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azd-acrcontainerapp-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'acracaprb'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    managedEnvironmentName: 'dep-${namePrefix}-me-${serviceShort}'
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
      containerAppsEnvironmentName: nestedDependencies.outputs.containerAppsEnvironmentName
      location: resourceLocation
      containerProbes: [
        {
          type: 'Liveness'
          httpGet: {
            path: '/health'
            port: 8080
            httpHeaders: [
              {
                name: 'Custom-Header'
                value: 'Awesome'
              }
            ]
          }
          initialDelaySeconds: 3
          periodSeconds: 3
        }
      ]
    }
  }
]
