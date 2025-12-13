targetScope = 'subscription'

metadata name = 'Using managed HSM Customer-Managed-Keys with User-Assigned identity'
metadata description = 'This instance deploys the module with Managed HSM-based Customer Managed Key (CMK) encryption, using a User-Assigned Managed Identity to access the HSM key.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-dbformysql.flexibleservers-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dfmshsmu'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Required. The resource ID of the Managed Identity used by the deployment script. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-deploymentMSIName\'.')
@secure()
param deploymentMSIResourceId string = ''

@description('Required. The resource ID of the managed HSM used for encryption. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-managedHSMResourceId\'.')
@secure()
param managedHSMResourceId string = ''

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

var enforcedLocation = 'uksouth'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedHsmDependencies '../../../../../../../utilities/e2e-template-assets/templates/hsm.dependencies.bicep' = {
  name: '${uniqueString(deployment().name)}-nestedHsmDependencies'
  params: {
    primaryHSMKeyName: '${namePrefix}-${serviceShort}-key-${substring(uniqueString(baseTime), 0, 3)}'
    managedHSMName: last(split(managedHSMResourceId, '/'))
  }
  scope: az.resourceGroup(split(managedHSMResourceId, '/')[2], split(managedHSMResourceId, '/')[4])
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    deploymentMSIResourceId: deploymentMSIResourceId
    managedHSMResourceId: managedHSMResourceId
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    deploymentScriptName: 'dep-${namePrefix}-ds-hsm-iam-${serviceShort}'
    hSMKeyName: nestedHsmDependencies.outputs.primaryKeyName
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
      administratorLogin: 'adminUserName'
      administratorLoginPassword: password
      skuName: 'Standard_D2ds_v4'
      tier: 'GeneralPurpose'
      storageAutoGrow: 'Enabled'
      availabilityZone: -1
      geoRedundantBackup: 'Disabled' // Only validating CMK for primary instance
      customerManagedKey: {
        keyName: nestedHsmDependencies.outputs.primaryKeyName
        keyVaultResourceId: nestedHsmDependencies.outputs.keyVaultResourceId
        userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
        keyVersion: nestedHsmDependencies.outputs.primaryKeyVersion
      }
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
    }
  }
]
