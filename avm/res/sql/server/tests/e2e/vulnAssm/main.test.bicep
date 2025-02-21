targetScope = 'subscription'

metadata name = 'With vulnerability assessment'
metadata description = 'This instance deploys the module with a vulnerability assessment.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.servers-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlsvln'

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
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    storageAccountName: 'dep${namePrefix}cdnstore${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}-${serviceShort}'
    primaryUserAssignedIdentityId: nestedDependencies.outputs.managedIdentityResourceId
    administratorLogin: 'adminUserName'
    administratorLoginPassword: password
    location: resourceLocation
    vulnerabilityAssessmentsObj: {
      name: 'default'
      recurringScans: {
        emails: [
          'test1@contoso.com'
          'test2@contoso.com'
        ]
        emailSubscriptionAdmins: true
        isEnabled: true
      }
      storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
      useStorageAccountAccessKey: false
      createStorageRoleAssignment: true
    }
    securityAlertPolicies: [
      {
        name: 'Default'
        state: 'Enabled'
        emailAccountAdmins: true
      }
    ]
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
  dependsOn: [
    nestedDependencies
  ]
}
