targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-devcenter.project-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dcpwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// Hardcoded because service not available in all regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'westeurope'

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
    environmentTypeName: 'dep-${namePrefix}-et-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
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
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
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
          managedIdentities: {
            systemAssigned: false
            userAssignedResourceIds: [
              nestedDependencies.outputs.managedIdentityResourceId
            ]
          }
          creatorRoleAssignmentRoles: [
            'acdd72a7-3385-48ef-bd42-f606fba81ae7' // 'Reader'
          ]
        }
      ]
      pools: [
        {
          name: 'sandbox-pool'
          displayName: 'My Sandbox Pool - Managed Network'
          devBoxDefinitionType: 'Reference'
          devBoxDefinitionName: nestedDependencies.outputs.devboxDefinitionName
          localAdministrator: 'Disabled'
          virtualNetworkType: 'Managed'
          singleSignOnStatus: 'Enabled'
          stopOnDisconnect: {
            gracePeriodMinutes: 60
            status: 'Enabled'
          }
          managedVirtualNetworkRegion: 'westeurope'
        }
      ]
    }
  }
]
