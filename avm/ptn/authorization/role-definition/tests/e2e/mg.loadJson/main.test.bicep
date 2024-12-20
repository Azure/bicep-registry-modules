targetScope = 'managementGroup'
metadata name = 'Role Definition (Management Group scope) - Using loadJsonContent'
metadata description = 'This module deploys a Role Definition at a Management Group scope using loadJsonContent to load a custom role definition stored in a JSON file.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'acrdmgjson'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ============== //
// Test Execution //
// ============== //

param customRoleDefinitionJson object = loadJsonContent('lib/subscription_owner.alz_role_definition.json')

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: customRoleDefinitionJson.name
    roleName: customRoleDefinitionJson.properties.roleName
    description: customRoleDefinitionJson.properties.description
    actions: customRoleDefinitionJson.properties.permissions[0].actions
    notActions: customRoleDefinitionJson.properties.permissions[0].notActions
    dataActions: customRoleDefinitionJson.properties.permissions[0].dataActions
    notDataActions: customRoleDefinitionJson.properties.permissions[0].notDataActions
    location: resourceLocation
  }
}
