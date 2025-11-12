targetScope = 'subscription'

metadata name = 'Using managed HSM Customer-Managed-Keys with User-Assigned identity'
metadata description = 'This instance deploys the module with Managed HSM-based Customer Managed Key (CMK) encryption, using a User-Assigned Managed Identity to access the HSM key.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-maps-account-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mahsmu'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The resource ID of the Managed Identity used by the deployment script. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-deploymentMSIName\'.')
@secure()
param deploymentMSIResourceId string = ''

//@description('Required. The resource ID of the managed HSM used for encryption. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-managedHSMResourceId\'.')
//@secure()
//param managedHSMResourceId string = ''
var managedHSMResourceId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/rsg-permanent-managed-hsm/providers/Microsoft.KeyVault/managedHSMs/lac-test-cluster'

// Note: Location 'uksouth' is not available for resource type 'Microsoft.Maps/accounts'.
//       List of available regions for the resource type is 'westcentralus', 'global', 'westus2', 'eastus', 'westeurope' & 'northeurope'.
var enforcedLocation = 'northeurope'

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
    hsmKeyName: '${serviceShort}-${namePrefix}-key'
    managedHSMName: last(split(managedHSMResourceId, '/'))
  }
  scope: az.resourceGroup(split(managedHSMResourceId, '/')[2], split(managedHSMResourceId, '/')[4])
}

module allowHsmAccess 'br/public:avm/res/resources/deployment-script:0.5.2' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-hmsKeyPermissions'
  scope: resourceGroup

  params: {
    name: 'dep-${namePrefix}-ds-hsm-iam-${serviceShort}'
    kind: 'AzureCLI'
    azCliVersion: '2.67.0'
    arguments: '"${last(split(managedHSMResourceId, '/'))}" "${nestedHsmDependencies.outputs.keyName}" "${nestedDependencies.outputs.managedIdentityPrincipalId}"'
    scriptContent: '''
      echo "Checking role assignment for HSM: $hsm_name, Key: $key_name, Principal: $principal_id"
      # Allow key reference via identity
      result=$(az keyvault role assignment list --hsm-name "$1" --scope "/keys/$2" --query "[?principalId == \`$3\` && roleName == \`Managed HSM Crypto Service Encryption User\`]")

      if [[ -n "$result" ]]; then
        echo "Role assignment already exists."
      else
        echo "Role assignment not yet existing. Creating."
        az keyvault role assignment create --hsm-name "$1" --role "Managed HSM Crypto Service Encryption User" --scope "/keys/$2" --assignee $3
      fi
    '''
    retentionInterval: 'P1D'
    managedIdentities: {
      userAssignedResourceIds: [
        deploymentMSIResourceId
      ]
    }
  }
}

// ============== //
// Test Execution //
// ============== //

// @batchSize(1)
// module testDeployment '../../../main.bicep' = [
//   for iteration in ['init', 'idem']: {
//     scope: resourceGroup
//     name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
//     params: {
//       name: '${namePrefix}${serviceShort}001'
//       customerManagedKey: {
//         keyName: nestedHsmDependencies.outputs.keyName
//         keyVaultResourceId: nestedHsmDependencies.outputs.keyVaultResourceId
//         userAssignedIdentityResourceId: nestedDependencies.outputs.managedIdentityResourceId
//         keyVersion: nestedHsmDependencies.outputs.keyVersion
//       }
//       managedIdentities: {
//         userAssignedResourceIds: [
//           nestedDependencies.outputs.managedIdentityResourceId
//         ]
//       }
//     }
//   }
// ]
