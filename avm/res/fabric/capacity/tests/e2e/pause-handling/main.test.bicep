targetScope = 'subscription'

metadata name = 'Testing automatic pause handling'
metadata description = 'This instance deploys the module with automatic pause handling enabled to test SKU changes on paused capacities.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-fabric-capacities-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'fcpause'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. Email address used by resource. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-adminMembersSecret\'.')
@secure()
param adminMembersSecret string = ''

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// Managed Identity for deployment scripts
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${namePrefix}${serviceShort}-mi'
  location: resourceLocation
}

// Assign Contributor role to the managed identity
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: resourceGroup
  name: guid(resourceGroup.id, managedIdentity.id, 'Contributor')
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
    principalType: 'ServicePrincipal'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'sku-change']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      adminMembers: [
        adminMembersSecret
      ]
      skuName: iteration == 'init' ? 'F2' : 'F4'
      enableAutomaticPauseHandling: true
      restorePreviousState: true
      managedIdentities: {
        userAssignedResourceIds: [
          managedIdentity.id
        ]
      }
    }
    dependsOn: [
      roleAssignment
    ]
  }
]