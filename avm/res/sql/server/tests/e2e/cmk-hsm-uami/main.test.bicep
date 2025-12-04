targetScope = 'subscription'

metadata name = 'Using managed HSM Customer-Managed-Keys with User-Assigned identity'
metadata description = 'This instance deploys the module with Managed HSM-based Customer Managed Key (CMK) encryption, using a User-Assigned Managed Identity to access the HSM key.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sql.servers-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sshsmu'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Required. The resource ID of the Managed Identity used by the deployment script. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-deploymentMSIName\'.')
@secure()
param deploymentMSIResourceId string = ''

@description('Required. The resource ID of the managed HSM used for encryption. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-managedHSMResourceId\'.')
@secure()
param managedHSMResourceId string = ''

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
    primaryHSMKeyName: '${namePrefix}-${serviceShort}-srv-key-${substring(uniqueString(baseTime), 0, 3)}'
    secondaryHSMKeyName: '${namePrefix}-${serviceShort}-db-key-${substring(uniqueString(baseTime), 0, 3)}'
    hsmKeySize: 3072
    managedHSMName: last(split(managedHSMResourceId, '/'))
  }
  scope: az.resourceGroup(split(managedHSMResourceId, '/')[2], split(managedHSMResourceId, '/')[4])
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    primaryHSMKeyName: nestedHsmDependencies.outputs.primaryKeyName
    secondaryHSMKeyName: nestedHsmDependencies.?outputs.?secondaryKeyName
    deploymentScriptNamePrefix: 'dep-${namePrefix}-ds-${serviceShort}'
    deploymentMSIResourceId: deploymentMSIResourceId
    managedHSMResourceId: managedHSMResourceId
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
      primaryUserAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
      administrators: {
        azureADOnlyAuthentication: true
        login: 'myspn'
        sid: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'Application'
        tenantId: tenant().tenantId
      }
      managedIdentities: {
        systemAssigned: false
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      customerManagedKey: {
        keyName: nestedHsmDependencies.outputs.primaryKeyName
        keyVaultResourceId: nestedHsmDependencies.outputs.keyVaultResourceId
        keyVersion: nestedHsmDependencies.outputs.primaryKeyVersion
      }
      databases: [
        {
          name: '${namePrefix}-${serviceShort}-db-001'
          managedIdentities: {
            userAssignedResourceIds: [
              nestedDependencies.outputs.managedIdentityResourceId
            ]
          }
          customerManagedKey: {
            keyVaultResourceId: nestedHsmDependencies.outputs.keyVaultResourceId
            keyName: nestedHsmDependencies.outputs.secondaryKeyName!
            keyVersion: nestedHsmDependencies.outputs.secondaryKeyVersion!
          }
          sku: {
            name: 'Basic'
            tier: 'Basic'
          }
          maxSizeBytes: 2147483648
          zoneRedundant: false
          availabilityZone: -1
        }
      ]
    }
  }
]
