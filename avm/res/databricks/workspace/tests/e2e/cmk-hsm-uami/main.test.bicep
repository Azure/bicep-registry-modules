targetScope = 'subscription'

metadata name = 'Using managed HSM Customer-Managed-Keys with User-Assigned identity'
metadata description = 'This instance deploys the module with Managed HSM-based Customer Managed Key (CMK) encryption, using a User-Assigned Managed Identity to access the HSM key.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-databricks.workspaces-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dwhsm'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The object id of the AzureDatabricks Enterprise Application. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-AzureDatabricksEnterpriseApplicationObjectId\'.')
@secure()
param azureDatabricksEnterpriseApplicationObjectId string = ''

@description('Required. The resource ID of the Managed Identity used by the deployment script. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-deploymentMSIName\'.')
@secure()
param deploymentMSIResourceId string = ''

@description('Required. The resource ID of the managed HSM used for encryption. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-managedHSMResourceId\'.')
@secure()
param managedHSMResourceId string = ''

// Enforce location of HSM
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
  name: '${uniqueString(deployment().name)}-nestedDependencies'
  params: {
    databricksApplicationObjectId: azureDatabricksEnterpriseApplicationObjectId
    hsmKeyNamePrefix: '${serviceShort}-${namePrefix}-key'
    hsmDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
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
      customerManagedKey: {
        keyName: nestedDependencies.outputs.cmkName
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
        keyVersion: nestedDependencies.outputs.cmkVersion
      }
      customerManagedKeyManagedDisk: {
        keyName: nestedDependencies.outputs.cmkDiskName
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
        keyVersion: nestedDependencies.outputs.cmkDiskVersion
      }
    }
  }
]

// =============== //
// Post-Deployment //
// =============== //
// The managed-disk's disk-encryption-set requires its identity to have at least 'Key Vault Crypto Service Encryption User' permissions on the used key.
module configureHSM 'br/public:avm/res/resources/deployment-script:0.5.2' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-managedDiskEncryptionSetPermissions'
  scope: resourceGroup

  params: {
    name: 'dep-${namePrefix}-ds-configureHSMDisk-${serviceShort}'
    kind: 'AzureCLI'
    azCliVersion: '2.67.0'
    arguments: '"${last(split(managedHSMResourceId, '/'))}" "${nestedDependencies.outputs.cmkDiskName}" "${testDeployment[1].outputs.managedDiskIdentityPrincipalId!}"'
    scriptContent: '''
      # Allow key reference via identity
      az keyvault role assignment create --hsm-name $1 --role "Managed HSM Crypto Service Encryption User" --scope /keys/$2 --assignee $3
    '''
    retentionInterval: 'P1D'
    managedIdentities: {
      userAssignedResourceIds: [
        deploymentMSIResourceId
      ]
    }
  }
}
