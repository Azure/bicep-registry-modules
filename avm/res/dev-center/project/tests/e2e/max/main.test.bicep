targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-devcenter.project-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dcpmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

// Hardcoded because service not available in all regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'southeastasia'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    devCenterName: 'dep-${namePrefix}-dc-${serviceShort}'
    devCenterNetworkConnectionName: 'dep-${namePrefix}-dcnc-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    environmentTypeName: 'dep-${namePrefix}-et-${serviceShort}'
    managedIdentity1Name: 'dep-${namePrefix}-msi1-${serviceShort}'
    managedIdentity2Name: 'dep-${namePrefix}-msi2-${serviceShort}'
    roleDefinitionName: 'dep-${namePrefix}-customrole-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      displayName: 'My Dev Center Project'
      description: 'This is a test project for the Dev Center project module.'
      devCenterResourceId: nestedDependencies.outputs.devCenterResourceId
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentity1ResourceId
        ]
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      roleAssignments: [
        {
          principalId: nestedDependencies.outputs.managedIdentity1PrincipalId
          roleDefinitionIdOrName: 'DevCenter Project Admin'
          principalType: 'ServicePrincipal'
        }
        {
          principalId: deployer().objectId
          roleDefinitionIdOrName: 'DevCenter Project Admin'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentity1PrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentity1PrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      catalogSettings: {
        catalogItemSyncTypes: [
          'EnvironmentDefinition'
          'ImageDefinition'
        ]
      }
      maxDevBoxesPerUser: 2
      environmentTypes: [
        {
          name: 'dep-${namePrefix}-et-${serviceShort}'
          displayName: 'My Sandbox Environment Type'
          status: 'Enabled'
          deploymentTargetSubscriptionResourceId: subscription().id
          tags: {
            'prj-type': 'sandbox'
          }
          managedIdentities: {
            systemAssigned: false
            userAssignedResourceIds: [
              nestedDependencies.outputs.managedIdentity1ResourceId
            ]
          }
          roleAssignments: [
            {
              principalId: nestedDependencies.outputs.managedIdentity1PrincipalId
              roleDefinitionIdOrName: 'DevCenter Project Admin'
              principalType: 'ServicePrincipal'
            }
          ]
          creatorRoleAssignmentRoles: [
            'acdd72a7-3385-48ef-bd42-f606fba81ae7' // 'Reader'
            'b24988ac-6180-42a0-ab88-20f7382dd24c' // 'Contributor'
          ]
          userRoleAssignmentsRoles: [
            {
              objectId: nestedDependencies.outputs.managedIdentity1PrincipalId
              roleDefinitions: [
                'e503ece1-11d0-4e8e-8e2c-7a6c3bf38815' // 'AzureML Compute Operator'
                'b59867f0-fa02-499b-be73-45a86b5b3e1c' // 'Cognitive Services Data Reader'
              ]
            }
            {
              objectId: nestedDependencies.outputs.managedIdentity2PrincipalId
              roleDefinitions: [
                nestedDependencies.outputs.roleDefinitionId // Custom role
              ]
            }
          ]
        }
      ]
      catalogs: [
        {
          name: 'testCatalogGitHub'
          gitHub: {
            uri: 'https://github.com/microsoft/devcenter-catalog.git'
            branch: 'main'
            path: 'dotnet-dev-orchardcore'
            secretIdentifier: nestedDependencies.outputs.keyVaultSecretUri
          }
          syncType: 'Scheduled'
          tags: {
            'test-tag': 'test-value'
          }
        }
        {
          name: 'testCatalogAzureDevOpsGit'
          adoGit: {
            uri: 'https://contoso@dev.azure.com/contoso/your-project/_git/your-repo'
            branch: 'main'
            secretIdentifier: nestedDependencies.outputs.keyVaultSecretUri
          }
          syncType: 'Manual'
        }
      ]
      pools: [
        {
          name: 'sandbox-pool'
          displayName: 'My Sandbox Pool - Managed Network'
          devBoxDefinitionType: 'Reference'
          devBoxDefinitionName: nestedDependencies.outputs.devboxDefinitionName
          localAdministrator: 'Enabled'
          virtualNetworkType: 'Managed'
          singleSignOnStatus: 'Enabled'
          stopOnDisconnect: {
            gracePeriodMinutes: 60
            status: 'Enabled'
          }
          stopOnNoConnect: {
            gracePeriodMinutes: 30
            status: 'Enabled'
          }
          managedVirtualNetworkRegion: 'australiaeast'
          schedule: {
            state: 'Enabled'
            time: '18:30'
            timeZone: 'Australia/Sydney'
          }
        }
        {
          name: 'sandbox-pool-2'
          displayName: 'My Sandbox Pool - Unmanaged Network'
          devBoxDefinitionType: 'Reference'
          devBoxDefinitionName: nestedDependencies.outputs.devboxDefinitionName
          localAdministrator: 'Disabled'
          virtualNetworkType: 'Unmanaged'
          networkConnectionName: nestedDependencies.outputs.devCenterAttachedNetworkConnectionName
          singleSignOnStatus: 'Disabled'
        }
      ]
    }
  }
]
