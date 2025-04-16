targetScope = 'managementGroup'
metadata name = 'Role Definition (Management Group scope) - Required Parameters'
metadata description = 'This module deploys a Role Definition at a Management Group scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'acrdmgmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}-rbac-custom-role-reader'
    actions: [
      '*/read'
    ]
    location: resourceLocation
  }
}
