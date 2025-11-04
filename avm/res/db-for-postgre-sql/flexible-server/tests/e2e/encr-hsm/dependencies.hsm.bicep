@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the HSM Vault to use.')
param managedHsmName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityResourceId string

@description('Required. The name of the Deployment script used to configure the HSM.')
param hsmDeploymentScriptName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: last(split(managedIdentityResourceId, '/'))
  scope: resourceGroup(split(managedIdentityResourceId, '/')[2], split(managedIdentityResourceId, '/')[4])
}

resource managedHsm 'Microsoft.KeyVault/managedHSMs@2025-05-01' existing = {
  name: managedHsmName

  resource key 'keys@2025-05-01' existing = {
    name: 'rsa-hsm-4096-key-1'
  }
}

// Grant identity (which is also used for the deployment script) to manage HSM instance
resource hsmPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${managedHsm.id}-${location}-${managedIdentity.id}-Key-Contributor-RoleAssignment')
  scope: managedHsm
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor
    principalType: 'ServicePrincipal'
  }
}

// Configure HSM
resource configureHSM 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: hsmDeploymentScriptName
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azCliVersion: '2.67.0'
    retentionInterval: 'P1D'
    arguments: '"${managedHsmName}" "${managedIdentity.properties.principalId}"'
    scriptContent: '''
      # Allow key reference via managedIdentity
      echo $1
      echo $2
      # Does not work as the deployment script MSI would need local-rbac admin permissions on the HSM in order to grant anyone else permissions
      # az keyvault role assignment create --hsm-name $1 --role "Managed HSM Crypto Service Encryption User" --assignee $2 --scope '/keys'

      # Allow usage via ARM
      az keyvault setting update --hsm-name $1 --name 'AllowKeyManagementOperationsThroughARM' --value 'true'
    '''
  }
  dependsOn: [hsmPermissions]
}

// https://mhsm-perm-avm-core-001.managedhsm.azure.net/keys/rsa-hsm-4096-key-1/providers/Microsoft.Authorization/roleAssignments/0cdd0d7f-585f-4dd2-85f1-130c6e6fc820?api-version=7.6
// {
//   properties: {
//     roleDefinitionId: 'Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/21dbd100-6940-42c2-9190-5d6cb909625b'
//     principalId: '89be5ce4-5546-47bb-ab81-006425375abf'
//   }
// }
// resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
//   name: guid('msi-${managedHsm::key.id}-${location}-${managedIdentity.id}-Key-Reader-RoleAssignment')
//   scope: managedHsm::key
//   properties: {
//     principalId: managedIdentity.properties.principalId
//     roleDefinitionId: 'Microsoft.KeyVault/providers/Microsoft.Authorization/roleDefinitions/0cdd0d7f-585f-4dd2-85f1-130c6e6fc820' // Managed HSM Crypto User
//     // roleDefinitionId: subscriptionResourceId(
//     //   'Microsoft.Authorization/roleDefinitions',
//     //   '33413926-3206-4cdd-b39a-83574fe37a17'
//     // ) // Managed HSM Crypto Service Encryption User
//     principalType: 'ServicePrincipal'
//   }
// }

@description('The resource ID of the HSM Key Vault.')
output keyVaultResourceId string = managedHsm.id

@description('The name of the HSMKey Vault Encryption Key.')
output keyName string = managedHsm::key.name
