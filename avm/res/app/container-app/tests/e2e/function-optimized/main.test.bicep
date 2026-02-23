targetScope = 'subscription'

metadata name = 'Support for Azure Functions'
metadata description = 'This instance is configured to be able to host Azure Functions'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.containerApps-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'acafunc'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
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
      kind: 'functionapp'
      environmentResourceId: nestedDependencies.outputs.managedEnvironmentResourceId
      activeRevisionsMode: 'Single'
      ingressTargetPort: 80
      ingressTransport:'auto'
      ingressAllowInsecure: false
      exposedPort: 0
      trafficWeight: 100
      trafficLatestRevision: true
      maxInactiveRevisions: 100
      containers: [
        {
          name: 'azure-function-container'
          image: 'mcr.microsoft.com/azure-functions/dotnet8-quickstart-demo:latest'
          resources: {
            // workaround as 'float' values are not supported in Bicep, yet the resource providers expects them. Related issue: https://github.com/Azure/bicep/issues/1386
            cpu: json('0.25')
            memory: '0.5Gi'
          }
        }
      ]
    }
  }
]
