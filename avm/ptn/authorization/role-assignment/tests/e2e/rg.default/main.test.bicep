targetScope = 'managementGroup'
metadata name = 'Role Assignments (Resource Group scope)'
metadata description = 'This module deploys a Role Assignment at a Resource Group scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-authorization.roleassignments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'arargmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = '#_subscriptionId_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
module resourceGroup 'br/public:avm/res/resources/resource-group:0.2.3' = {
  scope: subscription('${subscriptionId}')
  name: '${uniqueString(deployment().name, resourceLocation)}-resourceGroup'
  params: {
    name: resourceGroupName
    location: resourceLocation
  }
}
module nestedDependencies 'dependencies.bicep' = {
  scope: az.resourceGroup(subscriptionId, resourceGroupName)
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
  }
  dependsOn: [
    resourceGroup
  ]
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    principalId: nestedDependencies.outputs.managedIdentityPrincipalId
    roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
    principalType: 'ServicePrincipal'
    location: resourceLocation
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroup.outputs.name
  }
}
