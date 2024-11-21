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
    location: resourceLocation
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-${resourceLocation}-msi-${serviceShort}'
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
      acrAdminUserEnabled: false
      acrSku: 'Standard'
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      roleAssignments: [
        {
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: '4633458b-17de-408a-b874-0445c86b69e6' // Key Vault Secrets User
        }
      ]
      credentialSets: [
        {
          name: 'docker-credential-set'
          authCredentials: [
            {
              name: 'Credential1'
              passwordSecretIdentifier: nestedDependencies.outputs.pwdSecretURI
              usernameSecretIdentifier: nestedDependencies.outputs.userNameSecretURI
            }
          ]
          loginServer: 'docker.io'
          managedIdentities: {
            systemAssigned: true
          }
        }
      ]
      cacheRules: [
        {
          name: 'docker-rule-with-credentials'
          sourceRepository: 'docker.io/library/hello-world'
          targetRepository: 'cached-docker-hub/hello-world'
          credentialSetResourceId: resourceId(
            subscription().subscriptionId,
            resourceGroup.name,
            'Microsoft.ContainerRegistry/registries/credentialSets',
            '${namePrefix}${serviceShort}001',
            'docker-credential-set'
          )
        }
        {
          name: 'mcr-rule-anonymous'
          sourceRepository: 'mcr.microsoft.com/*'
          targetRepository: 'cached-mcr/*'
        }
      ]
    }
  }
]
