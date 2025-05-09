targetScope = 'subscription'

metadata name = 'Using EntraID authentication'
metadata description = 'This instance deploys the module with EntraID authentication.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dbformysql.flexibleservers-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dfmsfsentid'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Required. Email address used by resource. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-adminMembersSecret\'.')
@secure()
param adminMembersSecret string = ''

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Pipeline is selecting random regions which dont support all cosmos features and have constraints when creating new cosmos
#disable-next-line no-hardcoded-location
var enforcedLocation = 'northeurope'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    location: enforcedLocation
    managedIdentityName: 'dep-${namePrefix}-mi-${serviceShort}'
    adminMembersSecret: adminMembersSecret
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
      location: enforcedLocation
      administratorLogin: 'adminUserName'
      administratorLoginPassword: password
      skuName: 'Standard_D2ds_v4'
      tier: 'GeneralPurpose'
      storageAutoGrow: 'Enabled'
      administrators: [
        {
          login: 'adminUserName'
          sid: nestedDependencies.outputs.entraAdminSid
          identityResourceId: nestedDependencies.outputs.managedIdentityResourceId
        }
      ]
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      advancedThreatProtection: 'Enabled'
    }
  }
]
