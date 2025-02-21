targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azd-containerappupsert-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'acaumax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Container app stored secret to pass into environment variables. The value is a GUID.')
@secure()
param myCustomContainerAppSecret string = newGuid()

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
    location: resourceLocation
    managedEnvironmentName: 'dep-${namePrefix}-me-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-mi-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    keyVaultSecretName: 'dep-${namePrefix}-kv-secret-${serviceShort}'
    containerAppName: 'dep-${namePrefix}-ca-${serviceShort}'
    containerRegistryName: 'dep${namePrefix}cr${serviceShort}'
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
      name: nestedDependencies.outputs.existingcontainerAppName
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Env: 'test'
      }
      containerAppsEnvironmentName: nestedDependencies.outputs.containerAppsEnvironmentName
      location: resourceLocation
      identityType: 'UserAssigned'
      identityName: nestedDependencies.outputs.managedIdentityName
      containerRegistryName: nestedDependencies.outputs.containerRegistryName
      identityPrincipalId: nestedDependencies.outputs.managedIdentityPrincipalId
      userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      daprEnabled: true
      secrets: {
        secureList: [
          {
            name: 'containerappstoredsecret'
            value: myCustomContainerAppSecret
          }
          {
            name: 'keyvaultstoredsecret'
            keyVaultUrl: nestedDependencies.outputs.keyVaultSecretURI
            identity: nestedDependencies.outputs.managedIdentityResourceId
          }
        ]
      }
      env: [
        {
          name: 'ContainerAppStoredSecretName'
          secretRef: 'containerappstoredsecret'
        }
        {
          name: 'ContainerAppKeyVaultStoredSecretName'
          secretRef: 'keyvaultstoredsecret'
        }
      ]
      exists: true
    }
  }
]
