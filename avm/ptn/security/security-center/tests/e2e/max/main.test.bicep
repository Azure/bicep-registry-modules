targetScope = 'subscription'

metadata name = 'Using default parameter set'
metadata description = 'This instance deploys the module with default parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-security.azureSecurityCenter-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sascmax'

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
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      scope: subscription().id
      workspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
      location: resourceLocation
      securityContactProperties: {
        alertNotifications: 'Off'
        alertsToAdmins: 'Off'
        email: 'foo@contoso.com'
        phone: '+12345678'
      }
      deviceSecurityGroupProperties: {}
      ioTSecuritySolutionProperties: {}
    }
  }
]
