targetScope = 'subscription'

metadata name = 'With vulnerability assessment'
metadata description = 'This instance deploys the module with a vulnerability assessment.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.managedinstances-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlmivln'

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    pairedRegionScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    routeTableName: 'dep-${namePrefix}-rt-${serviceShort}'
    storageAccountName: toLower('dep${namePrefix}v${serviceShort}01')
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
      securityAlertPolicy: {
        emailAccountAdmins: true
        name: 'default'
        state: 'Enabled'
        storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
        emailAddresses: [
          'test1@contoso.com'
          'test2@contoso.com'
        ]
        disabledAlerts: [
          'Unsafe_Action'
        ]
        retentionDays: 7
      }
      vulnerabilityAssessment: {
        name: 'default'
        recurringScans: {
          isEnabled: true
          emailSubscriptionAdmins: true
          emails: [
            'test1@contoso.com'
            'test2@contoso.com'
          ]
        }
        storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
      }
    }
  }
]
