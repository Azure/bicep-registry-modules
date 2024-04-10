targetScope = 'managementGroup'
metadata name = 'Role Assignments (Management Group scope)'
metadata description = 'This module deploys a Role Assignment at a Management Group scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-authorization.roleassignments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'aramgmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
module nestedDependencies 'interim.dependencies.bicep' = {
  scope: subscription('[[subscriptionId]]')
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    resourceGroupName: resourceGroupName
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../management-group/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    principalId: nestedDependencies.outputs.managedIdentityPrincipalId
    roleDefinitionIdOrName: 'Storage Queue Data Reader'
    principalType: 'ServicePrincipal'
  }
}
