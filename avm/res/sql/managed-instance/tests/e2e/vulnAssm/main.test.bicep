targetScope = 'subscription'

metadata name = 'With vulnerability assessment'
metadata description = 'This instance deploys the module with a vulnerability assessment.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.managedinstances-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlmivln'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Variables   //
// =========== //

// The pipeline's random region selector includes regions where the AVM CI test subscription has no SQL MI
// vCore quota (e.g., northeurope) or where the regional service tag `AzureCloud.<region>` used by the
// route table is not honored (e.g., germanywestcentral). Pin this test to a known-good region.
var enforcedLocation = 'ukwest'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
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
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
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
