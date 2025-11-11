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
param serviceShort string = 'sshsm'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

module nestedHsmDependencies 'dependencies.hsm.bicep' = {
  name: '${uniqueString(deployment().name)}-nestedHSMDependencies'
  params: {
    managedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
    hsmKeyName: '${serviceShort}-srv-${namePrefix}-key'
    hsmDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}-srv'
    deploymentMSIResourceId: deploymentMSIResourceId
    managedHSMName: last(split(managedHSMResourceId, '/'))
  }
  scope: az.resourceGroup(split(managedHSMResourceId, '/')[2], split(managedHSMResourceId, '/')[4])
}

module nestedHsmDatabaseDependencies 'dependencies.hsm.bicep' = {
  name: '${uniqueString(deployment().name)}-nestedHSMDatabaseDependencies'
  params: {
    managedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
    hsmKeyName: '${serviceShort}-db-${namePrefix}-key'
    hsmDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}-db'
    deploymentMSIResourceId: deploymentMSIResourceId
    managedHSMName: last(split(managedHSMResourceId, '/'))
  }
  scope: az.resourceGroup(split(managedHSMResourceId, '/')[2], split(managedHSMResourceId, '/')[4])
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
        keyName: nestedHsmDependencies.outputs.keyName
        keyVaultResourceId: nestedHsmDependencies.outputs.keyVaultResourceId
        keyVersion: nestedHsmDependencies.outputs.keyVersion
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
            keyVaultResourceId: nestedHsmDatabaseDependencies.outputs.keyVaultResourceId
            keyName: nestedHsmDatabaseDependencies.outputs.keyName
            keyVersion: nestedHsmDatabaseDependencies.outputs.keyVersion
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
