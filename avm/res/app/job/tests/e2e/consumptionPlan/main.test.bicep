targetScope = 'subscription'

metadata name = 'Using a consumption plan'
metadata description = 'This instance deploys the module to a Container Apps Environment with a consumption plan.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.job-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ajcon'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested'
  params: {
    location: resourceLocation
    managedEnvironmentName: 'dep-${namePrefix}-menv-${serviceShort}'
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
      environmentResourceId: nestedDependencies.outputs.managedEnvironmentResourceId
      location: resourceLocation
      triggerType: 'Manual'
      manualTriggerConfig: {}
      containers: [
        {
          name: 'simple-hello-world-container'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        }
      ]
    }
  }
]
