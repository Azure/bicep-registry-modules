targetScope = 'subscription'

metadata name = 'Using cache rules'
metadata description = 'This instance deploys the module with a credential set and a cache rule.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerregistry.registries-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'crrcach'

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
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    location: resourceLocation
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    acrName: '${namePrefix}${serviceShort}001'
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
      name: nestedDependencies.outputs.acrName
      location: resourceLocation
      acrAdminUserEnabled: false
      acrSku: 'Standard'
      credentialSets: [
        {
          name: 'default'
          managedIdentities: {
            systemAssigned: true
          }
          authCredentials: [
            {
              name: 'Credential1'
              usernameSecretIdentifier: nestedDependencies.outputs.userNameSecretURI
              passwordSecretIdentifier: nestedDependencies.outputs.pwdSecretURI
            }
          ]
          loginServer: 'docker.io'
        }
      ]
      cacheRules: [
        {
          name: 'customRule'
          sourceRepository: 'docker.io/library/hello-world'
          targetRepository: 'cached-docker-hub/hello-world'
          credentialSetResourceId: nestedDependencies.outputs.acrCredentialSetResourceId
        }
      ]
    }
  }
]
