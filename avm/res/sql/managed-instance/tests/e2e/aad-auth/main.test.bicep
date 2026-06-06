targetScope = 'subscription'

metadata name = 'With Azure AD-only authentication'
metadata description = 'This instance deploys the module with an Azure AD administrator and Azure AD-only authentication enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.managedinstances-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlmiaad'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    routeTableName: 'dep-${namePrefix}-rt-${serviceShort}'
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
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}-${serviceShort}'
      administratorLogin: 'adminUserName'
      administratorLoginPassword: password
      subnetResourceId: nestedDependencies.outputs.subnetResourceId
      managedIdentities: {
        systemAssigned: true
      }
      servicePrincipal: 'SystemAssigned'
      authenticationMetadata: 'AzureAD'
      aadAdministrator: {
        login: nestedDependencies.outputs.managedIdentityName
        sid: nestedDependencies.outputs.managedIdentityPrincipalId
        tenantId: subscription().tenantId
      }
      azureADOnlyAuthentication: true
    }
  }
]
