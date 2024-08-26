targetScope = 'subscription'

metadata name = 'Creating Azure AI Studio resources'
metadata description = 'This instance deploys an Azure AI hub workspace.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-machinelearningservices.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mlswai'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

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
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    applicationInsightsName: 'dep-${namePrefix}-appI-${serviceShort}'
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    secondaryStorageAccountName: 'dep${namePrefix}st${serviceShort}2'
    aiServicesName: 'dep-${namePrefix}-ai-${serviceShort}'
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
      associatedApplicationInsightsResourceId: nestedDependencies.outputs.applicationInsightsResourceId
      associatedKeyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      associatedStorageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
      sku: 'Basic'
      kind: 'Hub'
      connections: [
        {
          name: 'ai'
          category: 'AIServices'
          target: nestedDependencies.outputs.aiServicesEndpoint
          connectionProperties: {
            authType: 'ApiKey'
            credentials: {
              key: 'key'
            }
          }
          metadata: {
            ApiType: 'Azure'
            ResourceId: nestedDependencies.outputs.aiServicesResourceId
            Location: resourceLocation
            ApiVersion: '2023-07-01-preview'
            DeploymentApiVersion: '2023-10-01-preview'
          }
        }
      ]
      workspaceHubConfig: {
        additionalWorkspaceStorageAccounts: [nestedDependencies.outputs.secondaryStorageAccountResourceId]
        defaultWorkspaceResourceGroup: resourceGroup.id
      }
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]

@batchSize(1)
module testProjectDeployment '../../../main.bicep' = [
  for (iteration, i) in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-proj-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}002'
      location: resourceLocation
      sku: 'Basic'
      kind: 'Project'
      hubResourceId: testDeployment[i].outputs.resourceId
    }
  }
]
